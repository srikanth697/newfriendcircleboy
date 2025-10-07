import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../widgets/gradient_button.dart';
import '../../controllers/api_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Provider.of<ApiController>(context, listen: false);
    final mobile = _mobileCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    final success = await controller.signup(mobile: mobile, email: email);

    if (!mounted) return;

    if (success) {
      final res = controller.signupResponse ?? {};
      final msg = res["message"] ?? "Signup successful!";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Success: $msg")));

      // Navigate to verification screen
      Navigator.pushNamed(context, AppRoutes.loginVerification);
    } else {
      final err =
          controller.error ??
          controller.signupResponse?["message"] ??
          "Something went wrong";

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $err")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Consumer<ApiController>(
          builder: (context, controller, _) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Trust Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text(
                              "100% Trusted and secure",
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/sheild.png',
                              height: 24,
                              width: 24,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Illustration
                      SizedBox(
                        height: 260,
                        child: Image.asset(
                          'assets/Signup.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const Spacer(),

                      // Bottom sheet with form
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 30,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Center(
                                child: Text(
                                  "Register yourself",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Center(
                                child: Text(
                                  "Please register or sign up",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Mobile field
                              const Text(
                                "Mobile Number",
                                style: TextStyle(color: AppColors.black87),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.inputField,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  controller: _mobileCtrl,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Enter mobile number';
                                    }
                                    if (v.trim().length < 7) {
                                      return 'Enter valid number';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter mobile number",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Email field
                              const Text(
                                "Email ID",
                                style: TextStyle(color: AppColors.black87),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.inputField,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Enter email';
                                    }
                                    if (!RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+',
                                    ).hasMatch(v.trim())) {
                                      return 'Enter valid email';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter email",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Verify OTP Button
                              controller.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GradientButton(
                                      text: "Verify OTP",
                                      onPressed: _submit,
                                    ),

                              const SizedBox(height: 12),

                              // Already have account? Log In
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  },
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black87,
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
            );
          },
        ),
      ),
    );
  }
}
