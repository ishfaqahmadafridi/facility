import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class StarRating extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;

  const StarRating({
    super.key,
    this.initialRating = 5,
    required this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: AppColors.warning,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
        );
      }),
    );
  }
}
