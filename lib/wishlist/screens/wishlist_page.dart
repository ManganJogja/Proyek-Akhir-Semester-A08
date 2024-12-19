import 'package:flutter/material.dart';
import 'package:mangan_jogja/wishlist/screens/add_wishlist.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart'; // Import WishlistProvider
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'edit_wishlist.dart';

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
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: const Color(0xFF3E190E), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
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
                          InfoRow(
                            label: 'Notes',
                            value: item.fields.additionalNote,
                          ),
                        const SizedBox(height: 12),
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditWishlistPage(
                                      restaurantId: item.fields.restaurant,
                                      currentDatePlan: item.fields.datePlan,
                                      currentNote: item.fields.additionalNote,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Edit Plan',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Tampilkan dialog konfirmasi
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Wishlist Item'),
                                      content: const Text('Are you sure you want to delete this item from your wishlist?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // Jika user mengkonfirmasi delete
                                if (shouldDelete == true) {
                                  final request = context.read<CookieRequest>();
                                  
                                  // Show loading indicator
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  try {
                                    final success = await Provider.of<WishlistProvider>(context, listen: false)
                                        .deleteWishlist(request, item.fields.restaurant);

                                    // Pop loading dialog
                                    if (mounted) Navigator.pop(context);

                                    if (success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Successfully deleted from wishlist!'),
                                        ),
                                      );
                                    } else if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Failed to delete item'),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    // Pop loading dialog
                                    if (mounted) Navigator.pop(context);
                                    
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: ${e.toString()}'),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
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