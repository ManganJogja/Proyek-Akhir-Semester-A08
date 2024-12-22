import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mangan_jogja/main/screens/list_menuentry.dart';
import 'package:mangan_jogja/menu.dart';
import 'package:mangan_jogja/ordertakeaway/ordertakeaway_page.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/logout.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/widgets/bottom_navbar.dart';
import 'package:mangan_jogja/wishlist/screens/wishlist_page.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReservationPageForm extends StatefulWidget {
  final String restoId; // Add this line

  const ReservationPageForm({Key? key, required this.restoId}) : super(key: key);

  @override
  State<ReservationPageForm> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPageForm> {
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  
  // Tambahkan controller untuk field
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guestQuantityController = TextEditingController();
  final _notesController = TextEditingController();

  // Data yang akan disimpan
  String _name = "";
  String _date = "";
  String _time = "";
  String _email = "";
  int _phone = 0;
  int _guestQuantity = 0;
  String _notes = "";
  int _currentIndex = 2;
  final List<Widget> _pages = [
    const MyHomePage(), // Home
    const WishlistPage(), // Wishlist
    const ReservedRestaurantsPage(), // Reservation
    const OrderTakeawayPage(), // Orders
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
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      "RESERVATION",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.abhayaLibre(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3E190E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ReservationField(
                      controller: _nameController,
                      label: "Name",
                      onSaved: (value) => _name = value ?? "",
                    ),
                    ReservationField(
                      controller: _dateController,
                      label: "Date",
                      isDate: true,
                      onSaved: (value) => _date = value ?? "",
                    ),
                    ReservationField(
                      controller: _timeController,
                      label: "Time",
                      isTime: true,
                      onSaved: (value) => _time = value ?? "",
                    ),
                    ReservationField(
                      controller: _emailController,
                      label: "Email",
                      onSaved: (value) => _email = value ?? "",
                    ),
                    ReservationField(
                      controller: _phoneController,
                      label: "Phone",
                      onSaved: (value) => _phone = int.tryParse(value ?? "0") ?? 0,
                    ),
                    ReservationField(
                      controller: _guestQuantityController,
                      label: "Guest quantity",
                      onSaved: (value) =>
                          _guestQuantity = int.tryParse(value ?? "0") ?? 0,
                    ),
                    ReservationField(
                      controller: _notesController,
                      label: "Notes",
                      isOptional: true,
                      onSaved: (value) => _notes = value ?? "",
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() => _isLoading = true);
                            try {
                              final response = await request.postJson(
                                "http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/reserve/reserve-flutter/${widget.restoId}/",
                                jsonEncode({
                                  'name': _name,
                                  'date': _date,
                                  'time': _time,
                                  'email': _email,
                                  'phone': _phone.toString(),
                                  'guest_quantity': _guestQuantity.toString(),
                                  'notes': _notes,
                                }),
                              );

                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Reservation created successfully!"),
                                  ),
                                );
                                  Navigator.push(
                                    context,
                                      MaterialPageRoute(
                                        builder: (context) => const ReservedRestaurantsPage(), // Halaman tujuan
                                      ),
                                    );   
                                   } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response['message'] ?? "An error occurred"),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to send data. Please try again."),
                                ),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
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
                          "CONFIRM RESERVATIONS",
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
                  // Format waktu menjadi HH:mm
                  final formattedTime =
                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                  controller.text = formattedTime;
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
            onSaved: onSaved,
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
