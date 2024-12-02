import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewForm extends StatefulWidget {
  final Map<String, dynamic> initialReview; // Accept the initial review data

  const ReviewForm({super.key, required this.initialReview});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  int _rating = 1; // Rating bintang (1-5)

  @override
  void initState() {
    super.initState();
    // If there's an initial review, set the text controllers
    if (widget.initialReview.isNotEmpty) {
      _usernameController.text = widget.initialReview['username'] ?? '';
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
          crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left except for 'REVIEWS'
          children: [
            // Add "REVIEWS" title
            Center(
              child: Text(
                'REVIEWS', // Title Text for Reviews section
                style: GoogleFonts.abhayaLibre(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E190E), // Adjust color
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Ratings Section (with interactive stars)
            Text(
              'Ratings :', // Title Text for Ratings section
              style: GoogleFonts.abhayaLibre(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E190E), // Adjust color
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
                      _rating = index + 1; // Update rating on click
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            
            // Review Text Field
            Text(
              'Reviews :', // Title Text for Reviews section
              style: GoogleFonts.abhayaLibre(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E190E), // Adjust color
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
            
            // Username Text Field
            Text(
              'Username :', // Title Text for Username section
              style: GoogleFonts.abhayaLibre(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E190E), // Adjust color
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                filled: true,
                fillColor: const Color(0xFFF8F0E5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Add Review Button
            ElevatedButton(
              onPressed: () {
                if (_reviewController.text.isNotEmpty &&
                    _usernameController.text.isNotEmpty) {
                  // Membuat map review
                  final reviewData = {
                    'username': _usernameController.text,
                    'rating': _rating,
                    'reviewText': _reviewController.text,
                    'date': 'Posted on ${DateTime.now().toLocal()}',
                  };
                  Navigator.pop(context, reviewData); // Mengirim data kembali ke ReviewPage
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4D41),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'ADD REVIEW', // Title Text for Reviews section
                style: GoogleFonts.abhayaLibre(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF8F0E5), // Adjust color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
