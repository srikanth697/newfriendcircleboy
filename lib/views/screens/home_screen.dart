import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼 Background splash image
          SizedBox.expand(
            child: Image.asset('assets/splashimage.png', fit: BoxFit.cover),
          ),

          // 🎯 Text & Button overlay
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Find, Connect, Date",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Join a space where real people make real and\ntrusted connections. Try dating, keep loving.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 32),

                // 🚀 Get Started Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.onboarding);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Get started",
                            style: TextStyle(
                              color: AppColors.buttonText,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.gradientTop,
                                AppColors.gradientBottom,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: AppColors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
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
