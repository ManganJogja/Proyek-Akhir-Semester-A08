import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'ordertakeaway_form.dart';
import 'ordertakeaway_edit.dart';

class OrderTakeawayPage extends StatefulWidget {
  const OrderTakeawayPage({Key? key}) : super(key: key);

  @override
  State<OrderTakeawayPage> createState() => _OrderTakeawayPageState();
}

class _OrderTakeawayPageState extends State<OrderTakeawayPage> {
  late Future<List<dynamic>> _ordersFuture;
  String _currentFilter = "A-Z"; // Default filter option

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders(context.read<CookieRequest>());
  }

  Future<List<dynamic>> fetchOrders(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/order-takeaway/json/');
      if (response is List) {
        return _sortOrders(response);
      } else if (response is String) {
        return _sortOrders(jsonDecode(response));
      } else {
        throw Exception('Unexpected data format: ${response.runtimeType}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  List<dynamic> _sortOrders(List<dynamic> orders) {
    // Sort based on menu name (A-Z or Z-A)
    orders.sort((a, b) {
      final nameA = a['fields']['menu_item'] ?? '';
      final nameB = b['fields']['menu_item'] ?? '';
      return _currentFilter == "A-Z"
          ? nameA.compareTo(nameB)
          : nameB.compareTo(nameA);
    });
    return orders;
  }

  void refreshOrders() {
    setState(() {
      _ordersFuture = fetchOrders(context.read<CookieRequest>());
    });
  }

  Future<void> deleteOrder(CookieRequest request, String orderId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/order-takeaway/api/order/delete/$orderId/',
        {},
      );

      if (response['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order deleted successfully!')),
        );
        refreshOrders();
      } else {
        throw Exception('Failed to delete order: ${response['message']}');
      }
    } catch (e) {
      print('Error deleting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete order.')),
      );
    }
  }

  void _changeFilter(String? newFilter) {
    setState(() {
      _currentFilter = newFilter!;
      refreshOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takeaway Orders'),
        backgroundColor: const Color(0xFF6F4E37),
      ),
      body: Column(
        children: [
          // Filter Dropdown and Add Button Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dropdown for Sorting
                DropdownButton<String>(
                  value: _currentFilter,
                  items: const [
                    DropdownMenuItem(
                      value: "A-Z",
                      child: Text("Sort: A-Z"),
                    ),
                    DropdownMenuItem(
                      value: "Z-A",
                      child: Text("Sort: Z-A"),
                    ),
                  ],
                  onChanged: _changeFilter,
                ),
                // Add Order Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderTakeawayForm(),
                      ),
                    ).then((_) => refreshOrders());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F4E37),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Order"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching orders.'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No orders available.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final order = snapshot.data![index];
                      final fields = order['fields'];

                      final menuName = fields['menu_item'] ?? 'Unknown Menu';
                      final restaurantName = fields['restaurant'] ?? 'Unknown Restaurant';
                      final quantity = fields['quantity'] ?? 'Unknown Quantity';
                      final pickupTime = fields['pickup_time'];
                      final totalPrice = fields['total_price'];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF6F4E37),
                            child: Text(
                              menuName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menuName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Restaurant: $restaurantName',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Quantity: $quantity',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Pickup Time: $pickupTime',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Total Price: Rp$totalPrice',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderTakeawayEdit(orderId: order['pk']),
                                    ),
                                  ).then((_) => refreshOrders());
                                },
                                tooltip: 'Edit Order',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteOrder(request, order['pk']);
                                },
                                tooltip: 'Delete Order',
                              ),
                            ],
                          ),
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
    );
  }
}
