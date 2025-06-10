import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.fromLTRB(28, 128, 28, 55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo/Image
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 291),
                child: AspectRatio(
                  aspectRatio: 0.99,
                  child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          "images/gam1.png", // Ubah ke asset lokal
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 91),

              // LaporanKU Title
              Text(
                "LaporanKU",
                style: TextStyle(
                  fontFamily: 'Hind Siliguri',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5B67CA),
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description Text
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Plan what you will do to be more organized for today, tomorrow and beyond",
                  style: TextStyle(
                    fontFamily: 'Hind Siliguri',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2C406E),
                    height: 17 / 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 65),

              // Sign In Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF5B67CA),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF1F7FF),
                      offset: const Offset(-3, 7),
                      blurRadius: 13,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      // Navigasi ke halaman Sign In
                      Navigator.pushNamed(context, '/sign_in');
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(70, 18, 70, 18),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontFamily: 'Hind Siliguri',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFFFFF),
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign Up Text
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman Sign Up
                  Navigator.pushNamed(context, '/sign_up');
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontFamily: 'Hind Siliguri',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5B67CA),
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
