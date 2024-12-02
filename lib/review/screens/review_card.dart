import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewCard extends StatefulWidget {
  final String username;
  final int rating;
  final String reviewText;
  final String date;
  final Function onDelete; // Callback for deleting the review
  final Function onEdit; // Callback for editing the review

  const ReviewCard({
    super.key,
    required this.username,
    required this.rating,
    required this.reviewText,
    required this.date,
    required this.onDelete, // Passing the onDelete function
    required this.onEdit,   // Passing the onEdit function
  });

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late TextEditingController _usernameController;
  late TextEditingController _reviewController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _reviewController = TextEditingController(text: widget.reviewText);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Membulatkan sudut card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Using Icon for user profile
                const CircleAvatar(
                  radius: 25,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  backgroundColor: Color(0xFF7C4D41), // Color for the background of the avatar
                ),
                const SizedBox(width: 10),
                // Username Text
                isEditing
                    ? TextField(
                        controller: _usernameController,
                        style: GoogleFonts.mulish(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF3E190E), // Adjust the color as needed
                        ),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      )
                    : Text(
                        widget.username,
                        style: GoogleFonts.mulish(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF3E190E), // Adjust the color as needed
                        ),
                      ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF3E190E)),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                        if (isEditing) {
                          widget.onEdit(); // Trigger the edit functionality
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF3E190E)),
                      onPressed: () {
                        widget.onDelete(); // Delete the review
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < widget.rating ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 10),
            isEditing
                ? TextField(
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
                  )
                : Text(
                    widget.reviewText,
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      color: const Color(0xFF3E190E),
                    ),
                  ),
            const SizedBox(height: 10),
            Text(
              widget.date,
              style: const TextStyle(fontSize: 12, color: const Color(0xFF7C4D41),
              fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            if (isEditing) // Show "Save" button when editing
              ElevatedButton(
                onPressed: () {
                  // Save the updated review data
                  widget.onEdit(); // Update the review when "Save" is pressed
                  setState(() {
                    isEditing = false;
                  });
                },
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4D41), // Warna tombol
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
