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

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders(context.read<CookieRequest>());
  }

  Future<List<dynamic>> fetchOrders(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/order-takeaway/json/');
      if (response is List) {
        return response;
      } else if (response is String) {
        return jsonDecode(response);
      } else {
        throw Exception('Unexpected data format: ${response.runtimeType}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takeaway Orders'),
        backgroundColor: const Color(0xFF6F4E37),
      ),
      body: FutureBuilder<List<dynamic>>(
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

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Menu: $menuName'),
                        Text('Restaurant: $restaurantName'),
                        Text('Quantity: $quantity'),
                        Text('Pickup Time: $pickupTime'),
                        Text('Total Price: Rp$totalPrice'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderTakeawayEdit(orderId: order['pk']),
                                  ),
                                ).then((_) => refreshOrders());
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteOrder(request, order['pk']);
                              },
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderTakeawayForm(),
            ),
          ).then((_) => refreshOrders());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
