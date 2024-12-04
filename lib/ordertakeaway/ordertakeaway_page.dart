import 'package:flutter/material.dart';

class OrderTakeawayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takeaway Orders'),
        backgroundColor: const Color(0xFF6F4E37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header with sort and add order button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: 'A-Z',
                  items: ['A-Z', 'Z-A', 'Newest', 'Oldest']
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text('Sort by: $value'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    // Handle sort logic
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    // Show add order form
                  },
                  child: const Text('Add Order'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of orders displayed as cards
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with dynamic data length
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menu
                          _buildRowItem('Menu', 'Bakmi Jawa'),
                          const SizedBox(height: 8.0),

                          // Restaurant
                          _buildRowItem('Restaurant', 'Bakmi Jawa Ibu Ana'),
                          const SizedBox(height: 8.0),

                          // Quantity
                          _buildRowItem('Quantity', '2'),
                          const SizedBox(height: 8.0),

                          // Pickup Time
                          _buildRowItem('Pickup Time', '16:15'),
                          const SizedBox(height: 8.0),

                          // Total Price
                          _buildRowItem('Total Price', 'Rp64,000'),
                          const SizedBox(height: 16.0),

                          // Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Handle edit
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Handle delete
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
