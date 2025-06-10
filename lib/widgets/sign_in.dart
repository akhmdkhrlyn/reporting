import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:reporting/pages/home_screen.dart';
import 'package:reporting/widgets/sign_up.dart';
import 'package:reporting/widgets/forgot_password.dart';
import 'package:reporting/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Inisialisasi ApiService
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani proses login ke API
  void _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi.')),
      );
      return;
    }

    try {
      await _apiService.login(_emailController.text, _passwordController.text);

      // Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigasi ke home jika berhasil
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Gagal: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        // Menambahkan SingleChildScrollView untuk menghindari overflow pada layar kecil
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sign In Title
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B67CA),
                    fontFamily: 'Hind Siliguri',
                  ),
                ),

                const SizedBox(height: 78),

                // Email Input Field (Menggunakan TextFormField agar konsisten)
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Color(0xFF5B67CA)),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email_outlined, color: Color(0xFFC6CEDD)),
                    labelText: 'Email ID or Username',
                    labelStyle: TextStyle(
                      fontFamily: 'Hind Siliguri',
                      color: Color(0xFFC6CEDD),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE3E8F1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5B67CA)),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Password Input Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Color(0xFF5B67CA)),
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFFC6CEDD),
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'Hind Siliguri',
                      color: Color(0xFFC6CEDD),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE3E8F1)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5B67CA)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFC6CEDD),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF5B67CA),
                        fontFamily: 'Hind Siliguri',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 55),

                // Sign In Button
                ElevatedButton(
                  // ** PERBAIKAN UTAMA: Hubungkan ke fungsi _handleSignIn **
                  onPressed: _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B67CA),
                    foregroundColor: const Color(0xFFFAFAFA),
                    elevation: 7,
                    shadowColor: const Color(0xFFF1F7FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                ),

                const SizedBox(height: 120),

                // Sign Up Link
                Center(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C406E),
                        fontFamily: 'Hind Siliguri',
                      ),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Sign Up",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5B67CA),
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignupWidget(),
                                    ),
                                  );
                                },
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
