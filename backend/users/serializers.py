from rest_framework import serializers
from .models import User, CustomerProfile, ProviderProfile, NurseProfile

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'phone_number', 'cnic', 'cnic_front', 'cnic_back', 'selfie', 'active_mode', 'is_verified', 'full_name', 'gender', 'emergency_contact')
        read_only_fields = ('id', 'is_verified', 'phone_number')

class CustomerProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomerProfile
        fields = ('id', 'rating')
        read_only_fields = ('id', 'rating')

class ProviderProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProviderProfile
        fields = ('id', 'categories', 'experience_years', 'bio', 'police_verified', 'is_online', 'latitude', 'longitude', 'rating', 'video_intro')
        read_only_fields = ('id', 'rating', 'police_verified')

class NurseProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = NurseProfile
        fields = ('id', 'nursing_license', 'specializations', 'kit_available', 'health_declaration')
        read_only_fields = ('id',)

class SendOTPSerializer(serializers.Serializer):
    phone_number = serializers.CharField(max_length=20)

class VerifyOTPSerializer(serializers.Serializer):
    phone_number = serializers.CharField(max_length=20)
    otp_code = serializers.CharField(max_length=6)

class CompleteProfileSerializer(serializers.ModelSerializer):
    # Depending on role, we expect nested data or flat data. For simplicity, flat data here:
    role = serializers.ChoiceField(choices=['CUSTOMER', 'PROVIDER', 'BOTH'])
    
    # Provider specifics
    categories = serializers.ListField(child=serializers.CharField(), required=False)
    experience_years = serializers.IntegerField(required=False)
    bio = serializers.CharField(required=False, allow_blank=True)
    video_intro = serializers.FileField(required=False)
    
    # Nurse specifics
    nursing_license = serializers.ImageField(required=False)
    specializations = serializers.ListField(child=serializers.CharField(), required=False)
    kit_available = serializers.BooleanField(required=False)

    class Meta:
        model = User
        fields = ('cnic', 'cnic_front', 'cnic_back', 'selfie', 'role', 
                  'categories', 'experience_years', 'bio', 'video_intro', 
                  'nursing_license', 'specializations', 'kit_available')
