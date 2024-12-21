import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/ordertakeaway/ordertakeaway_page.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/logout.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:mangan_jogja/wishlist/screens/wishlist_page.dart';
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
      final menuResponse = await request.get('http://127.0.0.1:8000/admin-dashboard/json/');
      List<MenuEntry> menus = [];
      for (var d in menuResponse) {
        if (d != null) {
          menus.add(MenuEntry.fromJson(d));
        }
      }

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
      print('Error fetching data: $e');
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      
      _filteredMenus = _menuList.where((menu) =>
        menu.fields.namaMenu.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      _filteredRestos = _restoList.where((resto) =>
        resto.fields.namaResto.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: true,
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
        child: Column(
          children: [
            // Stack untuk menggabungkan AppBar dan Banner gradient
            Stack(
              children: [
                // Banner gradient yang dinaikkan posisinya untuk menghilangkan gap putih
                Container(
                  width: double.infinity,
                  height: 260, // Tinggi ditambah untuk overlap dengan AppBar
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3E2723),
                        Color(0xFF8B4513),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 30), // Padding untuk konten
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ready to Explore Jogja\'s',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Culinary Delight?',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Content Container dengan latar belakang putih dan sudut melengkung
            Transform.translate(
              offset: const Offset(0, -30), // Geser ke atas untuk overlap dengan gradient
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: _handleSearch,
                        decoration: InputDecoration(
                          hintText: 'Search menus or restaurants...',
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),

                    if (_isSearching) ...[
                      // Search Results
                      const SizedBox(height: 20),
                      Text(
                        'Menu Results',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (_filteredMenus.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No menu items found'),
                        )
                      else
                        Container(
                          height: 220,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filteredMenus.length,
                            itemBuilder: (context, index) => Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 16),
                              child: _buildMenuCard(_filteredMenus[index]),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),
                      Text(
                        'Restaurant Results',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (_filteredRestos.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No restaurants found'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredRestos.length,
                          itemBuilder: (context, index) => _buildRestoCard(_filteredRestos[index]),
                        ),
                    ] else ...[
                      // Popular Menus Section dengan sudut melengkung
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Popular Menus',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color(0xFF28110A),
                                  ),
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
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                if (index < _menuList.length) {
                                  return _buildMenuCircle(_menuList[index]);
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),

                      // Recommended Restaurants Section dengan sudut melengkung
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recommended Restaurants',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color(0xFF28110A),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const RestoEntryPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('See All'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _restoList.take(3).length,
                              itemBuilder: (context, index) => _buildRestoCard(_restoList[index]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              if (index == 0) return const MyHomePage();
              if (index == 1) return const WishlistPage();
              if (index == 2) return const ReservedRestaurantsPage();
              if (index == 3) return const OrderTakeawayPage();
              return const LoginApp();
            }),
          );
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
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
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