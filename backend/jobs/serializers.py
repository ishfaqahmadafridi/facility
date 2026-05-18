from rest_framework import serializers
from .models import JobCategory, Job, Ride, PortfolioItem, Review
from users.serializers import CustomerProfileSerializer, ProviderProfileSerializer

class JobCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = JobCategory
        fields = '__all__'

class JobSerializer(serializers.ModelSerializer):
    customer = CustomerProfileSerializer(read_only=True)
    provider = ProviderProfileSerializer(read_only=True)
    category_details = JobCategorySerializer(source='category', read_only=True)

    class Meta:
        model = Job
        fields = '__all__'
        read_only_fields = ('status', 'escrow_held', 'escrow_released', 'created_at', 'updated_at', 'customer', 'provider')

class RideSerializer(serializers.ModelSerializer):
    customer = CustomerProfileSerializer(read_only=True)
    rider = ProviderProfileSerializer(read_only=True)

    class Meta:
        model = Ride
        fields = '__all__'
        read_only_fields = (
            'status',
            'created_at',
            'updated_at',
            'customer',
            'rider',
            'agreed_fare',
            'is_counter_offer',
        )

class PortfolioItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = PortfolioItem
        fields = '__all__'
        read_only_fields = ('provider', 'created_at')

class ReviewSerializer(serializers.ModelSerializer):
    reviewer_name = serializers.CharField(source='reviewer.user.full_name', read_only=True)

    class Meta:
        model = Review
        fields = '__all__'
        read_only_fields = ('job', 'reviewer', 'provider', 'created_at')
