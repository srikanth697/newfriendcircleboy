import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isOnline = false;
  String selectedTab = 'Important';

  final List<Map<String, dynamic>> _chatList = const [
    {
      "name": "Alex Linderson",
      "message": "How are you today?",
      "time": "2 min ago",
      "img": "https://i.pravatar.cc/150?img=1",
      "online": false,
      "unread": 0,
    },
    {
      "name": "Team Align",
      "message": "Don't miss to attend the meeting.",
      "time": "2 min ago",
      "img": "https://i.pravatar.cc/150?img=2",
      "online": true,
      "unread": 3,
    },
    {
      "name": "Sabila Sayma",
      "message": "How are you today?",
      "time": "2 min ago",
      "img": "https://i.pravatar.cc/150?img=3",
      "online": false,
      "unread": 1,
    },
    {
      "name": "John Borino",
      "message": "Have a good day 🌸",
      "time": "2 Hrs ago",
      "img": "https://i.pravatar.cc/150?img=4",
      "online": true,
      "unread": 0,
    },
    {
      "name": "Sabila Sayma",
      "message": "How are you today?",
      "time": "9th May",
      "img": "https://i.pravatar.cc/150?img=3",
      "online": false,
      "unread": 0,
    },
    {
      "name": "John Borino",
      "message": "Have a good day 🌸",
      "time": "7th May",
      "img": "https://i.pravatar.cc/150?img=4",
      "online": true,
      "unread": 0,
    },
  ];

  Widget _buildTabButton(String label) {
    final bool isSelected = selectedTab == label;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF55A5), Color(0xFF9A00F0)],
                )
              : null,
          border: isSelected
              ? null
              : Border.all(width: 2, color: const Color(0xFF9A00F0)),
        ),
        child: isSelected
            ? Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              )
            : ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFFFF55A5), Color(0xFF9A00F0)],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Chats",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Text("Online", style: TextStyle(color: Colors.white)),
                  Switch(
                    value: isOnline,
                    onChanged: (val) => setState(() => isOnline = val),
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.white54,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("Important"),
                const SizedBox(width: 10),
                _buildTabButton("Favourite"),
                const SizedBox(width: 10),
                _buildTabButton("Top fans"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=\${index + 6}",
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          Expanded(
            child: ListView.builder(
              itemCount: _chatList.length,
              itemBuilder: (context, index) {
                final chat = _chatList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  leading: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: chat['online']
                                ? Colors.transparent
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(chat['img']),
                          radius: 26,
                        ),
                      ),
                      if (chat['online'])
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(color: Colors.white, width: 2),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    chat['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(chat['message']),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      if (chat['unread'] > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(
                          name: chat['name'],
                          img: chat['img'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}
