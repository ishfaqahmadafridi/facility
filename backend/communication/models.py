from django.db import models
from users.models import User
from jobs.models import Job

class Message(models.Model):
    MESSAGE_TYPES = (
        ('TEXT', 'Text'),
        ('VOICE', 'Voice Note'),
    )

    job = models.ForeignKey(Job, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent_messages')
    message_type = models.CharField(max_length=10, choices=MESSAGE_TYPES, default='TEXT')
    content = models.TextField(blank=True, null=True)
    voice_note = models.FileField(upload_to='voice_notes/', blank=True, null=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Message by {self.sender.phone_number} on Job {self.job.id}"

class Report(models.Model):
    STATUS_CHOICES = (
        ('OPEN', 'Open'),
        ('REVIEWING', 'Reviewing'),
        ('RESOLVED', 'Resolved'),
    )

    job = models.ForeignKey(Job, on_delete=models.CASCADE, related_name='reports')
    reporter = models.ForeignKey(User, on_delete=models.CASCADE, related_name='submitted_reports')
    description = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='OPEN')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Report {self.id} for Job {self.job.id}"

class SOSAlert(models.Model):
    STATUS_CHOICES = (
        ('OPEN', 'Open'),
        ('ACKNOWLEDGED', 'Acknowledged'),
        ('RESOLVED', 'Resolved'),
    )

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sos_alerts')
    latitude = models.FloatField()
    longitude = models.FloatField()
    emergency_contact = models.CharField(max_length=20, blank=True, null=True)
    shared_with_police = models.BooleanField(default=True)
    notes = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='OPEN')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"SOS {self.id} by {self.user.phone_number}"
