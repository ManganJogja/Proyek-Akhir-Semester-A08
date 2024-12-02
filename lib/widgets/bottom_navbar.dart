import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Function(int) onItemTapped; // Callback untuk mengubah halaman
  final int currentIndex; // Indeks halaman aktif

  const BottomNav({
    super.key,
    required this.onItemTapped,
    required this.currentIndex,
  });

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Tetap untuk lebih dari 3 item
      currentIndex: widget.currentIndex, // Indeks aktif
      selectedItemColor: const Color(0xFF8b6c5c), // Warna item aktif
      unselectedItemColor: Colors.grey, // Warna item tidak aktif
      onTap: widget.onItemTapped, // Panggil fungsi saat item ditekan
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_bar),
          label: 'Reservation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
    );
  }
}
