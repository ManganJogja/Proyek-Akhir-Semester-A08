import 'package:flutter/material.dart';

class OrderTakeawayForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Menu Dropdown
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Menu'),
              items: [
                DropdownMenuItem(child: Text('Menu 1'), value: 'menu1'),
                DropdownMenuItem(child: Text('Menu 2'), value: 'menu2'),
              ],
              onChanged: (value) {},
            ),

            // Restaurant Dropdown
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Restaurant'),
              items: [
                DropdownMenuItem(child: Text('Restaurant 1'), value: 'rest1'),
                DropdownMenuItem(child: Text('Restaurant 2'), value: 'rest2'),
              ],
              onChanged: (value) {},
            ),

            // Quantity
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),

            // Pickup Time
            TextFormField(
              decoration: InputDecoration(labelText: 'Pickup Time'),
              keyboardType: TextInputType.datetime,
            ),

            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6F4E37),
              ),
              onPressed: () {},
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
