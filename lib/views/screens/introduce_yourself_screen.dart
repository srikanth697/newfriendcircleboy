import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/gradient_button.dart';
import '../../views/screens/registration_status.dart'; // ✅ Updated import

class IntroduceYourselfScreen extends StatefulWidget {
  const IntroduceYourselfScreen({super.key});

  @override
  State<IntroduceYourselfScreen> createState() =>
      _IntroduceYourselfScreenState();
}

class _IntroduceYourselfScreenState extends State<IntroduceYourselfScreen> {
  File? _photo; // ✅ single image
  File? _videoFile;
  VideoPlayerController? _videoController;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();

  String gender = "Male";
  List<String> selectedInterests = [];

  final List<String> allInterests = [
    "Listening Music",
    "Watching Movies",
    "Cooking",
    "Reading",
    "Gaming",
    "Traveling",
  ];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
    }
  }

  Future<void> _recordVideo() async {
    final pickedVideo = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 10),
    );
    if (pickedVideo != null) {
      _videoFile = File(pickedVideo.path);
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    }
  }

  void _navigateToStatus() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationStatusScreen()),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              "Introduce yourself",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Please describe yourself",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ✅ Single photo slot (tap to add/replace)
            GestureDetector(
              onTap: _pickImage,
              child: _photo == null
                  ? const DottedBorderBox(label: "Upload photo")
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _photo!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // Video
            GestureDetector(
              onTap: _recordVideo,
              child: DottedBorderBox(
                label: "Upload Video",
                child:
                    _videoController != null &&
                        _videoController!.value.isInitialized
                    ? ClipOval(
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                      )
                    : const Icon(
                        Icons.videocam,
                        color: Color(0xFFE91EC7),
                        size: 40,
                      ),
                isCircle: true,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Record your 10 sec live video",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Name", style: _labelStyle()),
            ),
            const SizedBox(height: 6),
            _buildRoundedTextField(_nameController, "", hintInside: true),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Age", style: _labelStyle()),
            ),
            const SizedBox(height: 6),
            _buildRoundedTextField(
              _ageController,
              "",
              keyboardType: TextInputType.number,
              hintInside: true,
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Gender", style: _labelStyle()),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _genderOption("Male", Icons.person),
                const SizedBox(width: 15),
                _genderOption("Female", Icons.person_outline),
              ],
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Add Bio", style: _labelStyle()),
            ),
            const SizedBox(height: 6),
            _buildRoundedTextField(
              _bioController,
              "",
              maxLines: 4,
              hintInside: true,
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Interests", style: _labelStyle()),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: allInterests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFE91EC7),
                  backgroundColor: const Color(0xFFF5F5F5),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GradientButton(
                text: "Approve",
                onPressed: _navigateToStatus,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool hintInside = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9E6F5),
        hintText: hintInside ? hint : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _genderOption(String value, IconData icon) {
    bool isSelected = gender == value;
    return ChoiceChip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFFE91EC7),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      selected: isSelected,
      selectedColor: const Color(0xFFE91EC7),
      backgroundColor: const Color(0xFFF5F5F5),
      shape: StadiumBorder(
        side: BorderSide(
          color: const Color(0xFFE91EC7),
          width: isSelected ? 0 : 1,
        ),
      ),
      onSelected: (_) {
        setState(() {
          gender = value;
        });
      },
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.black,
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  final String label;
  final Widget? child;
  final bool isCircle;

  const DottedBorderBox({
    super.key,
    required this.label,
    this.child,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCircle ? 120 : 120, // slightly larger for single slot
      height: isCircle ? 120 : 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE91EC7),
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: isCircle ? null : BorderRadius.circular(10),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        color: Colors.transparent,
      ),
      child: Center(
        child:
            child ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo, color: Color(0xFFE91EC7)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFE91EC7),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
      ),
    );
  }
}
