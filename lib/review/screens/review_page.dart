import 'package:flutter/material.dart';
import 'package:mangan_jogja/review/screens/review_card.dart';
import 'package:mangan_jogja/review/screens/review_form.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mangan_jogja/widgets/drawer.dart'; // Pastikan LeftDrawer diimpor
import 'package:google_fonts/google_fonts.dart';

// Fungsi untuk mengambil data review
Future<List> fetchReviews(String restaurantId) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/reviews/reviews/json/$restaurantId/'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Mengonversi data JSON menjadi list
  } else {
    throw Exception(
        'Failed to load reviews'); // Menangani error jika tidak berhasil
  }
}

class ReviewPage extends StatefulWidget {
  final String restaurantName;

  const ReviewPage({super.key, required this.restaurantName});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Map<String, dynamic>> reviews = []; // List untuk menyimpan review
  List<Map<String, dynamic>> allReviews = []; // Store the full list of reviews
  String selectedFilter = 'All'; // Default filter (All reviews)

  // Fungsi untuk menghapus review
  void deleteReview(int index) {
    setState(() {
      reviews.removeAt(index); // Menghapus review berdasarkan index
    });
  }

  // Function to edit the review
  void editReview(int index) {
    setState(() {
      Map<String, dynamic> review = reviews[index];
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController _reviewController =
              TextEditingController(text: review['reviewText']);
          int _rating = review['rating'];

          return AlertDialog(
            title: const Text("Edit Review"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit stars (rating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        _rating > index ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1; // Update rating on click
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                // Edit review text
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Write your review...',
                    filled: true,
                    fillColor: Color(0xFFF8F0E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Update review with new rating and text
                    reviews[index]['reviewText'] = _reviewController.text;
                    reviews[index]['rating'] = _rating;
                  });
                  Navigator.pop(context); // Close dialog
                },
                child: Text(
                  "Edit Review",
                  style: GoogleFonts.mulish(
                    // Corrected the placement of the style
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E190E),
                  ),
                ),
              )
            ],
          );
        },
      );
    });
  }

  // Function to filter reviews by rating
  void filterReviews(String filter) {
    setState(() {
      selectedFilter = filter;

      if (filter == 'Highest to Lowest') {
        reviews.sort((a, b) => b['rating'].compareTo(a['rating']));
      } else if (filter == 'Lowest to Highest') {
        reviews.sort((a, b) => a['rating'].compareTo(b['rating']));
      } else if (filter == '5 ⭐⭐⭐⭐⭐') {
        reviews = reviews.where((review) => review['rating'] == 5).toList();
      } else if (filter == '4 ⭐⭐⭐⭐') {
        reviews = reviews.where((review) => review['rating'] == 4).toList();
      } else if (filter == '3 ⭐⭐⭐') {
        reviews = reviews.where((review) => review['rating'] == 3).toList();
      } else if (filter == '2 ⭐⭐') {
        reviews = reviews.where((review) => review['rating'] == 2).toList();
      } else if (filter == '1 ⭐') {
        reviews = reviews.where((review) => review['rating'] == 1).toList();
      } else {
        // Restore the full list of reviews when "All" is selected
        reviews = List.from(allReviews);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReviews("1").then((data) {
      setState(() {
        reviews = List.from(data); // Populate reviews initially
        allReviews = List.from(
            data); // Store the original list of reviews for "All" filter
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFDAC0A3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            backgroundColor: const Color(0xF6F6F6F6),
            title: Text(
              widget.restaurantName,
              style: const TextStyle(
                backgroundColor: Color(0xFFE7DBC6),
                fontFamily: 'Mulish',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: const Color(0xFF3E190E)),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer(); // Open Drawer
                },
              ),
            ],
          ),
        ),
      ),
      drawer: const LeftDrawer(), // Implement the drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the count of all reviews
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'All Reviews (${reviews.length})', // This will show the review count
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0x3E190E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Filter Dropdown or Button Group
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter by:',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0x3E190E),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (value) {
                    if (value != null) {
                      filterReviews(value);
                    }
                  },
                  items: <String>[
                    'All',
                    'Highest to Lowest',
                    'Lowest to Highest',
                    '5 ⭐⭐⭐⭐⭐',
                    '4 ⭐⭐⭐⭐',
                    '3 ⭐⭐⭐',
                    '2 ⭐⭐',
                    '1 ⭐',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display reviews
            if (reviews.isEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Center content vertically when empty
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/no_reservations.png',
                    height: 200.0,
                  ),
                  const SizedBox(
                      height:
                          30), // Increased the gap between the image and text
                  const Text(
                    'No reviews yet',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0x3E190E),
                    ),
                  ),
                ],
              )
            else
              // Display review cards
              Expanded(
                child: ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ReviewCard(
                      username: review['username'],
                      rating: review['rating'],
                      reviewText: review[
                          'reviewText'], // Ensure this field is correctly passed
                      date: review['date'],
                      onDelete: () => deleteReview(index),
                      onEdit: () => editReview(
                          index), // Pass the edit function to each ReviewCard
                    );
                  },
                ),
              ),
            // Add Review Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReviewForm(initialReview: {}),
                  ),
                );

                if (result != null) {
                  setState(() {
                    reviews.add(result); // Add the new review to the list
                    allReviews.add(
                        result); // Ensure the original list is updated as well
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4D41),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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