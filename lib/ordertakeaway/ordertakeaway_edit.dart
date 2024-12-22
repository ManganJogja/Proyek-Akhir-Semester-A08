import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class OrderTakeawayEdit extends StatefulWidget {
  final String orderId;

  const OrderTakeawayEdit({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderTakeawayEdit> createState() => _OrderTakeawayEditState();
}

class _OrderTakeawayEditState extends State<OrderTakeawayEdit> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMenu;
  String? _selectedRestaurant;
  int? _quantity;
  TimeOfDay? _pickupTime;
  List<dynamic> _menus = [];
  List<dynamic> _restaurants = [];

  Future<void> fetchMenus(CookieRequest request) async {
    try {
      final response =
          await request.get('http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/order-takeaway/api/menus/');
      setState(() {
        _menus = response is List ? response : [];
      });
    } catch (e) {
      print('Error fetching menus: $e');
    }
  }

  Future<void> fetchRestaurants(CookieRequest request, String menuId) async {
    try {
      final response = await request.get(
          'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/order-takeaway/api/restaurants/$menuId/');
      setState(() {
        _restaurants = response is List ? response : [];
      });
    } catch (e) {
      print('Error fetching restaurants: $e');
    }
  }

  Future<void> fetchOrderDetails(CookieRequest request) async {
    try {
      final response = await request.get(
          'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/order-takeaway/json/${widget.orderId}/');

      final List<dynamic> dataList =
          response is String ? jsonDecode(response) : response;
      if (dataList.isEmpty) {
        throw Exception("Empty response data");
      }

      final data = dataList[0];
      final fields = data['fields'];
      setState(() {
        _selectedMenu = data['pk'];
        _selectedRestaurant = fields['restaurant'];
        _pickupTime = TimeOfDay(
          hour: int.parse(fields['pickup_time'].split(':')[0]),
          minute: int.parse(fields['pickup_time'].split(':')[1]),
        );
        _quantity = fields['quantity'];
      });

      if (_selectedMenu != null) {
        await fetchRestaurants(request, _selectedMenu!);
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  Future<void> submitEdit(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      final body = jsonEncode({
        'restaurant': _selectedRestaurant,
        'order_items': [
          {'menu_item': _selectedMenu, 'quantity': _quantity},
        ],
        'pickup_time': '${_pickupTime?.hour}:${_pickupTime?.minute}:00',
      });

      try {
        final response = await request.postJson(
          'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/order-takeaway/api/order/edit/${widget.orderId}/',
          body,
        );

        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order updated successfully!')),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Failed to update order: ${response['message']}');
        }
      } catch (e) {
        print('Error updating order: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update order.')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchMenus(request);
    fetchOrderDetails(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFDAC0A3),
        title: const Text('Edit Order'),
      ),
      body: _menus.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _menus.any((menu) => menu['id'] == _selectedMenu)
                          ? _selectedMenu
                          : null,
                      items: _menus.map<DropdownMenuItem<String>>((menu) {
                        return DropdownMenuItem(
                          value: menu['id'],
                          child: Text(menu['nama_menu']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMenu = value;
                          _selectedRestaurant = null;
                        });
                        if (value != null) {
                          fetchRestaurants(request, value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Menu'),
                      validator: (value) =>
                          value == null ? 'Please select a menu' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _restaurants.any(
                              (restaurant) => restaurant['id'] == _selectedRestaurant)
                          ? _selectedRestaurant
                          : null,
                      items: _restaurants.map<DropdownMenuItem<String>>((restaurant) {
                        return DropdownMenuItem(
                          value: restaurant['id'],
                          child: Text(restaurant['nama_resto']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRestaurant = value;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Restaurant'),
                      validator: (value) => value == null
                          ? 'Please select a restaurant'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _quantity?.toString(),
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _quantity = int.tryParse(value) ?? 0;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Quantity must be a number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Pickup Time (HH:mm)'),
                      controller: TextEditingController(
                        text: _pickupTime != null
                            ? '${_pickupTime!.hour}:${_pickupTime!.minute}'
                            : '',
                      ),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _pickupTime ?? TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _pickupTime = time;
                          });
                        }
                      },
                      validator: (value) =>
                          _pickupTime == null ? 'Please select pickup time' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => submitEdit(request),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
