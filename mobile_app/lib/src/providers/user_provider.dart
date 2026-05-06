// lib/src/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../models/user_model.dart';
import '../../models/provider_model.dart';

class UserProvider extends ChangeNotifier {
  final ApiClient _client = ApiClient();

  UserModel? _user;
  UserModel? get user => _user;

  ProviderModel? _providerProfile;
  ProviderModel? get providerProfile => _providerProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _client.get('/users/me');
      _user = UserModel.fromJson(response.data['data']);
      
      // If user is a provider, fetch provider profile
      if (_user!.roles.contains('PROVIDER')) {
        await fetchProviderProfile();
      }
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProviderProfile() async {
    try {
      final response = await _client.get('/providers/me');
      _providerProfile = ProviderModel.fromJson(response.data['data']);
    } catch (e) {
      // Handle error
    }
  }

  Future<bool> registerAsProvider(String cnic, String vertical) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _client.post('/providers/register', data: {
        'cnic': cnic,
        'vertical': vertical,
      });
      // Refresh user to get updated roles
      await fetchProfile();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clear() {
    _user = null;
    _providerProfile = null;
    notifyListeners();
  }
}
