import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart'; // Import WishlistProvider

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context); // Ambil instance WishlistProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: Color(0xFF3E190E)),
        ),
        backgroundColor: const Color(0xFFDAC0A3),
        iconTheme: const IconThemeData(color: Color(0xFF3E190E)),
      ),
      body: wishlistProvider.wishlist.isEmpty
          ? Center(
              child: Text('No items in wishlist.'),
            )
          : ListView.builder(
              itemCount: wishlistProvider.wishlist.length,
              itemBuilder: (context, index) {
                final item = wishlistProvider.wishlist[index];
                return ListTile(
                  title: Text(item.namaResto),
                  subtitle: Text('Rating: ${item.rating}, Price: Rp ${item.rangeHarga}'),
                );
              },
            ),
    );
  }
}