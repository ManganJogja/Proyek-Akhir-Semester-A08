import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';

class ReviewForm extends StatefulWidget {
  final Map<String, dynamic> initialReview;
  final bool isEditing;
  final String restaurantName;

  const ReviewForm({
    Key? key,
    required this.initialReview,
    this.isEditing = false,
    required this.restaurantName,
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
    if (widget.initialReview.isNotEmpty) {
      _reviewController.text = widget.initialReview['reviewText'] ?? '';
      _rating = widget.initialReview['rating'] ?? 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFDAC0A3);
    const brownTextColor = Color(0xFF3E190E);
    const whiteColor = Colors.white;
    const starColor = Colors.amber;
    const textFieldColor = Color(0xFFF8F0E5);
    const buttonColor = Color(0xFF7C4D41);

    return Scaffold(
      bottomNavigationBar: BottomNav(
        onItemTapped: (int index) {},
        currentIndex: 0,
      ),
      backgroundColor: backgroundColor,
      body:  
      SafeArea(
        child: Column(
          children: [
            // Bar atas dengan nama restoran
            Container(
              color: backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: brownTextColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.restaurantName,
                    style: GoogleFonts.mulish(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: brownTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // Bar putih dengan tulisan REVIEWS
            Container(
              width: double.infinity,
              color: whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'REVIEWS',
                  style: GoogleFonts.abhayaLibre(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E190E),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ratings :',
                        style: GoogleFonts.abhayaLibre(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: brownTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              _rating > index ? Icons.star : Icons.star_border,
                              color: starColor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1; 
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Reviews :',
                        style: GoogleFonts.abhayaLibre(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: brownTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: textFieldColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _reviewController,
                          maxLines: 4,
                          style: GoogleFonts.abhayaLibre(
                            fontSize: 16,
                            color: brownTextColor,
                          ),
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: GoogleFonts.abhayaLibre(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_reviewController.text.isNotEmpty && _rating > 0) {
                              final reviewData = {
                                'rating': _rating,
                                'reviewText': _reviewController.text,
                                'date': DateTime.now().toLocal().toString(),
                              };

                              Navigator.pop(context, reviewData);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please provide a rating and review text'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            widget.isEditing ? 'Update Review' : 'ADD REVIEW',
                            style: GoogleFonts.abhayaLibre(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
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
