// lib/services/payment_api.dart
import 'api_client.dart';

class PaymentApi {
  final ApiClient _client = ApiClient();

  /// Trigger a payment for a completed ride or booking
  Future<void> processPayment({
    required String referenceId,
    required double amount,
    required String description,
  }) async {
    await _client.post('/payments/process', data: {
      'reference_id': referenceId,
      'amount': amount,
      'description': description,
    });
  }
}
