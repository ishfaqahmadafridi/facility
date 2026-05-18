from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.db import models
from django.utils import timezone

class UserManager(BaseUserManager):
    def create_user(self, phone_number, password=None, **extra_fields):
        if not phone_number:
            raise ValueError('The Phone Number field must be set')
        user = self.model(phone_number=phone_number, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, phone_number, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(phone_number, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    MODE_CHOICES = (
        ('CUSTOMER', 'Customer'),
        ('PROVIDER', 'Provider'),
    )
    GENDER_CHOICES = (
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other'),
    )

    phone_number = models.CharField(max_length=20, unique=True)
    full_name = models.CharField(max_length=150, blank=True, null=True)
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES, blank=True, null=True)
    emergency_contact = models.CharField(max_length=20, blank=True, null=True)
    cnic = models.CharField(max_length=15, blank=True, null=True)
    cnic_front = models.ImageField(upload_to='cnic/', blank=True, null=True)
    cnic_back = models.ImageField(upload_to='cnic/', blank=True, null=True)
    selfie = models.ImageField(upload_to='selfies/', blank=True, null=True)
    active_mode = models.CharField(max_length=10, choices=MODE_CHOICES, default='CUSTOMER')
    is_verified = models.BooleanField(default=False)
    
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    
    objects = UserManager()

    USERNAME_FIELD = 'phone_number'
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.phone_number

class CustomerProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='customer_profile')
    rating = models.FloatField(default=0.0)

    def __str__(self):
        return f"Customer: {self.user.phone_number}"

class ProviderProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='provider_profile')
    categories = models.JSONField(default=list, blank=True)
    experience_years = models.IntegerField(default=0)
    bio = models.TextField(blank=True, null=True)
    police_verified = models.BooleanField(default=False)
    is_online = models.BooleanField(default=False)
    is_rider_mode = models.BooleanField(default=False)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    rating = models.FloatField(default=0.0)
    video_intro = models.FileField(upload_to='provider_videos/', blank=True, null=True)

    def __str__(self):
        return f"Provider: {self.user.phone_number}"

class NurseProfile(models.Model):
    provider_profile = models.OneToOneField(ProviderProfile, on_delete=models.CASCADE, related_name='nurse_profile')
    nursing_license = models.ImageField(upload_to='licenses/', blank=True, null=True)
    specializations = models.JSONField(default=list, blank=True)
    kit_available = models.BooleanField(default=False)
    health_declaration = models.FileField(upload_to='health_declarations/', blank=True, null=True)

    def __str__(self):
        return f"Nurse: {self.provider_profile.user.phone_number}"

class OTPVerification(models.Model):
    phone_number = models.CharField(max_length=20)
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    is_verified = models.BooleanField(default=False)

    def is_valid(self):
        # OTP is valid for 5 minutes
        return (timezone.now() - self.created_at).total_seconds() < 300
