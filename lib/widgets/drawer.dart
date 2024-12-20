import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/main/screens/list_menuentry.dart';
import 'package:mangan_jogja/main/screens/list_restoentry.dart';
import 'package:mangan_jogja/reserve/screens/reservation_form.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/wishlist/screens/wishlist_page.dart';
import 'package:mangan_jogja/review/screens/review_page.dart'; // Pastikan Anda mengimpor halaman review

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
            color: const Color(0xFFDAC0A3),
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
              
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuEntryPage(),
                    ));
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.table_bar),
              title: const Text('Lihat Reserve'),
              onTap: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ReservedRestaurantsPage()),
              );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Wishlist'),
              onTap: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const WishlistPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Daftar Menu'),
              onTap: () {
                  // Route menu ke halaman mood
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MenuEntryPage()),
                  );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Daftar Resto'),
              onTap: () {
                  // Route menu ke halaman mood
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RestoEntryPage()),
                  );
              },
            ),
        ],
      ),
    );
  }
}
