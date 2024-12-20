import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mangan_jogja/main/screens/list_menuentry.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/logout.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:mangan_jogja/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EditReservationScreen extends StatefulWidget {
  final String reservationId;

  EditReservationScreen({required this.reservationId});

  @override
  _EditReservationScreenState createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 1;
  final List<Widget> _pages = [
    const MenuEntryPage(), // Home
    const ReservedRestaurantsPage(), // Wishlist
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
  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _guestQuantityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;

@override
void initState() {
  super.initState();
  final request = CookieRequest(); 
  _fetchReservationDetails(request);
}

Future<void> _fetchReservationDetails(CookieRequest request) async {
  setState(() {
    _isLoading = true;
  });

  try {
    final dynamic data = await request.get(
      'http://127.0.0.1:8000/reserve/json/${widget.reservationId}/',
    );
    print(data);
    // Django returns a list with one item, so we need to access the first item's fields
    if (data != null && data is List && data.isNotEmpty) {
      final fields = data[0]['fields'] ?? {};

      _nameController.text = fields['name']?.toString() ?? '';
      _dateController.text = fields['date']?.toString() ?? '';
      _timeController.text = fields['time']?.toString() ?? '';
      _guestQuantityController.text = fields['guest_quantity']?.toString() ?? '0';
      _emailController.text = fields['email']?.toString() ?? '';
      _phoneController.text = fields['phone']?.toString() ?? '0';
      _notesController.text = fields['notes']?.toString() ?? '';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No reservation details found'),
        backgroundColor: Colors.red,
      ));
    }
  } catch (e, stackTrace) {
    print('Error fetching reservation details: $e');
    print('Stack trace: $stackTrace');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error fetching details: $e'),
      backgroundColor: Colors.red,
    ));
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


Future<void> _updateReservation(CookieRequest request) async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  Map<String, dynamic> postData = {
    'name': _nameController.text.trim(),
    'date': _dateController.text.trim(),
    'time': _timeController.text.trim(),
    'guest_quantity': _guestQuantityController.text.trim(),
    'email': _emailController.text.trim(),
    'phone': _phoneController.text.trim(),
    'notes': _notesController.text.trim(),
  };

  try {
    final response = await request.post(
      'http://127.0.0.1:8000/reserve/edit-flutter/${widget.reservationId}/',
      jsonEncode(postData),  
      
    );
  print('Response: ${response.statusCode}, ${response.body}');

  } catch (e, stackTrace) {
    setState(() {
      print('Error: $e');
      _isLoading = false;
    });
  }
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
          ],
        ),
      ),
    ),
    drawer: const LeftDrawer(),
      body: SingleChildScrollView(
    child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
              child: Text(
                "EDIT RESERVATION",
                textAlign: TextAlign.center,
                style: GoogleFonts.abhayaLibre(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3E190E),
                ),
              ),
              ),
              const SizedBox(height: 20),
              ReservationField(
                controller: _nameController,
                label: "Name",
              ),
              ReservationField(
                controller: _dateController,
                label: "Date",
                isDate: true,
              ),
              ReservationField(
                controller: _timeController,
                label: "Time",
                isTime: true,
              ),
              ReservationField(
                controller: _guestQuantityController,
                label: "Guest quantity",
              ),
              ReservationField(
                controller: _emailController,
                label: "Email",
              ),
              ReservationField(
                controller: _phoneController,
                label: "Phone",
              ),
              ReservationField(
                controller: _notesController,
                label: "Notes",
                isOptional: true,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final request = CookieRequest();
                      _updateReservation(request);
                    }
                  Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReservedRestaurantsPage()),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E190E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        ).copyWith(
                          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.hovered)) {
                              return const Color(0xFFDAC0A3).withOpacity(0.2); // Hover overlay color
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xFFDAC0A3).withOpacity(0.4); // Pressed state color
                            }
                            return Colors.transparent;
                          }),
                        ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.abhayaLibre(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFFDAC0A3),
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
      ),
      bottomNavigationBar: BottomNav(
        onItemTapped: _onItemTapped,
        currentIndex: _currentIndex,
      ),
    );
  }

}

class ReservationField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isDate;
  final bool isTime;
  final bool isOptional;
  final FormFieldSetter<String>? onSaved;

  const ReservationField({
    Key? key,
    required this.controller,
    required this.label,
    this.isDate = false,
    this.isTime = false,
    this.isOptional = false,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.aDLaMDisplay(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color(0xFF3E190E),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: isDate || isTime,
            onTap: () async {
              if (isDate) {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              } else if (isTime) {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  controller.text = selectedTime.format(context);
                }
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F0E5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFFAD8262),
                  width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (!isOptional && (value == null || value.isEmpty)) {
                return '$label cannot be empty';
              }
              if (label == "Email" &&
                  !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value ?? "")) {
                return 'Enter a valid email';
              }
              if (label == "Phone" && value != null && !RegExp(r'^\d{10,15}$').hasMatch(value)) {
                return 'Enter a valid phone number';
              }
              if (label == "Guest quantity" &&
                  (int.tryParse(value ?? "0") ?? 0) <= 0) {
                return 'Guest quantity must be greater than 0';
              }
              return null;
            },
          ),

        ],
      ),
    );
  }
}
