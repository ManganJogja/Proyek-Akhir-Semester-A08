import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangan_jogja/reserve/screens/login.dart';
import 'package:mangan_jogja/reserve/screens/register.dart';
import 'package:mangan_jogja/widgets/drawer.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Color _loginColor = const Color(0xFFDAC0A3);
  Color _registerColor = const Color(0xFFDAC0A3);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ensure the Stack has a size constraint
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5, // Adjusted height to prevent "no size" error
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -60,
                      left: -20,
                      child: Image.asset(
                        'assets/images/megabendung2.png',
                        width: 170,
                        height: 250,
                      ),
                    ),
                    Positioned(
                      top: 30,
                      right: -10,
                      child: Image.asset(
                        'assets/images/megabendung1.png',
                        width: 120,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      top: -20,
                      left: 135,
                      child: Image.asset(
                        'assets/images/Logo.png',
                        width: 350,
                        height: 350,
                      ),
                    ),

                    Positioned(
                      top: 200,
                      left: -10,
                      child: Image.asset(
                        'assets/images/megabendung1.png',
                        width: 120,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      bottom: -65,
                      right: -25,
                      child: Image.asset(
                        'assets/images/megabendung2.png',
                        width: 170,
                        height: 250,
                      ),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Hello, welcome!',
                style: GoogleFonts.aDLaMDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E190E),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity, 
                height: 80,
                padding: const EdgeInsets.all(12.0), // Padding di dalam kotak
                decoration: const BoxDecoration(
                  color: const Color(0xFF3E190E), // Warna coklat tua
                ),
                child: Text(
                  'Mangan Jogja\nWhere Every Meal is a Journey!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abhayaLibre(
                    fontSize: 20,
                    color: const Color(0xFFE7DBC6), // Warna teks putih atau cerah
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _loginColor = const Color(0xFFAD8262);
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _loginColor = const Color(0xFFDAC0A3);
                    });
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _loginColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aDLaMDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _registerColor = const Color(0xFFAD8262);
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _registerColor = const Color(0xFFDAC0A3);
                    });
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _registerColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aDLaMDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ManganJogja.  © 2024, PBP-A (A08)',
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(0, 0, 0, 10), // Warna teks sesuai tema
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
