import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/menu.dart';
import 'package:mangan_jogja/reserve/screens/reservation_form.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';

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
                      builder: (context) => MyHomePage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Tambah Reserve'), // Ini nanti jadi ada reserve ajaa
              onTap: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const ReservationPageForm()),
              );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Lihat Reserve'),
              onTap: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ReservedRestaurantsPage()),
              );
              },
            ),
        ],
      ),
    );
  }
}
// home, menu, resto, wishlist, order, reserve