import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/menu.dart';
import 'package:mangan_jogja/reserve/screens/reservation_form.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/review/screens/review_page.dart'; // Pastikan Anda mengimpor halaman review

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFDAC0A3),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/Logo.png', 
                  height: 40.0, 
                ),
                const SizedBox(width: 8.0), 
                Text(
                  "ManganJogja.",
                  style: GoogleFonts.aDLaMDisplay(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: const Color(0xFF3E190E),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Home
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          
          // Menu Tambah Reserve
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Tambah Reserve'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReservationPageForm(),
                ),
              );
            },
          ),
          
          // Menu Lihat Reserve
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Lihat Reserve'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservedRestaurantsPage(),
                ),
              );
            },
          ),
          
          // Menu Review (Button baru untuk menuju halaman Review)
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('My Reviews'),
            onTap: () {
              // Menavigasi ke halaman Review
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewPage(restaurantName: 'Gudeg Yudjum',),  // Pastikan ReviewPage adalah widget yang ada
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
