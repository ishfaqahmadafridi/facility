import math
from rest_framework import generics, views, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import JobCategory, Job
from .serializers import JobCategorySerializer, JobSerializer
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
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        
        # Ensure user is in CUSTOMER mode
        if user.active_mode != 'CUSTOMER':
            return Response({'error': 'You must be in CUSTOMER mode to search for providers.'}, status=status.HTTP_403_FORBIDDEN)
            
        lat = request.query_params.get('latitude')
        lng = request.query_params.get('longitude')
        radius = request.query_params.get('radius', 10) # default 10km
        category = request.query_params.get('category')
        women_only = request.query_params.get('women_only', 'false').lower() == 'true'
        
        if women_only and user.gender != 'F':
            return Response({'error': 'Women only filter is restricted to female customers.'}, status=status.HTTP_403_FORBIDDEN)
        
        if not lat or not lng:
            return Response({'error': 'latitude and longitude are required.'}, status=status.HTTP_400_BAD_REQUEST)
            
        try:
            lat = float(lat)
            lng = float(lng)
            radius = float(radius)
        except ValueError:
            return Response({'error': 'Invalid latitude, longitude, or radius.'}, status=status.HTTP_400_BAD_REQUEST)
            
        # Get online providers
        providers = ProviderProfile.objects.filter(is_online=True).exclude(user=user)
        
        if women_only:
            providers = providers.filter(user__gender='F')
            
        nearby_providers = []
        for provider in providers:
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
                
        # Sort by distance
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
        from .models import Ride
        from .serializers import RideSerializer
        try:
            ride = Ride.objects.create(
                customer=user.customer_profile,
                pickup_latitude=data.get('pickup_latitude'),
                pickup_longitude=data.get('pickup_longitude'),
                pickup_address=data.get('pickup_address'),
                dropoff_latitude=data.get('dropoff_latitude'),
                dropoff_longitude=data.get('dropoff_longitude'),
                dropoff_address=data.get('dropoff_address'),
                suggested_fare=data.get('suggested_fare')
            )
            return Response(RideSerializer(ride).data, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

class RiderAcceptRideView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        user = request.user
        if user.active_mode != 'PROVIDER':
            return Response({'error': 'Must be in PROVIDER mode.'}, status=status.HTTP_403_FORBIDDEN)
            
        from .models import Ride
        try:
            ride = Ride.objects.get(pk=pk, status='PENDING')
            ride.rider = user.provider_profile
            ride.status = 'ACCEPTED'
            ride.save()
            return Response({'message': 'Ride accepted.'}, status=status.HTTP_200_OK)
        except Ride.DoesNotExist:
            return Response({'error': 'Ride not found or not available.'}, status=status.HTTP_404_NOT_FOUND)

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
            from .models import Ride
            from .serializers import RideSerializer
            rides = Ride.objects.filter(
                rider=user.provider_profile,
                status__in=['ACCEPTED', 'IN_PROGRESS']
            )
        else:
            jobs = Job.objects.filter(
                customer=user.customer_profile,
                status__in=['PENDING', 'ACCEPTED', 'IN_PROGRESS']
            )
            from .models import Ride
            from .serializers import RideSerializer
            rides = Ride.objects.filter(
                customer=user.customer_profile,
                status__in=['PENDING', 'ACCEPTED', 'IN_PROGRESS']
            )
            
        return Response({
            'jobs': JobSerializer(jobs, many=True).data,
            'rides': RideSerializer(rides, many=True).data
        }, status=status.HTTP_200_OK)

class EstimatorView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # A simple estimator logic returning standard rates
        # In a real application, this would calculate dynamically based on region
        category = request.query_params.get('category', 'Labour')
        hours = request.query_params.get('hours', 1)
        
        try:
            hours = float(hours)
        except ValueError:
            hours = 1.0
            
        rate_card = {
            'Labour': 1500,
            'Plumber': 2000,
            'Electrician': 2000,
            'Painter': 1800,
            'Nurse': 3000
        }
        
        hourly_rate = rate_card.get(category, 1500)
        estimated_cost = hourly_rate * hours
        
        return Response({
            'category': category,
            'hourly_rate': hourly_rate,
            'estimated_hours': hours,
            'total_estimated_cost': estimated_cost
        }, status=status.HTTP_200_OK)
