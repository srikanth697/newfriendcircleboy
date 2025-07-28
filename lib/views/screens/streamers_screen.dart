import 'package:flutter/material.dart';
import 'package:girl_flow/views/screens/Invite_friends_screen.dart'; // Optional: You can remove if using only named routes
import 'package:girl_flow/core/routes/app_routes.dart';

class MyStreamersScreen extends StatefulWidget {
  const MyStreamersScreen({super.key});

  @override
  State<MyStreamersScreen> createState() => _MyStreamersScreenState();
}

class _MyStreamersScreenState extends State<MyStreamersScreen> {
  bool isOnline = true;

  final List<Map<String, dynamic>> streamers = const [
    {
      'name': 'Alex Linderson',
      'id': '3232789',
      'status': 'APPROVED',
      'image': 'assets/user1.png',
    },
    {
      'name': 'Team Align',
      'id': '9876521',
      'status': 'APPROVED',
      'image': 'assets/user2.png',
    },
    {
      'name': 'Sabila Sayma',
      'id': '9876531',
      'status': 'REJECTED',
      'image': 'assets/user1.png',
    },
    {
      'name': 'John Borino',
      'id': '8976213',
      'status': 'APPROVED',
      'image': 'assets/user2.png',
    },
    {
      'name': 'Alex Linderson',
      'id': '3232789',
      'status': 'REJECTED',
      'image': 'assets/user1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Streamers",
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
                onChanged: (val) => setState(() => isOnline = val),
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey.shade400,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: streamers.length,
              itemBuilder: (context, index) {
                final streamer = streamers[index];
                final isApproved = streamer['status'] == 'APPROVED';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(streamer['image']),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isOnline ? Colors.green : Colors.grey,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              streamer['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${streamer['id']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        streamer['status'],
                        style: TextStyle(
                          color: isApproved ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.invitefriends);
              },
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Invite Friends (My Ref Code : RKUQT)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
