import 'package:flutter/material.dart';
import 'package:mangan_jogja/models/menu_entry.dart';
import 'package:mangan_jogja/widgets/drawer.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_jogja/main/screens/menu_detail.dart'; // Import halaman detail

class MenuEntryPage extends StatefulWidget {
  const MenuEntryPage({super.key});

  @override
  State<MenuEntryPage> createState() => _MenuEntryPageState();
}

class _MenuEntryPageState extends State<MenuEntryPage> {
  Future<List<MenuEntry>> fetchMenu(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/admin-dashboard/json/');
    var data = response;
    
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
    final token = request.cookies['csrftoken'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF28110A), 
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchMenu(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Belum ada data menu pada ManganJogja.',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff59A5D8),
                ),
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final menu = snapshot.data![index];
                return GestureDetector( // Tambahkan GestureDetector
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuDetailPage(menu: menu),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4, 
                          child: Image.network(
                            menu.fields.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                        Expanded(
                          flex: 1, 
                          child: Center(
                            child: Text(
                              menu.fields.namaMenu,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF28110A), 
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}