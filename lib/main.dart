import 'package:flutter/material.dart';
import 'package:mangan_jogja/menu.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/reserve/screens/start_page.dart';
import 'package:mangan_jogja/wishlist/screens/wishlist_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'wishlist/providers/wishlist_provider.dart'; // Import WishlistProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()), // Tambahkan WishlistProvider
        Provider(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.brown,
          ).copyWith(secondary: Colors.brown[400]),
        ),
        home: StartPage(),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  // Daftar halaman yang ditampilkan berdasarkan indeks
  final List<Widget> _pages = [
    const MyHomePage(),
    const WishlistPage(),
    const ReservedRestaurantsPage(),
    const ReservedRestaurantsPage(),
    const LoginApp(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == 4) {
      // Logout logic
      bool success = await _logoutUser();
      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } else {
      // Navigasi biasa
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<bool> _logoutUser() async {
    // Simulasikan logout (ubah sesuai kebutuhan)
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8b6c5c),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
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

