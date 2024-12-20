import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/menu_entry.dart';
import 'package:mangan_jogja/models/resto_entry.dart';
import 'package:mangan_jogja/reserve/screens/reservation_form.dart';
import 'package:mangan_jogja/review/screens/review_page.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mangan_jogja/wishlist/providers/wishlist_provider.dart';

class MenuDetailPage extends StatefulWidget {
  final MenuEntry menu;

  const MenuDetailPage({super.key, required this.menu});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  List<RestoEntry> restoList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/admin-dashboard/json2/');
      var data = response;
      List<RestoEntry> allRestos = [];
      for (var d in data) {
        if (d != null) {
          allRestos.add(RestoEntry.fromJson(d));
        }
      }
      
      // Filter restoran berdasarkan ID yang ada di menu.fields.restaurants
      List<RestoEntry> filteredRestos = allRestos
          .where((resto) => widget.menu.fields.restaurants.contains(resto.pk))
          .take(5) // Mengambil 5 restoran saja
          .toList();

      setState(() {
        restoList = filteredRestos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menu.fields.namaMenu,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Menu
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.network(
                widget.menu.fields.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 100)),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Menu
                  Text(
                    widget.menu.fields.namaMenu,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF28110A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Deskripsi Menu
                  Text(
                    widget.menu.fields.deskripsi,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Daftar Restoran
                  const Text(
                    'Available at these restaurants:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF28110A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (restoList.isEmpty)
                    const Center(
                      child: Text(
                        'No restaurants available.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restoList.length,
                      itemBuilder: (context, index) {
                        final resto = restoList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      resto.fields.namaResto,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Consumer<WishlistProvider>(
                                      builder: (context, wishlistProvider, child) {
                                        return IconButton(
                                          onPressed: () async {
                                            final request = context.read<CookieRequest>();
                                            final added = await wishlistProvider.toggleWishlist(
                                              request,
                                              resto.pk,
                                            );
                                            
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    added ? 'Added to wishlist' : 'Removed from wishlist'
                                                  ),
                                                  duration: const Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            wishlistProvider.wishlist.any((item) => 
                                              item.fields.restaurant == resto.pk)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: const Color(0xFF4E342E),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Location: ${resto.fields.alamat}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rating: ${resto.fields.rating} ⭐',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Range Harga: Rp ${resto.fields.rangeHarga}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Cuisine: ${resto.fields.jenisKuliner.toString().split('.').last}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tingkat Keramaian Resto: ${resto.fields.keramaianResto}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReviewPage(restaurantId: resto.pk, restaurantName: resto.fields.namaResto)
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Click to See Reviews',
                                        style: TextStyle(
                                          color: Colors.brown,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>  ReservationPageForm(restoId: resto.pk),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4E342E),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Make a Reservation'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}