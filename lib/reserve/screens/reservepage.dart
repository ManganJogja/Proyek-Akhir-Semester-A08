import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mangan_jogja/main/screens/list_menuentry.dart';
import 'package:mangan_jogja/menu.dart';
import 'package:mangan_jogja/models/resto_entry.dart';
import 'package:mangan_jogja/reserve/models/reserve_entry.dart';
import 'package:mangan_jogja/reserve/screens/edit_reserve.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/logout.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:mangan_jogja/wishlist/screens/wishlist_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReservedRestaurantsPage extends StatefulWidget {
  const ReservedRestaurantsPage({super.key});
  
  @override
  State<ReservedRestaurantsPage> createState() =>
      _ReservedRestaurantsPageState();
}

class _ReservedRestaurantsPageState extends State<ReservedRestaurantsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  final List<Widget> _pages = [
    const MyHomePage(), // Home
    const WishlistPage(), // Wishlist
    const ReservedRestaurantsPage(), // Reservation
    const ReservedRestaurantsPage(), // Orders
    const LoginApp(), // Logout
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      // Logout logic
      _performLogout();
    } else {
      // Navigasi ke halaman yang sesuai
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  Future<void> _performLogout() async {
    bool success = await LogoutHandler.logoutUser(context);
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginApp()),
      );
    }
  }
  String? selectedResto; 
  List<ReserveEntry> allReserves = [];
  List<String> restoOptions = []; 

  Future<List<ReserveEntry>> fetchReserve(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/reserve/json/');
    final restoResponse = await request.get('http://127.0.0.1:8000/admin-dashboard/json2/');
    
    List<RestoEntry> restoList = restoResponse.map<RestoEntry>((d) => RestoEntry.fromJson(d)).toList();
    Map<String, String> restoMap = {
      for (var resto in restoList) 
        resto.pk: resto.fields.namaResto,
        
    };

    List<ReserveEntry> listReserve = [];
    for (var d in response) {
      if (d != null) {
        var reserveEntry = ReserveEntry.fromJson(d);
        // Replace resto ID with resto name
        reserveEntry.fields.resto = restoMap[reserveEntry.fields.resto] ?? 'Unknown Restaurant';
        listReserve.add(reserveEntry);
      }
    }

    // Ambil nama restoran unik dari reservasi
    restoOptions = listReserve.map((entry) => entry.fields.resto).toSet().toList();
    restoOptions.insert(0, "All"); // Tambahkan opsi "All" untuk menampilkan semua

    return listReserve;
  }

  @override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();

  return Scaffold(
    key: _scaffoldKey,
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
          title: Text(
            "ManganJogja.",
            style: GoogleFonts.aDLaMDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color(0xFF3E190E),
              letterSpacing: 1.5,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFF3E190E)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
    body: Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Container(
      width: double.infinity, 
      padding: const EdgeInsets.symmetric(horizontal: 16.0), 
      child: Column(
        children: [
          // Center the title
          const SizedBox(height: 16),
          Text(
            "Reserved Restaurants",
            style: GoogleFonts.abhayaLibre(
              fontWeight: FontWeight.w700,
              fontSize: 25,
              color: const Color(0xFF3E190E),
            ),
            textAlign: TextAlign.center, 
          ),
          const SizedBox(height: 5), 
          Align(
            alignment: Alignment.centerRight, 
            child: IconButton(
              onPressed: _showFilterDialog, 
              icon: const Icon(Icons.filter_alt, color: Color(0xFF3E190E)),
              tooltip: "Filter",
            ),
          ),
        ],
      ),
    ),

        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder(
            future: fetchReserve(request),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Error fetching data.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                return const Center(
                  child: Text(
                    'No reserved restaurants found.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                );
              } else {
                allReserves = snapshot.data;

                // Filter reservasi berdasarkan restoran yang dipilih
                List<ReserveEntry> filteredReserves =
                    selectedResto == null || selectedResto == "All"
                        ? allReserves
                        : allReserves
                            .where((entry) => entry.fields.resto == selectedResto)
                            .toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 5,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: filteredReserves.length,
                  itemBuilder: (_, index) {
                    var entry = filteredReserves[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffE7DBC6),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: const Color(0xFF784B39), width: 1.5),
                      ),
                      padding: const EdgeInsets.only(
                        left: 18.0, right: 15.0, top: 20.0, bottom: 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF784B39),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                entry.fields.resto,
                                style: GoogleFonts.abhayaLibre(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          InfoRow(icon: Icons.person, text: entry.fields.name),
                          InfoRow(
                              icon: Icons.calendar_today,
                              text: formatDate(entry.fields.date)),
                          InfoRow(
                              icon: Icons.access_time,
                              text: entry.fields.time.toString()),
                          InfoRow(
                              icon: Icons.group,
                              text:
                                  "${entry.fields.guestQuantity.toString()} people"),
                          InfoRow(
                              icon: Icons.email, text: entry.fields.email),
                          InfoRow(
                              icon: Icons.phone,
                              text: entry.fields.phone.toString()),
                          InfoRow(
                              icon: Icons.note,
                              text: entry.fields.notes ?? '-'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                              onPressed: () async {
                                // Navigasi ke halaman edit dengan data entry
                                final updatedReserve = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditReservationScreen(
                                      reservationId: entry.pk,
                                    )
                                  ),
                                );

                                if (updatedReserve != null) {
                                  setState(() {
                                    // Perbarui data lokal dengan data yang diubah
                                    int index = allReserves.indexWhere((e) => e.pk == updatedReserve.pk);
                                    if (index != -1) {
                                      allReserves[index] = updatedReserve;
                                    }
                                  });
                                }
                              },
                              icon: const Icon(Icons.edit, size: 20, color: Color(0xFF3E190E)),
                            ),
                              IconButton(
                                onPressed: () async {
                                  final request = context.read<CookieRequest>();
                                  try {
                                    final response = await request.postJson(
                                    "http://127.0.0.1:8000/reserve/delete-flutter/",
                                    jsonEncode(<String, String>{
                                      'pk': entry.pk.toString(),
                                    })
                              );

                              // Check if deletion was successful
                              if (response['status'] == 'success') {
                                // Remove the entry from the local list
                                setState(() {
                                  allReserves.removeWhere((e) => e.pk == entry.pk);
                                });

                                // Optional: Show a success snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reservation deleted successfully')),
                                );
                              } else {
                                // Show error message if deletion failed
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response['message'] ?? 'Failed to delete reservation')),
                                );
                              }
                                  } catch (e) {
                                    // Handle any network or server errors
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: ${e.toString()}')),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.delete, size: 20, color: Color(0xFF3E190E)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomNav(
        onItemTapped: _onItemTapped,
        currentIndex: _currentIndex,
      ),
  );
}

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Restaurant'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: restoOptions.map((restoName) {
                return ListTile(
                  title: Text(restoName),
                  onTap: () {
                    setState(() {
                      selectedResto = restoName == "All" ? null : restoName;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}



class InfoRow extends StatefulWidget {
  final IconData icon;
  final String text;

  const InfoRow({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  State<InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<InfoRow> {
  bool isExpanded = false; 

  @override
  Widget build(BuildContext context) {
    const maxTextLength = 30;
    bool isTextLong = widget.text.length > maxTextLength;

    String displayText = isExpanded || !isTextLong
        ? widget.text
        : "${widget.text.substring(0, maxTextLength)}...";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(widget.icon, size: 18, color: const Color(0xFF3E190E)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    displayText,
                    style: GoogleFonts.abhayaLibre(
                      fontSize: 16,
                      color: const Color(0xFF3E190E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
