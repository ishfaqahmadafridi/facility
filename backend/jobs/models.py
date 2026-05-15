from django.db import models
from users.models import CustomerProfile, ProviderProfile

class JobCategory(models.Model):
    name = models.CharField(max_length=100)
    icon_url = models.URLField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name

class Job(models.Model):
    STATUS_CHOICES = (
        ('PENDING', 'Pending'),
        ('ACCEPTED', 'Accepted'),
        ('IN_PROGRESS', 'In Progress'),
        ('COMPLETED', 'Completed'),
        ('DISPUTED', 'Disputed'),
        ('CANCELLED', 'Cancelled'),
    )

    customer = models.ForeignKey(CustomerProfile, on_delete=models.CASCADE, related_name='posted_jobs')
    provider = models.ForeignKey(ProviderProfile, on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_jobs')
    category = models.ForeignKey(JobCategory, on_delete=models.SET_NULL, null=True)
    
    title = models.CharField(max_length=200)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    
    # Location (simplified)
    latitude = models.FloatField()
    longitude = models.FloatField()
    address = models.CharField(max_length=255)
    
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # Escrow
    escrow_held = models.BooleanField(default=False)
    escrow_released = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.title} - {self.status}"

class Ride(models.Model):
    STATUS_CHOICES = (
        ('PENDING', 'Pending'),
        ('ACCEPTED', 'Accepted'),
        ('IN_PROGRESS', 'In Progress'),
        ('COMPLETED', 'Completed'),
        ('CANCELLED', 'Cancelled'),
    )

    customer = models.ForeignKey(CustomerProfile, on_delete=models.CASCADE, related_name='requested_rides')
    rider = models.ForeignKey(ProviderProfile, on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_rides')
    
    pickup_latitude = models.FloatField()
    pickup_longitude = models.FloatField()
    pickup_address = models.CharField(max_length=255)
    
    dropoff_latitude = models.FloatField()
    dropoff_longitude = models.FloatField()
    dropoff_address = models.CharField(max_length=255)
    
    suggested_fare = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Ride from {self.pickup_address[:10]} to {self.dropoff_address[:10]}"

class PortfolioItem(models.Model):
    provider = models.ForeignKey(ProviderProfile, on_delete=models.CASCADE, related_name='portfolio_items')
    image = models.ImageField(upload_to='portfolio/')
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Portfolio item for {self.provider.user.phone_number}"

class Review(models.Model):
    job = models.OneToOneField(Job, on_delete=models.CASCADE, related_name='review')
    reviewer = models.ForeignKey(CustomerProfile, on_delete=models.CASCADE, related_name='given_reviews')
    provider = models.ForeignKey(ProviderProfile, on_delete=models.CASCADE, related_name='received_reviews')
    rating = models.FloatField()
    comment = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Review for Job {self.job.id} by {self.reviewer.user.phone_number}"
