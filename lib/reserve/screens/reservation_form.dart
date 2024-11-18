import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mangan_jogja/reserve/screens/reservepage.dart';
import 'package:mangan_jogja/widgets/drawer.dart';

class ReservationPageForm extends StatefulWidget {
  const ReservationPageForm({Key? key}) : super(key: key);

  @override
  State<ReservationPageForm> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPageForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = "";
  String _date = "";
  String _time = "";
  String _email = "";
  int _phone = 0;
  int _guestQuantity = 0;
  String _notes = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            backgroundColor: const Color(0xFFE7DBC6),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF3E190E)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Gudeg Yudjum",
              style: GoogleFonts.mulish(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xFF3E190E),
                letterSpacing: 1.0,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person, color: Color(0xFF3E190E)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF3E190E)),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
        ),
      ),
      endDrawer: const LeftDrawer(),
      body: Builder(
        builder: (context) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "RESERVATION",
                        style: GoogleFonts.abhayaLibre(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3E190E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAC0A3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReservationField(
                            label: "Name",
                            onSaved: (value) => _name = value ?? "",
                          ),
                          ReservationField(
                            label: "Date",
                            isDate: true,
                            onSaved: (value) => _date = value ?? "",
                          ),
                          ReservationField(
                            label: "Time",
                            isTime: true,
                            onSaved: (value) => _time = value ?? "",
                          ),
                          ReservationField(
                            label: "Email",
                            onSaved: (value) => _email = value ?? "",
                          ),
                          ReservationField(
                            label: "Phone",
                            onSaved: (value) => _phone = int.tryParse(value ?? "0") ?? 0,
                          ),
                          ReservationField(
                            label: "Guest quantity",
                            onSaved: (value) => _guestQuantity = int.tryParse(value ?? "0") ?? 0,
                          ),
                          ReservationField(
                            label: "Notes",
                            isOptional: true,
                            onSaved: (value) => _notes = value ?? "",
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E190E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Reservation Confirmed'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Name: $_name'),
                                              Text('Date: $_date'),
                                              Text('Time: $_time'),
                                              Text('Email: $_email'),
                                              Text('Phone: $_phone'),
                                              Text('Guest Quantity: $_guestQuantity'),
                                              Text('Notes: $_notes'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                context, 
                                                MaterialPageRoute(
                                                  builder: (context) => ReservedRestaurantsPage()),
                                              );                                              
                                              _formKey.currentState!.reset();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class ReservationField extends StatelessWidget {
  final String label;
  final bool isDate;
  final bool isTime;
  final bool isOptional;
  final FormFieldSetter<String>? onSaved;

  const ReservationField({
    Key? key,
    required this.label,
    this.isDate = false,
    this.isTime = false,
    this.isOptional = false,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.aDLaMDisplay(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3E190E),
              fontSize: 15,
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
                borderSide: BorderSide.none,
              ),
            ),
            onSaved: onSaved,
            validator: (value) {
              if (!isOptional && (value == null || value.isEmpty)) {
                return '$label cannot be empty';
              }

              if (label == "Email" && !RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value ?? '')) {
                return 'Please enter a valid email address';
              }

              if (label == "Phone" && value != null && !RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Phone number must be numeric';
              }

              if (label == "Guest quantity") {
                final guestQuantity = int.tryParse(value ?? "");
                if (guestQuantity == null || guestQuantity <= 0) {
                  return 'Guest quantity must be a number greater than 0';
                }
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
