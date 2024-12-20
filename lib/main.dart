import 'package:flutter/material.dart';
import 'package:mangan_jogja/reserve/screens/start_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'wishlist/providers/wishlist_provider.dart'; // Import WishlistProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()), // Tambahkan WishlistProvider
        Provider(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.brown,
          ).copyWith(secondary: Colors.brown[400]),
        ),
        home: StartPage(),
      ),
    );
  }
}