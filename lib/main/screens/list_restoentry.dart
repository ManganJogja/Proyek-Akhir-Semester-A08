import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/resto_entry.dart';
import 'package:mangan_jogja/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mangan_jogja/wishlist/models/wishlist_entry.dart'; // Import WishlistEntry
import 'package:mangan_jogja/wishlist/providers/wishlist_provider.dart'; // Import WishlistProvider

class RestoEntryPage extends StatefulWidget {
  const RestoEntryPage({super.key});

  @override
  State<RestoEntryPage> createState() => _RestoEntryPageState();
}

class _RestoEntryPageState extends State<RestoEntryPage> {
  Future<List<RestoEntry>> fetchResto(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/admin-dashboard/json2/');
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
    );
  }
}

class RestoCard extends StatelessWidget {
  final RestoEntry restoEntry;

  const RestoCard({super.key, required this.restoEntry});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context); // Ambil instance WishlistProvider

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
                // Informasi Restoran
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

                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol "Click to see reviews" di kiri
                    TextButton(
                      onPressed: () {
                        // Tambahkan logika untuk tombol "Click to see reviews" di sini
                      },
                      child: const Text(
                        'Click to see reviews',
                        style: TextStyle(
                          color: Colors.brown,
                          decoration: TextDecoration.underline, // Garis bawah
                        ),
                      ),
                    ),

                    // Tombol "Make Reservation" di kanan
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika untuk tombol "Make Reservation" di sini
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4E342E), // Warna cokelat gelap
                        foregroundColor: Colors.white, // Warna teks putih
                      ),
                      child: const Text('Make Reservation'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Wishlist IconButton di kanan atas
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
