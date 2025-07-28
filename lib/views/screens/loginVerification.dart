import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/otp_input_fields.dart';
import '../../views/screens/verificationfail.dart';

class LoginVerificationScreen extends StatefulWidget {
  const LoginVerificationScreen({super.key});

  @override
  State<LoginVerificationScreen> createState() =>
      _LoginVerificationScreenState();
}

class _LoginVerificationScreenState extends State<LoginVerificationScreen> {
  String _enteredOtp = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Background
          Container(
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientTop, AppColors.gradientBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                // 🔙 Back Icon & Shield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
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

                const SizedBox(height: 30),

                // 🖼 OTP Illustration
                SizedBox(
                  height: 200,
                  child: Image.asset('assets/Otp.png', fit: BoxFit.contain),
                ),

                const Spacer(),

                // 🔲 Bottom Panel
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Verify OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Please enter the OTP sent to your number",
                        style: TextStyle(color: AppColors.black54),
                      ),
                      const SizedBox(height: 24),

                      // 🔢 OTP Fields
                      OtpInputFields(
                        onCompleted: (otp) {
                          setState(() {
                            _enteredOtp = otp;
                          });
                        },
                      ),

                      const SizedBox(height: 30),

                      // ✅ Submit Button
                      GradientButton(
                        text: "Verify OTP",
                        onPressed: () {
                          if (_enteredOtp == "1234") {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.introduceYourself,
                            );
                          } else {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => const VerificationFailScreen(),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // 🔁 Resend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn’t receive a code? ",
                            style: TextStyle(color: AppColors.black87),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("OTP has been resent."),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.buttonStart,
                                ),
                              );
                            },
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                color: AppColors.link,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
