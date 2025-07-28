import 'package:flutter/material.dart';
import 'kyc_details_screen.dart';
import '../../widgets/gradient_button.dart';

class MyWithdrawsScreen extends StatelessWidget {
  const MyWithdrawsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isOnline = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Withdraws",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              const Text("Online", style: TextStyle(color: Colors.white)),
              Switch(
                value: isOnline,
                onChanged: (_) {},
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey.shade400,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
          ), // Adjust this value to move the card up/down
          Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Please submit your KYC data to enable withdraws",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KYCDetailsScreen(),
                          ),
                        );
                      },
                      text: "Submit KYC",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
