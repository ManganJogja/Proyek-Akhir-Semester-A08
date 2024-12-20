import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class OrderTakeawayForm extends StatefulWidget {
  const OrderTakeawayForm({Key? key}) : super(key: key);

  @override
  State<OrderTakeawayForm> createState() => _OrderTakeawayFormState();
}

class _OrderTakeawayFormState extends State<OrderTakeawayForm> {
  List<dynamic> menus = [];
  List<dynamic> restaurants = [];
  String? selectedMenu;
  String? selectedRestaurant;
  int? quantity;
  TimeOfDay? pickupTime;

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/order-takeaway/api/menus/');
    setState(() {
      menus = response;
    });
  }

  Future<void> fetchRestaurants(String menuId) async {
    final request = context.read<CookieRequest>();
    final response = await request.get(
      'http://127.0.0.1:8000/order-takeaway/api/restaurants/$menuId/',
    );
    setState(() {
      restaurants = response;
    });
  }

  Future<void> submitOrder(CookieRequest request) async {
    if (selectedMenu == null || selectedRestaurant == null || quantity == null || pickupTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final body = jsonEncode({
      'restaurant': selectedRestaurant,
      'order_items': [
        {'menu_item': selectedMenu, 'quantity': quantity}
      ],
      'pickup_time': '${pickupTime!.hour}:${pickupTime!.minute}:00',
    });

    print('Request JSON: $body'); // Debug log

    try {
      final response = await request.postJson(
        'http://127.0.0.1:8000/order-takeaway/api/order/create/',
        body,
      );
      print('Response: $response'); // Debug log

      if (response['success'] == true) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add order: ${response['message']}')),
        );
      }
    } catch (e) {
      print('Error adding order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add order.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFDAC0A3),
        title: const Text('Create Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Menu'),
              items: menus.map<DropdownMenuItem<String>>((menu) {
                return DropdownMenuItem(
                  value: menu['id'].toString(),
                  child: Text(menu['nama_menu']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMenu = value;
                  restaurants = [];
                  if (value != null) fetchRestaurants(value);
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Restaurant'),
              items: restaurants.map<DropdownMenuItem<String>>((restaurant) {
                return DropdownMenuItem(
                  value: restaurant['id'].toString(),
                  child: Text(restaurant['nama_resto']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRestaurant = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                quantity = int.tryParse(value);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Pickup Time'),
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    pickupTime = time;
                  });
                }
              },
              controller: TextEditingController(
                text: pickupTime != null
                    ? '${pickupTime!.hour}:${pickupTime!.minute}'
                    : '',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => submitOrder(request),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
