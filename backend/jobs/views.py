import math
from decimal import Decimal, InvalidOperation
from rest_framework import generics, views, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import JobCategory, Job, Ride, PortfolioItem, Review
from .serializers import (
    JobCategorySerializer, JobSerializer, RideSerializer,
    PortfolioItemSerializer, ReviewSerializer,
)
from users.models import ProviderProfile

def haversine(lat1, lon1, lat2, lon2):
    # Radius of earth in kilometers
    R = 6371.0
    
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    
    a = math.sin(dlat / 2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    
    return R * c

class CategoriesView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    queryset = JobCategory.objects.all()
    serializer_class = JobCategorySerializer

class ProvidersNearbyView(views.APIView):
    """
    Retrieves a list of nearby providers based on the user's location.
    
    idea.odt Compliance: 5.3 Women Safety Filter
    - Includes a strict `women_only` parameter. If activated, it validates
      that the requesting customer is female, and only returns female providers.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        
        # Ensure user is in CUSTOMER mode
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'You must be in CUSTOMER mode to search for providers.'}, status=status.HTTP_403_FORBIDDEN)
            
        # Parse query parameters
        lat = request.query_params.get('latitude')
        lng = request.query_params.get('longitude')
        radius = request.query_params.get('radius', 10) # default 10km
        category = request.query_params.get('category')
        women_only = request.query_params.get('women_only', 'false').lower() == 'true'
        
        # --- Women Safety Filter Validation ---
        if women_only and user.gender != 'F':
            return Response(
                {'error': 'Women only filter is restricted to female customers.'}, 
                status=status.HTTP_403_FORBIDDEN
            )
        
        if not lat or not lng:
            return Response({'error': 'latitude and longitude are required.'}, status=status.HTTP_400_BAD_REQUEST)
            
        try:
            lat = float(lat)
            lng = float(lng)
            radius = float(radius)
        except ValueError:
            return Response({'error': 'Invalid latitude, longitude, or radius.'}, status=status.HTTP_400_BAD_REQUEST)
            
        # Base Query: Get online providers
        providers = ProviderProfile.objects.filter(is_online=True).exclude(user=user)
        
        # Apply Women Safety Filter
        if women_only:
            providers = providers.filter(user__gender='F')
            
        nearby_providers = []
        for provider in providers:
            # Skip providers without an active location
            if provider.latitude is None or provider.longitude is None:
                continue
                
            distance = haversine(lat, lng, provider.latitude, provider.longitude)
            if distance <= radius:
                # Optionally filter by category
                if category:
                    if category not in provider.categories:
                        continue
                        
                from users.serializers import ProviderProfileSerializer
                serializer = ProviderProfileSerializer(provider)
                provider_data = serializer.data
                provider_data['distance_km'] = round(distance, 2)
                nearby_providers.append(provider_data)
                
        # Sort by distance (closest first)
        nearby_providers.sort(key=lambda x: x['distance_km'])
        
        return Response({'providers': nearby_providers}, status=status.HTTP_200_OK)

class AvailableJobsView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        
        # Ensure user is in PROVIDER mode
        if user.active_mode != 'PROVIDER':
            return Response({'error': 'You must be in PROVIDER mode to view available jobs.'}, status=status.HTTP_403_FORBIDDEN)
            
        if not hasattr(user, 'provider_profile'):
            return Response({'error': 'Provider profile not found.'}, status=status.HTTP_400_BAD_REQUEST)
            
        provider = user.provider_profile
        
        lat = provider.latitude
        lng = provider.longitude
        radius = request.query_params.get('radius', 15) # default 15km
        
        if lat is None or lng is None:
            return Response({'error': 'Provider location is not set. Please set your location to view jobs.'}, status=status.HTTP_400_BAD_REQUEST)
            
        try:
            radius = float(radius)
        except ValueError:
            return Response({'error': 'Invalid radius.'}, status=status.HTTP_400_BAD_REQUEST)
            
        # Get pending jobs
        jobs = Job.objects.filter(status='PENDING')
        
        available_jobs = []
        for job in jobs:
            distance = haversine(lat, lng, job.latitude, job.longitude)
            if distance <= radius:
                # Filter by provider categories
                if job.category and job.category.name not in provider.categories:
                    continue
                    
                serializer = JobSerializer(job)
                job_data = serializer.data
                job_data['distance_km'] = round(distance, 2)
                available_jobs.append(job_data)
                
        # Sort by distance
        available_jobs.sort(key=lambda x: x['distance_km'])
        
        return Response({'jobs': available_jobs}, status=status.HTTP_200_OK)

class CreateJobView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'Must be in CUSTOMER mode.'}, status=status.HTTP_403_FORBIDDEN)
            
        data = request.data
        try:
            job = Job.objects.create(
                customer=user.customer_profile,
                category_id=data.get('category_id'),
                title=data.get('title'),
                description=data.get('description'),
                price=data.get('price'),
                latitude=data.get('latitude'),
                longitude=data.get('longitude'),
                address=data.get('address'),
                escrow_held=True # Simulated payment
            )
            return Response(JobSerializer(job).data, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

class ProviderAcceptJobView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        user = request.user
        if user.active_mode != 'PROVIDER':
            return Response({'error': 'Must be in PROVIDER mode.'}, status=status.HTTP_403_FORBIDDEN)
            
        try:
            job = Job.objects.get(pk=pk, status='PENDING')
            job.provider = user.provider_profile
            job.status = 'ACCEPTED'
            job.save()
            return Response({'message': 'Job accepted.'}, status=status.HTTP_200_OK)
        except Job.DoesNotExist:
            return Response({'error': 'Job not found or not available.'}, status=status.HTTP_404_NOT_FOUND)

class CustomerCompleteJobView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        user = request.user
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'Must be in CUSTOMER mode.'}, status=status.HTTP_403_FORBIDDEN)
            
        try:
            job = Job.objects.get(pk=pk, customer=user.customer_profile, status__in=['ACCEPTED', 'IN_PROGRESS'])
            job.status = 'COMPLETED'
            job.escrow_released = True
            job.save()
            return Response({'message': 'Job completed and escrow released.'}, status=status.HTTP_200_OK)
        except Job.DoesNotExist:
            return Response({'error': 'Job not found or invalid status.'}, status=status.HTTP_404_NOT_FOUND)

class CreateRideView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'Must be in CUSTOMER mode.'}, status=status.HTTP_403_FORBIDDEN)
            
        data = request.data

        required_fields = (
            'pickup_latitude',
            'pickup_longitude',
            'pickup_address',
            'dropoff_latitude',
            'dropoff_longitude',
            'dropoff_address',
            'suggested_fare',
        )
        missing_fields = [field for field in required_fields if data.get(field) in (None, '')]
        if missing_fields:
            return Response(
                {'error': f"Missing required ride fields: {', '.join(missing_fields)}"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            suggested_fare = Decimal(str(data.get('suggested_fare')))
            ride = Ride.objects.create(
                customer=user.customer_profile,
                pickup_latitude=float(data.get('pickup_latitude')),
                pickup_longitude=float(data.get('pickup_longitude')),
                pickup_address=data.get('pickup_address'),
                dropoff_latitude=float(data.get('dropoff_latitude')),
                dropoff_longitude=float(data.get('dropoff_longitude')),
                dropoff_address=data.get('dropoff_address'),
                suggested_fare=suggested_fare,
            )
            return Response(RideSerializer(ride).data, status=status.HTTP_201_CREATED)
        except (TypeError, ValueError, InvalidOperation):
            return Response(
                {'error': 'Ride coordinates and fare must be valid numeric values.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

class AvailableRidesView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user

        if user.active_mode != 'PROVIDER':
            return Response(
                {'error': 'You must be in PROVIDER mode to view available rides.'},
                status=status.HTTP_403_FORBIDDEN,
            )

        if not hasattr(user, 'provider_profile'):
            return Response({'error': 'Provider profile not found.'}, status=status.HTTP_400_BAD_REQUEST)

        provider = user.provider_profile
        if not provider.is_rider_mode:
            return Response(
                {'error': 'Enable Rider Mode to receive ride requests.'},
                status=status.HTTP_403_FORBIDDEN,
            )
        if provider.latitude is None or provider.longitude is None:
            return Response(
                {'error': 'Provider location is not set. Please go online with location enabled.'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        radius = request.query_params.get('radius', 15)
        try:
            radius = float(radius)
        except ValueError:
            return Response({'error': 'Invalid radius.'}, status=status.HTTP_400_BAD_REQUEST)

        rides = Ride.objects.filter(status='PENDING').select_related('customer__user')
        available_rides = []
        for ride in rides:
            distance = haversine(
                provider.latitude,
                provider.longitude,
                ride.pickup_latitude,
                ride.pickup_longitude,
            )
            if distance <= radius:
                ride_data = RideSerializer(ride).data
                ride_data['distance_km'] = round(distance, 2)
                available_rides.append(ride_data)

        available_rides.sort(key=lambda item: item['distance_km'])
        return Response({'rides': available_rides}, status=status.HTTP_200_OK)

class RiderAcceptRideView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        user = request.user
        if user.active_mode != 'PROVIDER':
            return Response({'error': 'Must be in PROVIDER mode.'}, status=status.HTTP_403_FORBIDDEN)

        if not hasattr(user, 'provider_profile') or not user.provider_profile.is_rider_mode:
            return Response({'error': 'Enable Rider Mode to accept rides.'}, status=status.HTTP_403_FORBIDDEN)
            
        try:
            ride = Ride.objects.get(pk=pk, status='PENDING')
            ride.rider = user.provider_profile
            ride.status = 'ACCEPTED'
            ride.agreed_fare = ride.suggested_fare
            ride.is_counter_offer = False
            ride.save()
            return Response(
                {
                    'message': 'Ride accepted.',
                    'ride': RideSerializer(ride).data,
                },
                status=status.HTTP_200_OK,
            )
        except Ride.DoesNotExist:
            return Response({'error': 'Ride not found or not available.'}, status=status.HTTP_404_NOT_FOUND)

class RiderOfferRideView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        user = request.user
        if user.active_mode != 'PROVIDER':
            return Response({'error': 'Must be in PROVIDER mode.'}, status=status.HTTP_403_FORBIDDEN)

        if not hasattr(user, 'provider_profile'):
            return Response({'error': 'Provider profile not found.'}, status=status.HTTP_400_BAD_REQUEST)

        if not user.provider_profile.is_rider_mode:
            return Response({'error': 'Enable Rider Mode to counter rides.'}, status=status.HTTP_403_FORBIDDEN)

        amount = request.data.get('amount')
        if amount in (None, ''):
            return Response({'error': 'amount is required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            offered_amount = Decimal(str(amount))
        except InvalidOperation:
            return Response({'error': 'amount must be numeric.'}, status=status.HTTP_400_BAD_REQUEST)

        if offered_amount <= 0:
            return Response({'error': 'amount must be greater than zero.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            ride = Ride.objects.get(pk=pk, status='PENDING')
        except Ride.DoesNotExist:
            return Response({'error': 'Ride not found or not available.'}, status=status.HTTP_404_NOT_FOUND)

        ride.rider = user.provider_profile
        ride.status = 'COUNTERED'
        ride.agreed_fare = offered_amount
        ride.is_counter_offer = ride.suggested_fare is not None and offered_amount != ride.suggested_fare
        ride.save()

        return Response(
            {
                'message': 'Counter-offer sent. Waiting for customer approval.' if ride.is_counter_offer else 'Ride accepted.',
                'ride': RideSerializer(ride).data,
            },
            status=status.HTTP_200_OK,
        )

class CustomerAcceptCounterOfferView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        user = request.user
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'Must be in CUSTOMER mode.'}, status=status.HTTP_403_FORBIDDEN)

        try:
            ride = Ride.objects.get(pk=pk, customer=user.customer_profile, status='COUNTERED')
        except Ride.DoesNotExist:
            return Response({'error': 'Counter-offer not found.'}, status=status.HTTP_404_NOT_FOUND)

        ride.status = 'ACCEPTED'
        ride.save()

        return Response(
            {
                'message': 'Counter-offer accepted.',
                'ride': RideSerializer(ride).data,
            },
            status=status.HTTP_200_OK,
        )

class CustomerDeclineCounterOfferView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        user = request.user
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'Must be in CUSTOMER mode.'}, status=status.HTTP_403_FORBIDDEN)

        try:
            ride = Ride.objects.get(pk=pk, customer=user.customer_profile, status='COUNTERED')
        except Ride.DoesNotExist:
            return Response({'error': 'Counter-offer not found.'}, status=status.HTTP_404_NOT_FOUND)

        ride.status = 'PENDING'
        ride.rider = None
        ride.agreed_fare = None
        ride.is_counter_offer = False
        ride.save()

        return Response(
            {
                'message': 'Counter-offer declined. Ride request is live again.',
                'ride': RideSerializer(ride).data,
            },
            status=status.HTTP_200_OK,
        )

class ActiveJobsView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        
        if user.active_mode == 'PROVIDER':
            if not hasattr(user, 'provider_profile'):
                return Response({'error': 'Not a provider'}, status=status.HTTP_400_BAD_REQUEST)
            jobs = Job.objects.filter(
                provider=user.provider_profile, 
                status__in=['ACCEPTED', 'IN_PROGRESS']
            )
            rides = Ride.objects.filter(
                rider=user.provider_profile,
                status__in=['COUNTERED', 'ACCEPTED', 'IN_PROGRESS']
            )
        else:
            jobs = Job.objects.filter(
                customer=user.customer_profile,
                status__in=['PENDING', 'ACCEPTED', 'IN_PROGRESS']
            )
            rides = Ride.objects.filter(
                customer=user.customer_profile,
                status__in=['PENDING', 'COUNTERED', 'ACCEPTED', 'IN_PROGRESS']
            )
            
        return Response({
            'jobs': JobSerializer(jobs, many=True).data,
            'rides': RideSerializer(rides, many=True).data
        }, status=status.HTTP_200_OK)

class JobHistoryView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user

        if user.active_mode == 'PROVIDER':
            if not hasattr(user, 'provider_profile'):
                return Response({'error': 'Not a provider'}, status=status.HTTP_400_BAD_REQUEST)
            jobs = Job.objects.filter(
                provider=user.provider_profile,
                status__in=['COMPLETED', 'DISPUTED', 'CANCELLED']
            ).order_by('-updated_at')
        else:
            jobs = Job.objects.filter(
                customer=user.customer_profile,
                status__in=['COMPLETED', 'DISPUTED', 'CANCELLED']
            ).order_by('-updated_at')

        return Response({
            'jobs': JobSerializer(jobs, many=True).data,
        }, status=status.HTTP_200_OK)

class EstimatorView(views.APIView):
    """
    Provides standard service rates and material cost estimates.
    
    idea.odt Compliance: 5.3 Labour Rate & Material Estimator
    - Returns standardized hourly rates for various service categories.
    - Calculates total estimated cost based on requested hours.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Parse query parameters
        category = request.query_params.get('category', 'Labour')
        hours_param = request.query_params.get('hours', 1)
        
        # Validate hours input
        try:
            hours = float(hours_param)
            if hours <= 0:
                hours = 1.0
        except ValueError:
            hours = 1.0
            
        # Standardized Rate Card (PKR/hour)
        # Note: In a production environment, this should ideally be fetched 
        # from a database table (e.g., JobCategory model) to allow dynamic updates.
        rate_card = {
            'Labour': 1500,
            'Plumber': 2000,
            'Electrician': 2000,
            'Painter': 1800,
            'Nurse': 3000
        }
        
        # Calculate estimate
        hourly_rate = rate_card.get(category, 1500)
        estimated_cost = hourly_rate * hours
        
        return Response({
            'category': category,
            'hourly_rate': hourly_rate,
            'estimated_hours': hours,
            'total_estimated_cost': estimated_cost
        }, status=status.HTTP_200_OK)


# ── Portfolio CRUD ────────────────────────────────────────────────────────────

class PortfolioListCreateView(views.APIView):
    """
    idea.odt Compliance: §6 Provider Profile & §11 Portfolio Management.
    GET  — List all portfolio items for the authenticated provider.
    POST — Upload a new portfolio image with an optional description.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if not hasattr(request.user, 'provider_profile'):
            return Response({'error': 'Provider profile not found.'}, status=status.HTTP_400_BAD_REQUEST)

        items = PortfolioItem.objects.filter(
            provider=request.user.provider_profile
        ).order_by('-created_at')
        return Response(
            PortfolioItemSerializer(items, many=True, context={'request': request}).data,
            status=status.HTTP_200_OK,
        )

    def post(self, request):
        if not hasattr(request.user, 'provider_profile'):
            return Response({'error': 'Provider profile not found.'}, status=status.HTTP_400_BAD_REQUEST)

        serializer = PortfolioItemSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save(provider=request.user.provider_profile)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PortfolioDeleteView(views.APIView):
    """
    Allows a provider to delete their own portfolio item.
    """
    permission_classes = [IsAuthenticated]

    def delete(self, request, pk):
        if not hasattr(request.user, 'provider_profile'):
            return Response({'error': 'Provider profile not found.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            item = PortfolioItem.objects.get(pk=pk, provider=request.user.provider_profile)
        except PortfolioItem.DoesNotExist:
            return Response({'error': 'Portfolio item not found.'}, status=status.HTTP_404_NOT_FOUND)

        item.delete()
        return Response({'message': 'Portfolio item deleted.'}, status=status.HTTP_200_OK)


# ── Reviews CRUD ──────────────────────────────────────────────────────────────

class ReviewCreateView(views.APIView):
    """
    idea.odt Compliance: §6 Provider Profile Reviews.
    Allows a customer to submit a star rating and text review for a COMPLETED job.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request, job_id):
        user = request.user

        # Only customers can leave reviews
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'Must be in CUSTOMER mode.'}, status=status.HTTP_403_FORBIDDEN)

        try:
            job = Job.objects.get(pk=job_id, customer=user.customer_profile, status='COMPLETED')
        except Job.DoesNotExist:
            return Response(
                {'error': 'Job not found or not yet completed.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        # Prevent duplicate reviews
        if hasattr(job, 'review'):
            return Response({'error': 'A review already exists for this job.'}, status=status.HTTP_400_BAD_REQUEST)

        if job.provider is None:
            return Response({'error': 'Job has no assigned provider to review.'}, status=status.HTTP_400_BAD_REQUEST)

        serializer = ReviewSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(
                job=job,
                reviewer=user.customer_profile,
                provider=job.provider,
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ProviderReviewsListView(views.APIView):
    """
    Returns all reviews for a given provider. Public-facing for the profile page.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request, provider_id):
        try:
            provider = ProviderProfile.objects.get(pk=provider_id)
        except ProviderProfile.DoesNotExist:
            return Response({'error': 'Provider not found.'}, status=status.HTTP_404_NOT_FOUND)

        reviews = Review.objects.filter(provider=provider).order_by('-created_at')
        return Response(
            ReviewSerializer(reviews, many=True).data,
            status=status.HTTP_200_OK,
        )
