import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart'; // Import WishlistProvider
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'edit_wishlist.dart';
import 'package:mangan_jogja/menu.dart'; // Import MyHomePage
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:mangan_jogja/reserve/screens/logout.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/main/screens/list_menuentry.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';


class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  String _sortMethod = 'name_asc';
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const MenuEntryPage(), // Home
    const WishlistPage(), // Wishlist
    const ReservedRestaurantsPage(), // Reservation
    const ReservedRestaurantsPage(), // Orders
    const LoginApp(), // Logout
  ];

  void _sortWishlist() {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    setState(() {
      switch (_sortMethod) {
        case 'name_asc':
          provider.wishlist.sort((a, b) => a.fields.namaResto.compareTo(b.fields.namaResto));
          break;
        case 'name_desc':
          provider.wishlist.sort((a, b) => b.fields.namaResto.compareTo(a.fields.namaResto));
          break;
        case 'rating_desc':
          provider.wishlist.sort((a, b) => b.fields.rating.compareTo(a.fields.rating));
          break;
        case 'rating_asc':
          provider.wishlist.sort((a, b) => a.fields.rating.compareTo(b.fields.rating));
          break;
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      // Logout logic
      _performLogout();
    } else {
      // Directly navigate to the selected page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final request = context.read<CookieRequest>();
      context.read<WishlistProvider>().fetchWishlist(request);
    });
  }

  Future<void> _performLogout() async {
    bool success = await LogoutHandler.logoutUser(context);
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginApp()),
      );
    }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()), // Arahkan ke MyHomePage
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF3E190E), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                
                child: DropdownButton<String>(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  value: _sortMethod,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sortMethod = newValue;
                        _sortWishlist();
                      });
                    }
                  },
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: 'name_asc', child: Text('Sort by Name (A-Z)')),
                    DropdownMenuItem(value: 'name_desc', child: Text('Sort by Name (Z-A)')),
                    DropdownMenuItem(value: 'rating_desc', child: Text('Sort by Rating (High to Low)')),
                    DropdownMenuItem(value: 'rating_asc', child: Text('Sort by Rating (Low to High)')),
                  ],
                  isExpanded: true,
                  style: const TextStyle(color: Color(0xFF3E190E)),
                  dropdownColor: Colors.white,
                  iconEnabledColor: const Color(0xFF3E190E),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<WishlistProvider>(
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
                                            currentDatePlan: null,
                                            currentNote: '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Add Plan',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
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

                                      if (shouldDelete == true) {
                                        final request = context.read<CookieRequest>();
                                        
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onItemTapped(index);
        },
        currentIndex: _currentIndex,
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