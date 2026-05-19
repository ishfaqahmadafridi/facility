from django.db import models
from users.models import CustomerProfile, ProviderProfile

class JobCategory(models.Model):
    """
    Defines the types of services available on the platform 
    (e.g., Plumber, Electrician, Nurse).
    """
    name = models.CharField(max_length=100)
    icon_url = models.URLField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name


class Job(models.Model):
    """
    Represents a service booking between a Customer and a Provider.
    Handles the state machine of a job from PENDING to COMPLETED.
    """
    STATUS_CHOICES = (
        ('PENDING', 'Pending'),
        ('ACCEPTED', 'Accepted'),
        ('IN_PROGRESS', 'In Progress'),
        ('COMPLETED', 'Completed'),
        ('DISPUTED', 'Disputed'),
        ('CANCELLED', 'Cancelled'),
    )

    # --- Core Relations ---
    customer = models.ForeignKey(CustomerProfile, on_delete=models.CASCADE, related_name='posted_jobs')
    provider = models.ForeignKey(ProviderProfile, on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_jobs')
    category = models.ForeignKey(JobCategory, on_delete=models.SET_NULL, null=True)
    
    # --- Job Details ---
    title = models.CharField(max_length=200)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, help_text="Agreed upon price in PKR")
    
    # --- Location Data ---
    latitude = models.FloatField()
    longitude = models.FloatField()
    address = models.CharField(max_length=255)
    
    # --- State & Timestamps ---
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # --- Escrow System ---
    escrow_held = models.BooleanField(default=False, help_text="Are the funds currently secured in escrow?")
    escrow_released = models.BooleanField(default=False, help_text="Have the funds been released to the provider?")

    def __str__(self):
        return f"{self.title} - {self.status}"


class Ride(models.Model):
    """
    Represents a hyper-local ride-hailing request.
    Supports a bidding/counter-offer mechanism between Customer and Rider.
    """
    STATUS_CHOICES = (
        ('PENDING', 'Pending'),
        ('COUNTERED', 'Countered'),
        ('ACCEPTED', 'Accepted'),
        ('IN_PROGRESS', 'In Progress'),
        ('COMPLETED', 'Completed'),
        ('CANCELLED', 'Cancelled'),
    )

    # --- Core Relations ---
    customer = models.ForeignKey(CustomerProfile, on_delete=models.CASCADE, related_name='requested_rides')
    rider = models.ForeignKey(ProviderProfile, on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_rides')
    
    # --- Route Data ---
    pickup_latitude = models.FloatField()
    pickup_longitude = models.FloatField()
    pickup_address = models.CharField(max_length=255)
    
    dropoff_latitude = models.FloatField()
    dropoff_longitude = models.FloatField()
    dropoff_address = models.CharField(max_length=255)
    
    # --- Fare Bidding ---
    suggested_fare = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, help_text="Customer's initial offer")
    agreed_fare = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True, help_text="Final locked-in price")
    is_counter_offer = models.BooleanField(default=False, help_text="Is the current state pending customer approval of a higher fare?")
    
    # --- State & Timestamps ---
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Ride from {self.pickup_address[:10]} to {self.dropoff_address[:10]}"


class PortfolioItem(models.Model):
    """
    idea.odt Compliance: 5.2 Provider Portfolios
    Allows providers to upload images of their past work to build trust.
    """
    provider = models.ForeignKey(ProviderProfile, on_delete=models.CASCADE, related_name='portfolio_items')
    image = models.ImageField(upload_to='portfolio/', help_text="Image of completed work")
    description = models.TextField(blank=True, null=True, help_text="Optional context for the portfolio item")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Portfolio item for {self.provider.user.phone_number}"


class Review(models.Model):
    """
    idea.odt Compliance: 5.2 Provider Reviews
    Captures text feedback and star ratings after a job is completed.
    Links exactly to the Job instance to prevent fake reviews.
    """
    job = models.OneToOneField(Job, on_delete=models.CASCADE, related_name='review')
    reviewer = models.ForeignKey(CustomerProfile, on_delete=models.CASCADE, related_name='given_reviews')
    provider = models.ForeignKey(ProviderProfile, on_delete=models.CASCADE, related_name='received_reviews')
    rating = models.FloatField(help_text="Star rating from 1.0 to 5.0")
    comment = models.TextField(blank=True, null=True, help_text="Written feedback")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Review for Job {self.job.id} by {self.reviewer.user.phone_number}"
