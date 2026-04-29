// lib/services/notification_service.dart
import 'package:flutter/material.dart';
import 'api_client.dart';

class NotificationService {
  final ApiClient _client = ApiClient();
  
  // In a real app, you would include firebase_messaging package
  // import 'package:firebase_messaging/firebase_messaging.dart';

  Future<void> initialize() async {
    /*
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    // Request permissions for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      if (token != null) {
        await _registerDeviceToken(token);
      }
      
      // Listen for token refreshes
      messaging.onTokenRefresh.listen(_registerDeviceToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Show local notification or flushbar
        debugPrint('Got a message whilst in the foreground!');
      });
    }
    */
    debugPrint('[NotificationService] Mock FCM initialization complete.');
  }

  Future<void> _registerDeviceToken(String token) async {
    try {
      await _client.post('/notifications/register-device', data: {
        'fcm_token': token
      });
    } catch (e) {
      debugPrint('Failed to register device token: $e');
    }
  }
}
