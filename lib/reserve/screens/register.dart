import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:mangan_jogja/widgets/drawer.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>(); 
  Color _loginNowColor = const Color(0xFF3E190E);
  Color _registerButtonNowColor = const Color(0xFFDAC0A3); 

  @override
  Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
     return Scaffold(
      key: _scaffoldKey,
    backgroundColor: const Color(0xFFE7DBC6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFDAC0A3),
            title: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Logo.png', 
                    height: 40.0, 
                  ),
                  const SizedBox(width: 8.0), 
                  Text(
                    "ManganJogja.",
                    style: GoogleFonts.aDLaMDisplay(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color(0xFF3E190E),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Color(0xFF3E190E)),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: const LeftDrawer(),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 45.0), 
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Account Now!',
                      style: GoogleFonts.aDLaMDisplay(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: const Color(0xFF3E190E),
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              const SizedBox(height: 25.0),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username',
                        style: GoogleFonts.aDLaMDisplay(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: const Color(0xFF3E190E),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8F0E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 25.0),

                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: GoogleFonts.aDLaMDisplay(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: const Color(0xFF3E190E),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8F0E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {  
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 25.0),

                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Password',
                        style: GoogleFonts.aDLaMDisplay(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: const Color(0xFF3E190E),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8F0E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 25.0),

                 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0), 
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        setState(() {
                          _registerButtonNowColor = const Color(0xFFAD8262); // Warna saat hover
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _registerButtonNowColor = const Color(0xFFDAC0A3); // Warna default
                        });
                      },
                    child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                      String username = _usernameController.text;
                      String password1 = _passwordController.text;
                      String password2 = _confirmPasswordController.text;

                      
                      final response = await request.postJson(
                          "http://127.0.0.1:8000/auth/register/",
                          jsonEncode({
                            "username": username,
                            "password1": password1,
                            "password2": password2,
                          }));
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully registered!'),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to register!'),
                            ),
                          );
                        }
                        
                      }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFF8F0E5),
                    backgroundColor: _registerButtonNowColor, 
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Text(
                    'Sign Up', 
                    style: GoogleFonts.aDLaMDisplay(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xFF3E190E),
                      letterSpacing: 1.5,
                    ),
                  ),
                    ),
                    ),
                  
                  ),
                  const SizedBox(height: 16.0),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0), 
              child: Center(
                child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    setState(() {
                      _loginNowColor = const Color(0xFFB07347);
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _loginNowColor = const Color(0xFF3E190E);
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already signed up?  ',
                      style: GoogleFonts.aDLaMDisplay(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: const Color(0xFFB07347),
                      ),
                      children: [
                        TextSpan(
                          text: 'Login here ',
                          style: GoogleFonts.aDLaMDisplay(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: _loginNowColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
              ),
              const SizedBox(height: 60.0),
               Align(
                alignment: Alignment.center,
                child: SizedBox(
                width: double.infinity,
                height: 150.00, 
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                 
                    Positioned.fill(
                      top: 50, 
                      left: 0,
                      right: 0,
                      bottom: -100,
                      child: Container(
                        color: const Color(0xFFAD8262),
                        height: 1000.0,  
                      ),
                    ),
                    
                   Positioned(
                    top: 0,
                    left: 50,
                    right: 50,
                    child: Card(
                    color: const Color(0xFF784B39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      
                      child: Column(
                        children: [
                          Text(
                            '\nSTAY UPDATED WITH THE LATEST',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.abhayaLibre(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0), 
                          Text(
                            'CULINARY TRENDS IN JOGJA!\n',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.abhayaLibre(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                   ),
                  ],
                ),
              ),
            ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
