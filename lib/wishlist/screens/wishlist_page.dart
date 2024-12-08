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
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fields.namaResto,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E190E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        InfoRow(label: 'Rating', value: '${item.fields.rating}/5'),
                        InfoRow(label: 'Location', value: item.fields.alamat),
                        InfoRow(
                            label: 'Price',
                            value: 'Rp ${item.fields.rangeHarga}'),
                        if (item.fields.datePlan != null)
                          InfoRow(
                            label: 'Plan Date',
                            value: DateFormat('MMM d, y')
                                .format(item.fields.datePlan!),
                          ),
                        if (item.fields.additionalNote.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notes:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E190E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.fields.additionalNote,
                                  style: const TextStyle(
                                    color: Color(0xFF3E190E),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              child: Text(
                                item.fields.datePlan == null
                                    ? 'Add Plan'
                                    : 'Edit Plan',
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed width for label
          SizedBox(
            width: 80, // Adjust this width based on your needs
            child: Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E190E),
              ),
            ),
          ),
          // Expanded for value to take remaining space
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF3E190E),
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}