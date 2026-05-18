import json

from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncWebsocketConsumer
from django.contrib.auth.models import AnonymousUser

from .models import Message
from .serializers import MessageSerializer
from .services import get_job_group_name
from jobs.models import Job


class JobChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        user = self.scope.get('user')
        self.job_id = self.scope['url_route']['kwargs']['job_id']
        self.group_name = get_job_group_name(self.job_id)

        if isinstance(user, AnonymousUser) or not getattr(user, 'is_authenticated', False):
            await self.close(code=4401)
            return

        is_allowed = await self._is_authorized(user.id, self.job_id)
        if not is_allowed:
            await self.close(code=4403)
            return

        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data=None, bytes_data=None):
        if not text_data:
            return

        payload = json.loads(text_data)
        if payload.get('type') != 'text_message':
            return

        content = (payload.get('content') or '').strip()
        if not content:
            return

        message_data = await self._create_text_message(self.scope['user'].id, self.job_id, content)
        await self.channel_layer.group_send(
            self.group_name,
            {
                'type': 'chat.message',
                'message': message_data,
            },
        )

    async def chat_message(self, event):
        await self.send(text_data=json.dumps({
            'type': 'message',
            'message': event['message'],
        }))

    @database_sync_to_async
    def _is_authorized(self, user_id, job_id):
        try:
            job = Job.objects.select_related('customer__user', 'provider__user').get(pk=job_id)
        except Job.DoesNotExist:
            return False

        return job.customer.user_id == user_id or (job.provider and job.provider.user_id == user_id)

    @database_sync_to_async
    def _create_text_message(self, user_id, job_id, content):
        message = Message.objects.create(
            job_id=job_id,
            sender_id=user_id,
            message_type='TEXT',
            content=content,
        )
        return MessageSerializer(message).data
