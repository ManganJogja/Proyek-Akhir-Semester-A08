import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/widgets/drawer.dart';

class ReservedRestaurantsPage extends StatefulWidget {
  @override
  _ReservedRestaurantsPageState createState() => _ReservedRestaurantsPageState();
}

class _ReservedRestaurantsPageState extends State<ReservedRestaurantsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, String>> reservations = [
    {
      'restaurantName': 'Gudeg YuDjum',
      'name': 'tahita',
      'date': 'Oct 30, 2024',
      'time': '1:11 p.m',
      'people': '2 people',
      'email': 'sdfghj@jkj.com',
      'phone': '1234567890',
      'note':''
    },
    {
      'restaurantName': 'Bakmi Jawa Mbah Surip',
      'name': 'tahita',
      'date': 'Oct 30, 2024',
      'time': '1:11 p.m',
      'people': '2 people',
      'email': 'sdfghj@jkj.com',
      'phone': '1234567890',
      'note':'mau yang adsalkndslkanlkdnklankansknaknknlsuandnwaukrewndukesnlkndalkhidkaem'
    },
    {
      'restaurantName': 'Sate Klathak Pak Pong',
      'name': 'tahita',
      'date': 'Oct 31, 2024',
      'time': '2:00 p.m',
      'people': '4 people',
      'email': 'example@domain.com',
      'phone': '0987654321',
      'note':'-'
    },
  ];

  String? selectedRestaurant;
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    var filteredReservations = reservations.where((reservation) {
      bool matchesRestaurant = selectedRestaurant == null ||
          reservation['restaurantName']!
              .toLowerCase()
              .contains(selectedRestaurant!.toLowerCase());
      bool matchesDate = selectedDate == null ||
          reservation['date']!.contains(selectedDate!);
      return matchesRestaurant && matchesDate;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFDAC0A3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            backgroundColor: const Color(0xFFE7DBC6),
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
              IconButton(
                icon: const Icon(Icons.menu, color: const Color(0xFF3E190E)),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
        ),
      ),
      endDrawer: const LeftDrawer(),
      body: Container(
        color: const Color(0xFFDAC0A3),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'Reserved Restaurants',
                  style: GoogleFonts.abhayaLibre(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E190E),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0), 
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF3E190E)),
                      onPressed: () {
                        _showFilterDialog(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (filteredReservations.isEmpty) 
              Column(
                children: [
                  Image.asset(
                    'assets/images/no_reservations.png', 
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Reservations Yet!',
                    style: GoogleFonts.abhayaLibre(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E190E),
                    ),
                  ),
                ],
              )
            else 
                 Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  for (var reservation in filteredReservations)
                    ReservationCard(
                      restaurantName: reservation['restaurantName']!,
                      name: reservation['name']!,
                      date: reservation['date']!,
                      time: reservation['time']!,
                      people: reservation['people']!,
                      email: reservation['email']!,
                      phone: reservation['phone']!,
                      note: reservation['note']!
                    ),
                ],
              ),
               const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

void _showFilterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            "Filter Reservations", 
            style: GoogleFonts.abhayaLibre(
              fontSize: 18,
              color: const Color(0xFF3E190E),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: selectedRestaurant,
              hint: Text("Select Restaurant"),
              onChanged: (value) {
                setState(() {
                  selectedRestaurant = value;
                });
              },
              items: ['Gudeg YuDjum', 'Bakmi Jawa Mbah Surip', 'Sate Klathak Pak Pong']
                  .map<DropdownMenuItem<String>>((restaurant) {
                return DropdownMenuItem<String>(
                  value: restaurant,
                  child: Text(restaurant),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedDate,
              hint: Text("Select Date"),
              onChanged: (value) {
                setState(() {
                  selectedDate = value;
                });
              },
              items: ['Oct 30, 2024', 'Oct 31, 2024']
                  .map<DropdownMenuItem<String>>((date) {
                return DropdownMenuItem<String>(
                  value: date,
                  child: Text(date),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedRestaurant = null;
                    selectedDate = null;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Clear Filters",
                  style: GoogleFonts.abhayaLibre(
                    fontSize: 16,
                    color: const Color(0xFF3E190E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Apply",
                  style: GoogleFonts.abhayaLibre(
                    fontSize: 16,
                    color: const Color(0xFF3E190E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

}

class ReservationCard extends StatelessWidget {
  final String restaurantName;
  final String name;
  final String date;
  final String time;
  final String people;
  final String email;
  final String phone;
  final String? note;
  

  const ReservationCard({
    Key? key,
    required this.restaurantName,
    required this.name,
    required this.date,
    required this.time,
    required this.people,
    required this.email,
    required this.phone,
    this.note,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F0E5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.brown,
          width: 1.5, 
        ),
      ),
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF784B39),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                restaurantName,
                style: GoogleFonts.abhayaLibre(
                  color: const Color(0xFFE7DBC6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                InfoRow(icon: Icons.person, text: name),
                InfoRow(icon: Icons.calendar_today, text: date),
                InfoRow(icon: Icons.access_time, text: time),
                InfoRow(icon: Icons.group, text: people),
                InfoRow(icon: Icons.email, text: email),
                InfoRow(icon: Icons.phone, text: phone),
                InfoRow(icon: Icons.note, text: (note?.isNotEmpty ?? false) ? note! : "-"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: const Color(0xFF3E190E)),
                  onPressed: () {
                    // belum selesai
                    print('Edit $restaurantName');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: const Color(0xFF3E190E)),
                  onPressed: () {
                    // belum selesai
                    print('Delete $restaurantName');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class InfoRow extends StatefulWidget {
  final IconData icon;
  final String text;

  const InfoRow({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  _InfoRowState createState() => _InfoRowState();
}

class _InfoRowState extends State<InfoRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Icon(widget.icon, size: 18, color: const Color(0xFF3E190E)),
          const SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                widget.text,
                maxLines: isExpanded ? null : 1, 
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: GoogleFonts.abhayaLibre(
                  fontSize: 16,
                  color: const Color(0xFF3E190E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (!isExpanded && widget.text.length > 20) 
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = true;
                });
              },
              child: Text(
                " More",
                style: GoogleFonts.abhayaLibre(
                  fontSize: 16,
                  color: const Color(0xFF3E190E), 
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

