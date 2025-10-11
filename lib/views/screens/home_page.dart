import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Boy_flow/utils/colors.dart';
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

  // NOTE: Rewards-related code removed.

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

                  // First Card with stats
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
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

                  // Rewards card REMOVED
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
