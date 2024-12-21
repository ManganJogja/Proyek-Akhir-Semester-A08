import 'package:flutter/material.dart';
import 'package:mangan_jogja/menu.dart';
import 'package:mangan_jogja/ordertakeaway/ordertakeaway_page.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/logout.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/wishlist/screens/wishlist_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  // List halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const MyHomePage(),
    const WishlistPage(),
    const ReservedRestaurantsPage(),
    const OrderTakeawayPage(),
    const LoginApp(), // Logout akan mengarahkan ke halaman login
  ];

Future<void> _onItemTapped(int index) async {
  switch (index) {
    case 0:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (route) => false,
      );
      break;
    case 1:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WishlistPage()), // Wishlist
      (route) => false,
      );
      break;
    case 2:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ReservedRestaurantsPage()),
        (route) => false, // Reservation
      );
      break;
    case 3:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OrderTakeawayPage()), // Orders
      (route) => false,
      );
      break;
    case 4:
      bool success = await LogoutHandler.logoutUser(context);
      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginApp()),
        (route) => false,
        );
      }
      break;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Tampilkan halaman sesuai indeks saat ini
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  const BottomNav({
    Key? key,
    required this.onItemTapped,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8b6c5c),
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(
          color: Color(0xFF8b6c5c),
          size: 30,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
          size: 24,
        ),
        onTap: onItemTapped,
        currentIndex: currentIndex,
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
      ),
    );
  }
}
