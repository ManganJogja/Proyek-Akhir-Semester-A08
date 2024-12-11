import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewForm extends StatefulWidget {
  final Map<String, dynamic> initialReview; // Accept the initial review data
  final bool isEditing; // Add a flag to determine if we are editing

  const ReviewForm({
    Key? key,
    required this.initialReview,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 1; // Default rating (1-5)

  @override
  void initState() {
    super.initState();

    // Prepopulate the form if editing
    if (widget.initialReview.isNotEmpty) {
      _reviewController.text = widget.initialReview['reviewText'] ?? '';
      _rating = widget.initialReview['rating'] ?? 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        backgroundColor: const Color(0xFFE7DBC6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'REVIEWS',
                style: GoogleFonts.abhayaLibre(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E190E),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Rating Section
            Text(
              'Ratings:',
              style: GoogleFonts.abhayaLibre(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E190E),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    _rating > index ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1; // Update rating
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),

            // Review Text Field
            Text(
              'Reviews:',
              style: GoogleFonts.abhayaLibre(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E190E),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                filled: true,
                fillColor: const Color(0xFFF8F0E5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_reviewController.text.isNotEmpty && _rating > 0) {
                    final reviewData = {
                      'rating': _rating,
                      'reviewText': _reviewController.text,
                      'date': DateTime.now().toLocal().toString(),
                    };

                    print('Submitting review data: $reviewData'); // Debugging

                    // Pass data back to ReviewPage
                    Navigator.pop(context, reviewData);
                  } else {
                    // Show error if input is invalid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide a rating and review text'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4D41),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  widget.isEditing ? 'Update Review' : 'Submit Review',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
