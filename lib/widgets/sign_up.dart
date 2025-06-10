import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reporting/widgets/sign_in.dart';
import 'package:reporting/services/api_service.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  // Controller dan state untuk visibilitas password
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Inisialisasi ApiService
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ** HANYA ADA SATU FUNGSI _handleSignUp **
  // Fungsi untuk menangani proses pendaftaran ke API
  void _handleSignUp() async {
    // Validasi dasar agar tidak mengirim data kosong
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi.')));
      return;
    }

    try {
      await _apiService.register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      // Tampilkan pesan sukses dan navigasi ke sign in
      // Pengecekan 'mounted' adalah praktik yang baik setelah operasi async
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil! Silakan login.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInWidget()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pendaftaran Gagal: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(35, 100, 35, 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul "Sign Up"
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontFamily: 'Hind Siliguri',
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5B67CA),
                ),
              ),

              const SizedBox(height: 69),

              // Gunakan TextFormField untuk input yang lebih baik
              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person, color: Color(0xFFC6CEDD)),
                  labelText: 'Username',
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

              // Email ID Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email, color: Color(0xFFC6CEDD)),
                  labelText: 'Email ID',
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

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Terapkan visibilitas
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock, color: Color(0xFFC6CEDD)),
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
                  // Tambahkan ikon mata untuk toggle password
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

              const SizedBox(height: 55),

              // Tombol "Create"
              ElevatedButton(
                onPressed:
                    _handleSignUp, // Tombol ini sekarang memanggil fungsi yang benar
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B67CA),
                  foregroundColor: const Color(0xFFFAFAFA),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 7,
                  shadowColor: const Color(0xFFF1F7FF),
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(
                    fontFamily: 'Hind Siliguri',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 95),

              // Link ke halaman "Sign In"
              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Hind Siliguri',
                      fontSize: 14,
                      color: Color(0xFF2C406E),
                    ),
                    children: [
                      const TextSpan(text: 'Have an account? '),
                      TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5B67CA),
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInWidget(),
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
    );
  }
}
