import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:girl_flow/utils/colors.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOnline = false;
  File? profileImage;

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  void _showRewardsSheet(String type) {
    final List<Map<String, String>> rewards = type == "Daily"
        ? [
            {"earning": "75k", "reward": "2.25k"},
            {"earning": "1L", "reward": "3k"},
            {"earning": "1.5L", "reward": "3.5k"},
            {"earning": "2L", "reward": "6k"},
            {"earning": "2.5L", "reward": "8.5k"},
            {"earning": "3L", "reward": "12k"},
            {"earning": "3.5L", "reward": "15k"},
            {"earning": "5L", "reward": "20k"},
          ]
        : [
            {"earning": "1st", "reward": "5L"},
            {"earning": "2nd", "reward": "2.5L"},
            {"earning": "3rd", "reward": "1.25L"},
            {"earning": "4th", "reward": "75k"},
            {"earning": "5th", "reward": "50k"},
            {"earning": "6th", "reward": "35k"},
            {"earning": "7th", "reward": "25k"},
            {"earning": "8th", "reward": "20k"},
          ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF55A5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/coins.png', width: 18, height: 18),
                      const SizedBox(width: 4),
                      const Text(
                        "0",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Earning",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rewards",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rewards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = rewards[index];
                  return Row(
                    children: [
                      Expanded(child: Text(item['earning']!)),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/coins.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(item['reward']!),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientText(String text) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color(0xFFFF55A5), Color(0xFF9A00F0)],
            ).createShader(bounds);
          },
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 2,
            width: text.length * 8.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF55A5), Color(0xFF9A00F0)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton(String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF55A5), Color(0xFF9A00F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF55A5), Color(0xFF9A00F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  const Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 22,
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
                    inactiveTrackColor: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _pickProfileImage,
                          child: _buildGradientText("Add Photo"),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : null,
                    backgroundColor: profileImage == null
                        ? Colors.grey
                        : Colors.transparent,
                    child: profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const Text(
                    "Harika",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.outlinePink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Next week : Starting 30 Jun",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Image.asset('assets/coins.png', width: 16, height: 16),
                        const SizedBox(width: 4),
                        const Text(
                          "250/Min",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFFF55A5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text(
                      "• This may change as per your earning performance during this week",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // First Card with better spacing
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          _StatRow("Total Online Time", "0 Min", bold: true),
                          SizedBox(height: 10),
                          _StatRow("Missed Calls", "0"),
                          SizedBox(height: 10),
                          _StatRow("Week Earning", "0", icon: true),
                          SizedBox(height: 10),
                          _StatRow("Today Earning", "0", icon: true),
                          SizedBox(height: 10),
                          _StatRow("Call Earning", "0", icon: true),
                          SizedBox(height: 10),
                          _StatRow("Gift Earning", "0", icon: true),
                          SizedBox(height: 10),
                          _StatRow("Others", "0", icon: true),
                        ],
                      ),
                    ),
                  ),

                  // Second Card with bold title
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Rewards",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildGradientButton(
                                "Daily",
                                () => _showRewardsSheet("Daily"),
                              ),
                              const SizedBox(width: 16),
                              _buildGradientButton(
                                "Weekly",
                                () => _showRewardsSheet("Weekly"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.helpVideos,
                          ),
                          child: _buildGradientText("Help Videos"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String title;
  final String value;
  final bool icon;
  final bool bold;

  const _StatRow(
    this.title,
    this.value, {
    this.icon = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      color: const Color(0xFFFF55A5),
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        icon
            ? Row(
                children: [
                  Image.asset('assets/coins.png', width: 16, height: 16),
                  const SizedBox(width: 4),
                  Text(value, style: valueStyle),
                ],
              )
            : Text(value, style: valueStyle),
      ],
    );
  }
}
