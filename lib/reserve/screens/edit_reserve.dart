import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EditReservationScreen extends StatefulWidget {
  final String reservationId;

  EditReservationScreen({required this.reservationId});

  @override
  _EditReservationScreenState createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  final _formKey = GlobalKey<FormState>();

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
    print('Sending data: $postData');
    print('Reservation ID: ${widget.reservationId}');

    final response = await request.post(
      'http://127.0.0.1:8000/reserve/edit-flutter/${widget.reservationId}/',
      jsonEncode(postData),  // Use jsonEncode to send JSON
      
    );

    // Rest of the code remains the same...
  } catch (e, stackTrace) {
    // Error handling...
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Reservation')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Name is required';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Date is required';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(labelText: 'Time (HH:MM:SS)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Time is required';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _guestQuantityController,
                      decoration: InputDecoration(labelText: 'Guest Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) return 'Enter a valid number';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@'))
                          return 'Enter a valid email';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null)
                          return 'Enter a valid phone number';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(labelText: 'Notes'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final request = CookieRequest();
                        _updateReservation(request); // Panggil fungsi untuk update data
                      }
                    },
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
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
