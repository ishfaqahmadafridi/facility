import random
from rest_framework import status, views
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from .models import User, OTPVerification, CustomerProfile, ProviderProfile, NurseProfile
from .serializers import SendOTPSerializer, VerifyOTPSerializer, CompleteProfileSerializer

def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

class SendOTPView(views.APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = SendOTPSerializer(data=request.data)
        if serializer.is_valid():
            phone_number = serializer.validated_data['phone_number']
            
            # Generate 6-digit OTP
            otp_code = str(random.randint(100000, 999999))
            
            # Mock sending SMS
            print(f"Mock SMS - Sending OTP {otp_code} to {phone_number}")
            
            # Save to DB
            OTPVerification.objects.create(phone_number=phone_number, otp_code=otp_code)
            
            return Response({'message': 'OTP sent successfully'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class VerifyOTPView(views.APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = VerifyOTPSerializer(data=request.data)
        if serializer.is_valid():
            phone_number = serializer.validated_data['phone_number']
            otp_code = serializer.validated_data['otp_code']
            
            # Find valid OTP
            otp_obj = OTPVerification.objects.filter(
                phone_number=phone_number, 
                otp_code=otp_code, 
                is_verified=False
            ).order_by('-created_at').first()
            
            if otp_obj and otp_obj.is_valid():
                otp_obj.is_verified = True
                otp_obj.save()
                
                # Get or Create User
                user, created = User.objects.get_or_create(phone_number=phone_number)
                
                # Default profile setup on first login
                if created:
                    CustomerProfile.objects.get_or_create(user=user)
                
                tokens = get_tokens_for_user(user)
                return Response({
                    'message': 'OTP verified successfully',
                    'is_new_user': created,
                    'tokens': tokens
                }, status=status.HTTP_200_OK)
            
            return Response({'error': 'Invalid or expired OTP'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CompleteProfileView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        serializer = CompleteProfileSerializer(data=request.data)
        
        if serializer.is_valid():
            data = serializer.validated_data
            
            # Update base user fields
            user.cnic = data.get('cnic', user.cnic)
            user.cnic_front = data.get('cnic_front', user.cnic_front)
            user.cnic_back = data.get('cnic_back', user.cnic_back)
            user.selfie = data.get('selfie', user.selfie)
            
            role = data.get('role', 'CUSTOMER')
            
            if role in ['PROVIDER', 'BOTH']:
                user.active_mode = 'PROVIDER'
                provider_prof, _ = ProviderProfile.objects.get_or_create(user=user)
                provider_prof.categories = data.get('categories', [])
                provider_prof.experience_years = data.get('experience_years', 0)
                provider_prof.bio = data.get('bio', '')
                provider_prof.video_intro = data.get('video_intro', None)
                provider_prof.save()
                
                if 'Nurse' in provider_prof.categories:
                    nurse_prof, _ = NurseProfile.objects.get_or_create(provider_profile=provider_prof)
                    nurse_prof.nursing_license = data.get('nursing_license', None)
                    nurse_prof.specializations = data.get('specializations', [])
                    nurse_prof.kit_available = data.get('kit_available', False)
                    nurse_prof.save()
            else:
                user.active_mode = 'CUSTOMER'
            
            user.is_verified = True # Realistically, verify via admin, but let's mock it
            user.save()
            
            # Ensure customer profile exists
            CustomerProfile.objects.get_or_create(user=user)
            
            return Response({'message': 'Profile completed successfully'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class SwitchModeView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        new_mode = request.data.get('mode')
        
        if new_mode not in ['CUSTOMER', 'PROVIDER']:
            return Response({'error': 'Invalid mode. Must be CUSTOMER or PROVIDER.'}, status=status.HTTP_400_BAD_REQUEST)
        
        if new_mode == 'PROVIDER':
            # Check if user has a provider profile
            if not hasattr(user, 'provider_profile'):
                return Response({'error': 'Cannot switch to PROVIDER mode without completing provider profile.'}, status=status.HTTP_400_BAD_REQUEST)
        
        user.active_mode = new_mode
        user.save()
        return Response({'message': f'Successfully switched to {new_mode} mode.'}, status=status.HTTP_200_OK)

class ToggleOnlineView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        
        if not hasattr(user, 'provider_profile'):
            return Response({'error': 'User does not have a provider profile.'}, status=status.HTTP_400_BAD_REQUEST)
            
        provider_profile = user.provider_profile
        is_online = request.data.get('is_online')
        
        if is_online is None:
            return Response({'error': 'is_online field is required (boolean).'}, status=status.HTTP_400_BAD_REQUEST)
            
        provider_profile.is_online = bool(is_online)
        
        # Optionally update location if provided
        lat = request.data.get('latitude')
        lng = request.data.get('longitude')
        if lat is not None and lng is not None:
            provider_profile.latitude = float(lat)
            provider_profile.longitude = float(lng)

        if 'is_rider_mode' in request.data:
            provider_profile.is_rider_mode = bool(request.data.get('is_rider_mode'))
            
        provider_profile.save()
        status_text = 'Online' if provider_profile.is_online else 'Offline'
        return Response({'message': f'Provider is now {status_text}.'}, status=status.HTTP_200_OK)

class ToggleRiderModeView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user

        if not hasattr(user, 'provider_profile'):
            return Response({'error': 'User does not have a provider profile.'}, status=status.HTTP_400_BAD_REQUEST)

        provider_profile = user.provider_profile
        is_rider_mode = request.data.get('is_rider_mode')
        if is_rider_mode is None:
            return Response({'error': 'is_rider_mode field is required (boolean).'}, status=status.HTTP_400_BAD_REQUEST)

        provider_profile.is_rider_mode = bool(is_rider_mode)
        provider_profile.save()
        state = 'enabled' if provider_profile.is_rider_mode else 'disabled'
        return Response({'message': f'Rider mode {state}.'}, status=status.HTTP_200_OK)

class ProviderProfileView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        try:
            from .serializers import ProviderProfileSerializer
            provider = ProviderProfile.objects.get(pk=pk)
            serializer = ProviderProfileSerializer(provider)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except ProviderProfile.DoesNotExist:
            return Response({'error': 'Provider not found.'}, status=status.HTTP_404_NOT_FOUND)

class CurrentProviderProfileView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if not hasattr(request.user, 'provider_profile'):
            return Response({'error': 'Provider profile not found.'}, status=status.HTTP_404_NOT_FOUND)

        from .serializers import ProviderProfileSerializer
        serializer = ProviderProfileSerializer(request.user.provider_profile)
        return Response(serializer.data, status=status.HTTP_200_OK)
