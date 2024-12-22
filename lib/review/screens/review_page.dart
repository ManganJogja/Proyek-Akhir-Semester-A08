import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/review_entry.dart';
import 'package:mangan_jogja/review/screens/review_card.dart';
import 'package:mangan_jogja/review/screens/review_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';

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
  List<ReviewEntry> allReviews = [];
  List<ReviewEntry> reviews = [];
  String selectedFilter = 'All';
  bool _isLoading = true;
  bool _isButtonHovered = false;

  Future<void> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/reviews/reviews/json/${widget.restaurantId}/',
      );

      if (response != null && response['reviews'] != null) {
        setState(() {
          allReviews = (response['reviews'] as List)
              .map((data) => ReviewEntry.fromJson(data))
              .toList();
          reviews = List.from(allReviews); // Create a new copy
          _isLoading = false;
        });
      } else {
        print('Failed to fetch reviews: ${response.toString()}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteReviewFromBackend(
      CookieRequest request, int reviewId) async {
    try {
      final response = await request.post(
        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/reviews/delete_review_flutter/$reviewId/',
        {},
      );

      if (response != null && response['status'] == 'success') {
        print('Review deleted successfully');
      } else {
        print('Failed to delete review');
      }
    } catch (e) {
      print('Error deleting review: $e');
    }
  }

  Future<bool> addReviewToBackend(CookieRequest request, String restaurantId,
      int rating, String comment) async {
    try {
      final response = await request.post(
        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/reviews/add_review_flutter/$restaurantId/',
        {
          'rating': rating.toString(),
          'comment': comment,
        },
      );

      if (response != null && response['status'] == 'success') {
        print('Review added successfully');
        return true;
      } else {
        print('Failed to add review');
        return false;
      }
    } catch (e) {
      print('Error adding review: $e');
      return false;
    }
  }

  void deleteReview(int index) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final reviewId = reviews[index].id;

    await deleteReviewFromBackend(request, reviewId);

    setState(() {
      allReviews.removeWhere((review) => review.id == reviewId);
      reviews.removeAt(index);
    });
  }

  void editReview(int index) async {
    final review = reviews[index];
    final TextEditingController reviewController =
        TextEditingController(text: review.comment);
    int selectedRating = review.rating;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF8F0E5),
              title: Text(
                "Edit Review",
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7C4D41),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rating:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (idx) {
                      return IconButton(
                        icon: Icon(
                          idx < selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = idx + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reviewController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write your review...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final request =
                        Provider.of<CookieRequest>(context, listen: false);

                    try {
                      final response = await request.post(
                        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/reviews/edit_review_flutter/${review.id}/',
                        {
                          'rating': selectedRating.toString(),
                          'comment': reviewController.text,
                        },
                      );

                      if (response != null && response['status'] == 'success') {
                        Navigator.pop(context);
                        await fetchReviews(request);
                        applyFilter(selectedFilter); // Reapply current filter
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Review updated successfully')),
                          );
                        }
                      }
                    } catch (e) {
                      print('Error updating review: $e');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to update review')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4D41),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Edit Reviews',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'All') {
        reviews = List.from(allReviews);
        return;
      }

      List<ReviewEntry> filteredReviews = List.from(allReviews);

      switch (filter) {
        case 'Highest to Lowest':
          filteredReviews.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case '⭐⭐⭐⭐⭐':
          filteredReviews =
              filteredReviews.where((r) => r.rating == 5).toList();
          break;
        case '⭐⭐⭐⭐':
          filteredReviews =
              filteredReviews.where((r) => r.rating == 4).toList();
          break;
        case '⭐⭐⭐':
          filteredReviews =
              filteredReviews.where((r) => r.rating == 3).toList();
          break;
        case '⭐⭐':
          filteredReviews =
              filteredReviews.where((r) => r.rating == 2).toList();
          break;
        case '⭐':
          filteredReviews =
              filteredReviews.where((r) => r.rating == 1).toList();
          break;
        case 'Lowest to Highest':
          filteredReviews.sort((a, b) => a.rating.compareTo(b.rating));
          break;
      }

      reviews = filteredReviews;
    });
  }

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    fetchReviews(request);
  }

  // Di dalam class _ReviewPageState

Widget buildEmptyState() {
  const brownTextColor = Color(0xFF3E190E);

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          width: 300, // Sesuaikan dengan kebutuhan
          child: Image.asset(
            'assets/images/no_reservations.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          selectedFilter == 'All'
              ? 'No reviews yet'
              : 'No ${selectedFilter.toLowerCase()} reviews found',
          style: GoogleFonts.mulish(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: brownTextColor,
          ),
        ),
        const SizedBox(height: 16),
        const SizedBox(),
      ],
    ),
  );
}

Widget buildAddReviewButton(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: const BoxDecoration(
      color: Color(0xFFDAC0A3),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isButtonHovered = true),
          onExit: (_) => setState(() => _isButtonHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonHovered
                    ? const Color(0xFF8B5E52)  // Warna lebih cerah saat hover
                    : const Color(0xFF7C4D41), // Warna normal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: _isButtonHovered ? 4 : 2,
              ),
              onPressed: () async {
                final request = Provider.of<CookieRequest>(context, listen: false);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewForm(
                      initialReview: {},
                      restaurantName: widget.restaurantName,
                    ),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  final int rating = result['rating'];
                  final String comment = result['reviewText'];

                  bool success = await addReviewToBackend(
                    request,
                    widget.restaurantId,
                    rating,
                    comment,
                  );

                  if (success) {
                    await fetchReviews(request);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Review added successfully')),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add review')),
                      );
                    }
                  }
                }
              },
              child: Text(
                'ADD REVIEW',
                style: GoogleFonts.abhayaLibre(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    const backgroundColor = Color(0xFFDAC0A3);
    const brownTextColor = Color(0xFF3E190E);
    const buttonColor = Color(0xFF7C4D41);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Color(0xFF3E190E)), // Ubah warna icon jadi coklat
    onPressed: () => Navigator.pop(context),
  ),
  title: Row(
    children: [
      const SizedBox(width: 8),
      Text(
        widget.restaurantName,
        style: GoogleFonts.mulish( // Ganti font ke Abhaya Libre
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3E190E), // Ganti warna text jadi coklat
        ),
      ),
    ],
  ),
  backgroundColor: backgroundColor, // Ganti warna background jadi sama dengan body
  elevation: 0,
),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAddReviewButton(context),
          BottomNav(
            onItemTapped: (int index) {},
            currentIndex: 0,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  // Header dengan judul dan filter
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'All Reviews (${allReviews.length})',
                          style: GoogleFonts.abhayaLibre(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: brownTextColor,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.filter_alt,
                            color: brownTextColor,
                            size: 28,
                          ),
                          onSelected: applyFilter,
                          itemBuilder: (BuildContext context) {
                            return [
                              'All',
                              'Highest to Lowest',
                              'Lowest to Highest',
                              '⭐⭐⭐⭐⭐',
                              '⭐⭐⭐⭐',
                              '⭐⭐⭐',
                              '⭐⭐',
                              '⭐',
                            ].map((filterOption) {
                              return PopupMenuItem<String>(
                                value: filterOption,
                                child: Text(
                                  filterOption,
                                  style: GoogleFonts.abhayaLibre(
                                    color: brownTextColor,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Area content review
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: reviews.isEmpty
                          ? buildEmptyState()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 12, 24, 24),
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                String? currentUsername =
                                    request.jsonData['username'];
                                bool canEdit = (request.loggedIn &&
                                    currentUsername == review.userUsername);

                                return ReviewCard(
                                  username: review.userUsername,
                                  rating: review.rating,
                                  reviewText: review.comment,
                                  date: review.createdAt.toString(),
                                  onEdit: () => editReview(index),
                                  onDelete: () => deleteReview(index),
                                  canEdit: canEdit,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}