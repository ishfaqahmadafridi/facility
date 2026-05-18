import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'booking_checkout_view.dart';

// components
import 'provider_profile_components/profile_card.dart';
import 'provider_profile_components/rating_row.dart';
import 'provider_profile_components/about_section.dart';
import 'provider_profile_components/section_title.dart';
import 'provider_profile_components/categories_section.dart';
import 'provider_profile_components/reviews_section.dart';
import 'provider_profile_components/placeholder_reviews.dart';
import 'provider_profile_components/booking_button.dart';
import 'provider_profile_components/spacing.dart';
import 'provider_profile_components/small_divider.dart';

class ProviderProfileView extends StatefulWidget {
  final Map<String, dynamic> initialProviderData;

  const ProviderProfileView({super.key, required this.initialProviderData});

  @override
  State<ProviderProfileView> createState() => _ProviderProfileViewState();
}

class _ProviderProfileViewState extends State<ProviderProfileView> {
  bool _isLoading = true;
  Map<String, dynamic> _providerDetails = {};

  @override
  void initState() {
    super.initState();
    _providerDetails = widget.initialProviderData;
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final providerId = widget.initialProviderData['user']?['id']?.toString();
    if (providerId != null) {
      final details = await ApiService.instance.getProviderDetails(providerId);
      if (details != null && mounted) {
        setState(() {
          _providerDetails = details;
        });
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _providerDetails['user'] ?? {};
    final fullName = user['full_name'] ?? 'Provider';
    final bio = _providerDetails['bio'] ?? 'No bio provided.';
    final rating = _providerDetails['rating'] ?? 0.0;
    final experience = _providerDetails['experience'] ?? '0 years';
    
    return Scaffold(
      appBar: AppBar(title: Text(fullName), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: ProfileCard(name: fullName)),
                  const SizedBox(height: 16),
                  Center(child: RatingRow(rating: rating.toDouble(), experience: experience)),
                  const SizedBox(height: 24),
                  const SectionTitle('About'),
                  AboutSection(about: bio),
                  const SizedBox(height: 24),
                  const SectionTitle('Categories'),
                  const Spacing(height: 8),
                  CategoriesSection(categories: (_providerDetails['categories'] as List<dynamic>? ?? [])),
                  const SizedBox(height: 24),
                  const SectionTitle('Reviews'),
                  const Spacing(height: 8),
                  ReviewsSection(reviews: PlaceholderReviews.sample()),
                ],
              ),
            ),
      bottomNavigationBar: BookingButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => BookingCheckoutView(providerDetails: _providerDetails)));
        },
      ),
    );
  }
}
