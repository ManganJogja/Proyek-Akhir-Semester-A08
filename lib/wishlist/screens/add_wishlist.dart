// import 'package:flutter/material.dart';
// import 'package:mangan_jogja/wishlist/models/wishlist_entry.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import '../providers/wishlist_provider.dart';

// class AddWishlistPage extends StatefulWidget {
//   final String restaurantId;

//   const AddWishlistPage({
//     super.key,
//     required this.restaurantId,
//   });

//   @override
//   State<AddWishlistPage> createState() => _AddWishlistPageState();
// }

// class _AddWishlistPageState extends State<AddWishlistPage> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _datePlan;
//   String _additionalNote = "";

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _datePlan ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2025),
//     );
//     if (picked != null && picked != _datePlan) {
//       setState(() {
//         _datePlan = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final wishlistProvider = Provider.of<WishlistProvider>(context);
//     final request = context.watch<CookieRequest>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add Plan',
//           style: TextStyle(color: Color(0xFF3E190E)),
//         ),
//         backgroundColor: const Color(0xFFDAC0A3),
//         iconTheme: const IconThemeData(color: Color(0xFF3E190E)),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Title
//             Text(
//               'Add Plan to Wishlist',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF3E190E),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Form Container
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5E6D3),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Date Plan Field
//                     Text(
//                       'Plan Date',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF3E190E),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     InkWell(
//                       onTap: () => _selectDate(context),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               _datePlan == null
//                                   ? 'Select Date'
//                                   : DateFormat('yyyy-MM-dd').format(_datePlan!),
//                             ),
//                             Icon(Icons.calendar_today),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Additional Notes Field
//                     Text(
//                       'Additional Notes',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF3E190E),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Enter your notes here',
//                       ),
//                       maxLines: 3,
//                       onChanged: (value) => _additionalNote = value,
//                     ),
//                     const SizedBox(height: 20),
//                     // Submit Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             if (_datePlan == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Please select a date'),
//                                 ),
//                               );
//                               return;
//                             }

//                             // Show loading indicator
//                             showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               },
//                             );

//                             try {
//                               final success = await wishlistProvider.addWishlistWithPlan(
//                                 request,
//                                 widget.restaurantId,
//                                 _datePlan!,
//                                 _additionalNote,
//                               );

//                               // Pop loading dialog
//                               if (mounted) Navigator.pop(context);

//                               if (success && mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Successfully added plan to wishlist!'),
//                                   ),
//                                 );
//                                 Navigator.pop(context);
//                               } else if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Failed to add plan. Please check your input and try again.'),
//                                   ),
//                                 );
//                               }
//                             } catch (e) {
//                               // Pop loading dialog
//                               if (mounted) Navigator.pop(context);
                              
//                               if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text('Error: ${e.toString()}'),
//                                   ),
//                                 );
//                               }
//                             }
//                           }
//                         },
//                         child: const Text(
//                           'Save Plan',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }