import 'package:flutter/material.dart';

class MyCallRateScreen extends StatefulWidget {
  const MyCallRateScreen({super.key});

  @override
  State<MyCallRateScreen> createState() => _MyCallRateScreenState();
}

class _MyCallRateScreenState extends State<MyCallRateScreen> {
  bool isOnline = true;

  final List<Map<String, dynamic>> levels = List.generate(5, (_) {
    return {'level': '01', 'earning': '2500', 'rate': '200/min'};
  });

  final Gradient appGradient = const LinearGradient(
    colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Call Rate",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Center(
              child: Text("Online", style: TextStyle(color: Colors.white)),
            ),
          ),
          Switch(
            value: isOnline,
            onChanged: (val) => setState(() => isOnline = val),
            activeColor: Colors.green,
            inactiveTrackColor: Colors.grey.shade400,
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appGradient),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Call Rate Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: appGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Video Call Rate",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/coins.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "200/min",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Handle call rate change
                        },
                        child: const Text("Change call rate"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "My Level : 01",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Levels List
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: levels.map((level) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.lock, size: 18, color: Colors.grey),
                        _gradientBadge(level['level']),
                        Row(
                          children: [
                            Image.asset(
                              'assets/coins.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(level['earning']),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/coins.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(level['rate']),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientBadge(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: appGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '01',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
