import 'package:flutter/material.dart';
import 'package:mangan_jogja/wishlist/models/wishlist_entry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AddWishlistPage extends StatefulWidget {
  const AddWishlistPage({super.key});

  @override
  State<AddWishlistPage> createState() => _AddWishlistPageState();
}

class _AddWishlistPageState extends State<AddWishlistPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _datePlan;
  String _additionalNote = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _datePlan ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _datePlan) {
      setState(() {
        _datePlan = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Wishlist',
          style: TextStyle(color: Color(0xFF3E190E)),
        ),
        backgroundColor: const Color(0xFFDAC0A3),
        iconTheme: const IconThemeData(color: Color(0xFF3E190E)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Plan Date",
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _datePlan == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(_datePlan!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Additional Note",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _additionalNote = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _datePlan != null) {
                    // Implement your add wishlist logic here
                    // You'll need to make HTTP POST request to your Django backend
                    
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add Wishlist"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}