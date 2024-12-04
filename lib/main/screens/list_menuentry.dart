import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/menu_entry.dart';
import 'package:mangan_jogja/widgets/drawer.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class MenuEntryPage extends StatefulWidget {
  const MenuEntryPage({super.key});

  @override
  State<MenuEntryPage> createState() => _MenuEntryPageState();
}

class _MenuEntryPageState extends State<MenuEntryPage> {
  Future<List<MenuEntry>> fetchMenu(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/admin-dashboard/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object MenuEntry
    List<MenuEntry> listMenu = [];
    for (var d in data) {
      if (d != null) {
        listMenu.add(MenuEntry.fromJson(d));
      }
    }
    return listMenu;
  }
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Menus'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchMenu(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada data menu pada ManganJogja.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].fields.namaMenu}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Gambar menu dari URL
                      Text("${snapshot.data![index].fields.imageUrl}"),
                      Image.network(
                        snapshot.data![index].fields.imageUrl,
                        height: 200, // Atur tinggi gambar
                        width: 200,
                        fit: BoxFit.cover, // Agar gambar menyesuaikan ukuran container
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image), // Tampilkan ikon jika gagal
                      ),
                      const SizedBox(height: 10),
                       // Deskripsi menu
                      Text(
                        "${snapshot.data![index].fields.deskripsi}",
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}