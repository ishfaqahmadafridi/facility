from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.db import models
from django.utils import timezone

class UserManager(BaseUserManager):
    """
    Custom user model manager where phone_number is the unique identifier
    for authentication instead of usernames.
    """
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
    """
    Core User Model representing all accounts on the platform.
    Handles dual-mode capabilities (Customer vs Provider) and stores
    crucial safety and verification fields.
    """
    MODE_CHOICES = (
        ('CUSTOMER', 'Customer'),
        ('PROVIDER', 'Provider'),
    )
    GENDER_CHOICES = (
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other'),
    )

    # --- Core Authentication ---
    phone_number = models.CharField(max_length=20, unique=True, help_text="Primary login identifier")
    
    # --- Profile & Safety Enhancements (idea.odt Compliance) ---
    full_name = models.CharField(max_length=150, blank=True, null=True, help_text="User's full legal name")
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES, blank=True, null=True, help_text="Crucial for Women Safety Filters")
    emergency_contact = models.CharField(max_length=20, blank=True, null=True, help_text="Used for the SOS / Family Tracking feature")
    
    # --- Identification & Verification ---
    cnic = models.CharField(max_length=15, blank=True, null=True, help_text="National Identity Number")
    cnic_front = models.ImageField(upload_to='cnic/', blank=True, null=True)
    cnic_back = models.ImageField(upload_to='cnic/', blank=True, null=True)
    selfie = models.ImageField(upload_to='selfies/', blank=True, null=True)
    is_verified = models.BooleanField(default=False, help_text="Designates whether user has passed KYC")
    
    # --- App State ---
    active_mode = models.CharField(max_length=10, choices=MODE_CHOICES, default='CUSTOMER', help_text="Currently active dashboard mode")
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    
    objects = UserManager()

    USERNAME_FIELD = 'phone_number'
    REQUIRED_FIELDS = []

    def __str__(self):
        return f"{self.full_name or self.phone_number} ({self.active_mode})"


class CustomerProfile(models.Model):
    """
    Profile extension for Customer-specific data (ratings, history).
    Every User gets a CustomerProfile by default.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='customer_profile')
    rating = models.FloatField(default=0.0, help_text="Average rating given by providers")

    def __str__(self):
        return f"Customer: {self.user.phone_number}"


class ProviderProfile(models.Model):
    """
    Profile extension for Provider-specific data.
    Created when a user registers to offer services.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='provider_profile')
    
    # --- Professional Details ---
    categories = models.JSONField(default=list, blank=True, help_text="List of service categories (e.g. Plumber, Electrician)")
    experience_years = models.IntegerField(default=0)
    bio = models.TextField(blank=True, null=True)
    video_intro = models.FileField(upload_to='provider_videos/', blank=True, null=True, help_text="Short introductory video for trust building")
    rating = models.FloatField(default=0.0, help_text="Average rating given by customers")
    
    # --- Provider State ---
    police_verified = models.BooleanField(default=False)
    is_online = models.BooleanField(default=False, help_text="Is the provider currently accepting jobs?")
    is_rider_mode = models.BooleanField(default=False, help_text="Is the provider accepting KamKaro Ride requests?")
    
    # --- Location Data ---
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)

    def __str__(self):
        return f"Provider: {self.user.phone_number}"


class NurseProfile(models.Model):
    """
    Specialized extension of ProviderProfile specifically for Healthcare/Nursing workers.
    Contains strict medical and regulatory fields.
    """
    provider_profile = models.OneToOneField(ProviderProfile, on_delete=models.CASCADE, related_name='nurse_profile')
    
    nursing_license = models.ImageField(upload_to='licenses/', blank=True, null=True, help_text="Proof of medical certification")
    specializations = models.JSONField(default=list, blank=True, help_text="e.g. Elderly Care, IV Drip, Midwife")
    kit_available = models.BooleanField(default=False, help_text="Does the nurse carry a medical kit?")
    
    # idea.odt Compliance Field
    health_declaration = models.FileField(upload_to='health_declarations/', blank=True, null=True, help_text="Mandatory health declaration document")

    def __str__(self):
        return f"Nurse: {self.provider_profile.user.phone_number}"


class OTPVerification(models.Model):
    """
    Temporary table to store and validate login/signup OTPs.
    """
    phone_number = models.CharField(max_length=20)
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    is_verified = models.BooleanField(default=False)

    def is_valid(self):
        # OTP is valid for 5 minutes (300 seconds)
        return (timezone.now() - self.created_at).total_seconds() < 300
