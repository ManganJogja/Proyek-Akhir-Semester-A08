import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/resto_entry.dart';
import 'package:mangan_jogja/reserve/screens/reservation_form.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mangan_jogja/wishlist/models/wishlist_entry.dart';
import 'package:mangan_jogja/wishlist/providers/wishlist_provider.dart';
import 'package:mangan_jogja/review/screens/review_page.dart';
// Import pages for navigation
import 'package:mangan_jogja/menu.dart';
import 'package:mangan_jogja/ordertakeaway/ordertakeaway_page.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/logout.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/wishlist/screens/wishlist_page.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';

class RestoEntryPage extends StatefulWidget {
  const RestoEntryPage({super.key});

  @override
  State<RestoEntryPage> createState() => _RestoEntryPageState();
}

class _RestoEntryPageState extends State<RestoEntryPage> {
  int _currentIndex = 0;
  
  Future<List<RestoEntry>> fetchResto(CookieRequest request) async {
    final response = await request.get('http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/admin-dashboard/json2/');
    var data = response;
    List<RestoEntry> listResto = [];
    for (var d in data) {
      if (d != null) {
        listResto.add(RestoEntry.fromJson(d));
      }
    }
    return listResto;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAC0A3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Restaurants',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF28110A), 
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchResto(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada data resto pada ManganJogja.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => RestoCard(
                  restoEntry: snapshot.data![index],
                ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 4) {
            // Logout logic
            _performLogout();
          } else {
            // Navigate to the corresponding page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                switch (index) {
                  case 0:
                    return const MyHomePage();
                  case 1:
                    return const WishlistPage();
                  case 2:
                    return const ReservedRestaurantsPage();
                  case 3:
                    return const OrderTakeawayPage();
                  default:
                    return const LoginApp();
                }
              }),
            );
          }
        },
      ),
    );
  }

  Future<void> _performLogout() async {
    bool success = await LogoutHandler.logoutUser(context);
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginApp()),
      );
    }
  }
}

// Rest of the RestoCard class remains the same
class RestoCard extends StatelessWidget {
  final RestoEntry restoEntry;

  const RestoCard({super.key, required this.restoEntry});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restoEntry.fields.namaResto,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Location: ${restoEntry.fields.lokasiResto}'),
                const SizedBox(height: 8),
                Text('Rating: ${restoEntry.fields.rating} ⭐'),
                const SizedBox(height: 8),
                Text('Range Harga: Rp ${restoEntry.fields.rangeHarga}'),
                const SizedBox(height: 8),
                Text('Cuisine: ${restoEntry.fields.jenisKuliner.toString().split('.').last}'),
                const SizedBox(height: 8),
                Text('Tingkat Keramaian Resto: ${restoEntry.fields.keramaianResto}'),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewPage(
                              restaurantName: restoEntry.fields.namaResto,
                              restaurantId: restoEntry.pk,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Click to see reviews',
                        style: TextStyle(
                          color: Colors.brown,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationPageForm(
                              restoId: restoEntry.pk,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4E342E),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Make Reservation'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () async {
                final request = context.read<CookieRequest>();
                final added = await wishlistProvider.toggleWishlist(
                  request,
                  restoEntry.pk,
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      added ? 'Added to wishlist' : 'Removed from wishlist'
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(
                wishlistProvider.wishlist.any((item) => 
                  item.fields.restaurant == restoEntry.pk)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.brown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}