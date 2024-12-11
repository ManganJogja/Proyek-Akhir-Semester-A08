import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/review_entry.dart';
import 'package:mangan_jogja/review/screens/review_card.dart';
import 'package:mangan_jogja/review/screens/review_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mangan_jogja/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class ReviewPage extends StatefulWidget {
  final String restaurantName;
  final String restaurantId;

  const ReviewPage({
    Key? key,
    required this.restaurantName,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<ReviewEntry> reviews = [];
  String selectedFilter = 'All';

  // Pastikan login berhasil
  Future<void> ensureLoggedIn(CookieRequest request) async {
    if (!request.loggedIn) {
      final response = await request.login(
        'http://127.0.0.1:8000/accounts/login/',
        {'username': 'test_user', 'password': 'test_password'},
      );
      if (response['status'] != 'success') {
        print('Failed to login: ${response['message']}');
      } else {
        print('Login successful: ${response['message']}');
      }
    }
  }

  // Fetch reviews from API
Future<void> fetchReviews(CookieRequest request) async {
  try {
    final response = await request.get(
      'http://127.0.0.1:8000/reviews/reviews/json/${widget.restaurantId}/',
    );

    if (response != null && response['reviews'] != null) {
      setState(() {
        reviews = (response['reviews'] as List)
            .map((data) => ReviewEntry.fromJson(data))
            .toList();
        print('Fetched reviews: $reviews'); // Debugging
      });
    } else {
      print('Failed to fetch reviews: ${response.toString()}'); // Debugging
    }
  } catch (e) {
    print('Error fetching reviews: $e'); // Debugging
  }
}

  Future<void> deleteReviewFromBackend(CookieRequest request, int reviewId) async {
  try {
    final response = await request.post(
      'http://127.0.0.1:8000/reviews/delete_review_flutter/$reviewId/',
      {},
    );

    if (response != null && response['status'] == 'success') {
      print('Review deleted successfully');
    } else {
      print('Failed to delete review: ${response['message']}');
    }
  } catch (e) {
    print('Error deleting review: $e');
  }
}

Future<void> addReviewToBackend(CookieRequest request, String restaurantId, int rating, String comment) async {
  try {
    final reviewData = {
      'rating': rating.toString(),
      'comment': comment,
    };
    print('Submitting review data to backend: $reviewData'); // Debugging

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/reviews/add_review_flutter/$restaurantId/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reviewData),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print('Review added successfully');
    } else {
      print('Failed to add review: ${response.body}');
    }
  } catch (e) {
    print('Error adding review: $e');
  }
}


Future<Map<String, dynamic>> fetchCurrentUser(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/current_user/');
    if (response != null) {
      return response; // Kembalikan data pengguna
    } else {
      throw Exception('Failed to fetch current user');
    }
  } catch (e) {
    print('Error fetching current user: $e');
    throw e;
  }
}


  // Delete review by index
  void deleteReview(int index) async {
  final request = Provider.of<CookieRequest>(context, listen: false);
  final reviewId = reviews[index].id;

  await deleteReviewFromBackend(request, reviewId);
  
  setState(() {
    reviews.removeAt(index);
  });
}


  // Edit review by index
  void editReview(int index) {
    final review = reviews[index];
    final TextEditingController reviewController =
        TextEditingController(text: review.comment);
    int rating = review.rating;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Review"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          rating > i ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = i + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reviewController,
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
                      review.comment = reviewController.text;
                      review.rating = rating;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save Changes"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Filter reviews based on selection
  void filterReviews(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'Highest to Lowest') {
        reviews.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (filter == 'Lowest to Highest') {
        reviews.sort((a, b) => a.rating.compareTo(b.rating));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    fetchReviews(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false); // Pastikan ini ada

    return Scaffold(
      backgroundColor: const Color(0xFFDAC0A3),
      appBar: AppBar(
        title: Text(
          '${widget.restaurantName} Reviews',
          style: GoogleFonts.mulish(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      drawer: const LeftDrawer(),
      body: reviews.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reviews (${reviews.length})',
                        style: GoogleFonts.mulish(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedFilter,
                        onChanged: (value) {
                          if (value != null) {
                            filterReviews(value);
                          }
                        },
                        items: ['All', 'Highest to Lowest', 'Lowest to Highest']
                            .map((filter) => DropdownMenuItem(
                                  value: filter,
                                  child: Text(filter),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ReviewCard(
                          username: review.userUsername,
                          rating: review.rating,
                          reviewText: review.comment,
                          date: review.createdAt.toString(),
                          onDelete: () => deleteReview(index),
                          onEdit: () => editReview(index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
ElevatedButton(
  onPressed: () async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewForm(initialReview: {}),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final int rating = result['rating'];
      final String comment = result['reviewText'];

      print('Received review from form: rating=$rating, comment=$comment');

      // Kirim data ke Django
      await addReviewToBackend(request, widget.restaurantId, rating, comment);

      // Refresh daftar review
      await fetchReviews(request);
    } else {
      print('No review submitted');
    }
  },
  child: Text('ADD REVIEW'),
)

                ],
              ),
            ),
    );
  }
}