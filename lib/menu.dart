import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:mangan_jogja/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mangan_jogja/models/menu_entry.dart';
import 'package:mangan_jogja/models/resto_entry.dart';
import 'package:mangan_jogja/main/screens/menu_detail.dart';
import 'package:mangan_jogja/main/screens/list_restoentry.dart';
import 'package:mangan_jogja/main/screens/list_menuentry.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String _searchQuery = '';
  List<MenuEntry> _menuList = [];
  List<RestoEntry> _restoList = [];
  List<MenuEntry> _filteredMenus = [];
  List<RestoEntry> _filteredRestos = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final request = context.read<CookieRequest>();
    try {
      // Fetch menus
      final menuResponse = await request.get('http://127.0.0.1:8000/admin-dashboard/json/');
      List<MenuEntry> menus = [];
      for (var d in menuResponse) {
        if (d != null) {
          menus.add(MenuEntry.fromJson(d));
        }
      }

      // Fetch restaurants
      final restoResponse = await request.get('http://127.0.0.1:8000/admin-dashboard/json2/');
      List<RestoEntry> restos = [];
      for (var d in restoResponse) {
        if (d != null) {
          restos.add(RestoEntry.fromJson(d));
        }
      }

      setState(() {
        _menuList = menus;
        _restoList = restos;
      });
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      
      // Filter menus
      _filteredMenus = _menuList.where((menu) =>
        menu.fields.namaMenu.toLowerCase().contains(query.toLowerCase())
      ).toList();

      // Filter restaurants
      _filteredRestos = _restoList.where((resto) =>
        resto.fields.namaResto.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      drawer: const LeftDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            backgroundColor: const Color(0xFFDAC0A3),
            title: Row(
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
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                onChanged: _handleSearch,
                decoration: InputDecoration(
                  hintText: 'Search menus or restaurants...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              if (_isSearching) ...[
                // Search Results
                const SizedBox(height: 20),
                Text(
                  'Menu Results',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filteredMenus.length,
                    itemBuilder: (context, index) => _buildMenuCard(_filteredMenus[index]),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  'Restaurant Results',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredRestos.length,
                  itemBuilder: (context, index) => _buildRestoCard(_filteredRestos[index]),
                ),
              ] else ...[
                // Regular Content
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Menus',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuEntryPage(),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _menuList.take(5).length,
                    itemBuilder: (context, index) => _buildMenuCircle(_menuList[index]),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  'Recommended Restaurants',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _restoList.take(3).length,
                  itemBuilder: (context, index) => _buildRestoCard(_restoList[index]),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildMenuCircle(MenuEntry menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailPage(menu: menu),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(menu.fields.imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              menu.fields.namaMenu,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(MenuEntry menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailPage(menu: menu),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                menu.fields.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  menu.fields.namaMenu,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestoCard(RestoEntry resto) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resto.fields.namaResto,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF28110A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              resto.fields.lokasiResto,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${resto.fields.rating} ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const Text(' • '),
                Text(
                  'Rp ${resto.fields.rangeHarga}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}