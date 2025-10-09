import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../widgets/gradient_button.dart';
import '../../controllers/api_controller.dart';
import '../../widgets/otp_input_fields.dart';

class LoginVerificationScreen extends StatefulWidget {
  const LoginVerificationScreen({super.key});

  @override
  State<LoginVerificationScreen> createState() =>
      _LoginVerificationScreenState();
}

class _LoginVerificationScreenState extends State<LoginVerificationScreen> {
  String? _email;
  String? _mobile;
  String? _source; // "login" or "signup"
  String _otp = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _email = (args?['email'] as String?)?.trim();
    _mobile = (args?['mobile'] as String?)?.trim();
    _source = (args?['source'] as String?)?.trim().toLowerCase() ?? "login";

    // Ensure controller knows the identity/flow even if user navigated here directly.
    final api = Provider.of<ApiController>(context, listen: false);
    api.setPendingIdentity(email: _email, mobile: _mobile, source: _source);
  }

  Future<void> _verifyOtp() async {
    final api = Provider.of<ApiController>(context, listen: false);
    final otp = _otp.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter the OTP')));
      return;
    }

    final ok = await api.verifyOtp(
      otp: otp,
      email: _email,
      mobile: _mobile,
      source: _source, // ensure "login" for login flow
    );
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ OTP verified!')));
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.introduceYourself,
        (_) => false,
      );
    } else {
      final msg = api.error ?? 'OTP verification failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _resendOtp() async {
    final api = Provider.of<ApiController>(context, listen: false);

    if ((_source ?? "").toLowerCase() == "login") {
      final ok = await api.requestLoginOtp(email: _email, mobile: _mobile);
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent. Please check your inbox.')),
        );
      } else {
        final msg = api.error ?? 'Failed to resend OTP';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
      return;
    }

    if ((_source ?? "").toLowerCase() == "signup") {
      if ((_email == null || _email!.isEmpty) &&
          (_mobile == null || _mobile!.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing email/mobile to resend OTP.')),
        );
        return;
      }
      final ok = await api.signup(mobile: _mobile ?? "", email: _email ?? "");
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent to your contact.')),
        );
      } else {
        final msg = api.error ?? 'Failed to resend OTP';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
      return;
    }

    // Fallback if source unknown
    final ok = await api.requestLoginOtp(email: _email, mobile: _mobile);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent. Please check your inbox.')),
      );
    } else {
      final msg = api.error ?? 'Failed to resend OTP';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: Consumer<ApiController>(
        builder: (context, api, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 🌈 Gradient header area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 180),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.gradientTop, AppColors.gradientBottom],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 15,
                          right: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.white,
                              ),
                            ),
                            Image.asset(
                              'assets/sheild.png',
                              height: 24,
                              width: 24,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 280,
                        child: Image.asset(
                          'assets/Otp.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🧾 White bottom section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 24,
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
                        "Please enter the OTP and verify",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.black54,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // ✅ OTP input boxes
                      OtpInputFields(
                        onCompleted: (otp) {
                          setState(() => _otp = otp);
                        },
                      ),

                      const SizedBox(height: 30),

                      // ✅ Verify button
                      GradientButton(
                        buttonText: api.isLoading
                            ? 'Verifying...'
                            : 'Verify OTP',
                        onPressed: api.isLoading ? null : _verifyOtp,
                      ),

                      const SizedBox(height: 12),

                      // Resend option
                      TextButton(
                        onPressed: api.isLoading ? null : _resendOtp,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: AppColors.link,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
