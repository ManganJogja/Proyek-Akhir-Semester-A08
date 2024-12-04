import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/resto_entry.dart';
import 'package:mangan_jogja/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class RestoEntryPage extends StatefulWidget {
  const RestoEntryPage({super.key});

  @override
  State<RestoEntryPage> createState() => _RestoEntryPageState();
}

class _RestoEntryPageState extends State<RestoEntryPage> {
  Future<List<RestoEntry>> fetchResto(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/admin-dashboard/json2/');
    var data = response;
    List<RestoEntry> listResto = [];
    for (var d in data) {
      if (d != null) {
        listResto.add(RestoEntry.fromJson(d));
      }
    }
    return listResto;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Restaurants'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchResto(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada data resto pada ManganJogja.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => RestoCard(
                  restoEntry: snapshot.data![index],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class RestoCard extends StatelessWidget {
  final RestoEntry restoEntry;

  const RestoCard({super.key, required this.restoEntry});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restoEntry.fields.namaResto,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Location: ${restoEntry.fields.lokasiResto}'),
            const SizedBox(height: 8),
            Text('Rating: ${restoEntry.fields.rating} ⭐'),
            const SizedBox(height: 8),
            Text('Range Harga: Rp ${restoEntry.fields.rangeHarga}'),
            const SizedBox(height: 8),
            Text('Cuisine: ${restoEntry.fields.jenisKuliner}'),
            const SizedBox(height: 8),
            Text('Tingkat Keramaian Resto: ${restoEntry.fields.keramaianResto}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add navigation logic for "Make Reservation" here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E342E),
                  ),
                  child: const Text('Make Reservation'),
                ),
                TextButton(
                  onPressed: () {
                    // Add navigation logic for "Click to see reviews" here
                  },
                  child: const Text(
                    'Click to see reviews',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add wishlist toggle logic here
                  },
                  icon: const Icon(Icons.favorite_border),
                  color: Colors.brown,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}