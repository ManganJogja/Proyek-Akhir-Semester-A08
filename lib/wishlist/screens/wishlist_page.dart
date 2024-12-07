import 'package:flutter/material.dart';
import 'package:mangan_jogja/wishlist/screens/add_wishlist.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart'; // Import WishlistProvider
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final request = context.read<CookieRequest>();
      context.read<WishlistProvider>().fetchWishlist(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: Color(0xFF3E190E)),
        ),
        backgroundColor: const Color(0xFFDAC0A3),
        iconTheme: const IconThemeData(color: Color(0xFF3E190E)),
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, provider, child) {
          if (provider.wishlist.isEmpty) {
            return const Center(
              child: Text('No items in wishlist.'),
            );
          }

          return ListView.builder(
            itemCount: provider.wishlist.length,
            itemBuilder: (context, index) {
              final item = provider.wishlist[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fields.namaResto,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Rating: ${item.fields.rating}'),
                      Text('Price: Rp ${item.fields.rangeHarga}'),
                      Text('Location: ${item.fields.alamat}'),
                      if (item.fields.datePlan != null)
                        Text(
                          'Plan Date: ${DateFormat('MMM. d, y').format(item.fields.datePlan!)}',
                        ),
                      if (item.fields.additionalNote.isNotEmpty)
                        Text('Notes: ${item.fields.additionalNote}'),
                      ButtonBar(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddWishlistPage(
                                    restaurantId: item.fields.restaurant,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Edit Plan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}