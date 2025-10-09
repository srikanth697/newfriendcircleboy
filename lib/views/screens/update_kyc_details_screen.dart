import 'package:flutter/material.dart';
import '../../widgets/gradient_button.dart';
import 'withdraw_request_screen.dart';

class UpdateKycScreen extends StatelessWidget {
  const UpdateKycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> withdraws = [
      {
        'amount': 'Rs 2000',
        'time': '9:55 PM , 25 May',
        'status': 'Successful',
        'invoice': 'Invoice',
        'icon': 'assets/wallet.png',
      },
      {
        'amount': 'Rs 1500',
        'time': '4:30 PM , 18 May',
        'status': 'Successful',
        'invoice': 'Invoice',
        'icon': 'assets/wallet.png',
      },
      {
        'amount': 'Rs 1000',
        'time': '12:00 PM , 10 May',
        'status': 'Successful',
        'invoice': 'Invoice',
        'icon': 'assets/wallet.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leading: const BackButton(color: Colors.white),
          title: const Text(
            "My Withdraws",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {
                // Update KYC tap handler (navigate if needed)
              },
              child: const Text(
                "Update KYC",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF00CC), Color.fromARGB(255, 146, 51, 153)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 120,
                child: GradientButton(
                  text: "Withdraw",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WithdrawRequestScreen(),
                      ),
                    );
                  },
                  buttonText: '',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: withdraws.length,
                itemBuilder: (context, index) {
                  final item = withdraws[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFE0F6),
                          ),
                          child: Image.asset(
                            item['icon'],
                            height: 28,
                            width: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item['amount'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['invoice'],
                                    style: const TextStyle(
                                      color: Colors.purple,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['time'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item['status'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
