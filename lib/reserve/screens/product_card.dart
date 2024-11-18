import 'package:flutter/material.dart';
import 'package:mangan_jogja/reserve/screens/reservation_form.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';

class ItemHomepage {
     final String name;
     final IconData icon;

     ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {

  final ItemHomepage item; 
  final Color color; 
  const ItemCard(this.item, this.color, {super.key}); 

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
            );
            if (item.name == "Tambah Produk") {
              Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const ReservationPageForm()),
              );
            }
            else if (item.name == "Lihat Daftar Produk") {
              Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ReservedRestaurantsPage()),
              );
            }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}