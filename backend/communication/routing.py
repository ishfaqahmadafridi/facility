from django.urls import re_path

from .consumers import JobChatConsumer


websocket_urlpatterns = [
    re_path(r'^ws/chat/(?P<job_id>\d+)/$', JobChatConsumer.as_asgi()),
]
