from rest_framework import serializers
from .models import Message, Report
from users.serializers import UserSerializer

class MessageSerializer(serializers.ModelSerializer):
    sender_details = UserSerializer(source='sender', read_only=True)

    class Meta:
        model = Message
        fields = '__all__'
        read_only_fields = ('timestamp', 'sender')

class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = '__all__'
        read_only_fields = ('status', 'created_at', 'reporter')
