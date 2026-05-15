import time
from rest_framework import views, status, generics
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Message, Report
from .serializers import MessageSerializer, ReportSerializer
from jobs.models import Job

class SendMessageView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, job_id):
        user = request.user
        try:
            job = Job.objects.get(pk=job_id)
        except Job.DoesNotExist:
            return Response({'error': 'Job not found'}, status=status.HTTP_404_NOT_FOUND)

        # Verify user is either the customer or the provider for this job
        if not (job.customer.user == user or (job.provider and job.provider.user == user)):
            return Response({'error': 'Not authorized for this job chat'}, status=status.HTTP_403_FORBIDDEN)

        data = request.data.copy()
        data['job'] = job.id
        
        serializer = MessageSerializer(data=data)
        if serializer.is_valid():
            serializer.save(sender=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class GetChatHistoryView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = MessageSerializer

    def get_queryset(self):
        job_id = self.kwargs['job_id']
        user = self.request.user
        try:
            job = Job.objects.get(pk=job_id)
            if not (job.customer.user == user or (job.provider and job.provider.user == user)):
                return Message.objects.none()
            return Message.objects.filter(job=job).order_by('timestamp')
        except Job.DoesNotExist:
            return Message.objects.none()

class GenerateAgoraTokenView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, job_id):
        # In a real app, you would use the Agora Python SDK to generate a token
        # using your APP_ID and APP_CERTIFICATE
        # Mock token response for now:
        channel_name = f"job_{job_id}_channel"
        mock_token = f"mock_agora_token_for_{channel_name}_{int(time.time())}"
        
        return Response({
            'channel_name': channel_name,
            'token': mock_token,
            'app_id': 'YOUR_AGORA_APP_ID'
        }, status=status.HTTP_200_OK)

class ReportIssueView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, job_id):
        user = request.user
        try:
            job = Job.objects.get(pk=job_id)
        except Job.DoesNotExist:
            return Response({'error': 'Job not found'}, status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()
        data['job'] = job.id
        
        serializer = ReportSerializer(data=data)
        if serializer.is_valid():
            serializer.save(reporter=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class SOSAlertView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        latitude = request.data.get('latitude')
        longitude = request.data.get('longitude')
        
        if not latitude or not longitude:
            return Response({'error': 'Location is required for SOS'}, status=status.HTTP_400_BAD_REQUEST)

        # In a real app: Trigger an immediate high-priority SMS/Push Notification to
        # emergency contacts and/or law enforcement integration.
        print(f"!!! SOS ALERT !!! User {user.phone_number} at Location ({latitude}, {longitude})")
        
        return Response({'message': 'SOS Alert triggered successfully. Help is on the way.'}, status=status.HTTP_200_OK)
