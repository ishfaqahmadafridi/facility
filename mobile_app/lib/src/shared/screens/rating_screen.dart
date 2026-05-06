import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_text_field.dart';
import '../../common_widgets/star_rating.dart';

class RatingScreen extends StatefulWidget {
  final String referenceId;
  final String revieweeId;
  final String referenceType;

  const RatingScreen({
    super.key,
    required this.referenceId,
    required this.revieweeId,
    required this.referenceType,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _score = 5;
  final _feedbackController = TextEditingController();

  void _submitRating() async {
    // Call RatingApi.submitRating in a real app
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Experience')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('How was the service?', style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            StarRating(
              initialRating: _score,
              onRatingChanged: (val) => setState(() => _score = val),
            ),
            const SizedBox(height: 32),
            AppTextField(
              label: 'Leave a comment (Optional)',
              controller: _feedbackController,
              maxLines: 4,
              hint: 'Write about your experience...',
            ),
            const Spacer(),
            AppButton(
              label: 'Submit Feedback',
              onPressed: _submitRating,
            ),
          ],
        ),
      ),
    );
  }
}
