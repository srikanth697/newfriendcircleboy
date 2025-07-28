import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileGalleryScreen extends StatefulWidget {
  @override
  State<ProfileGalleryScreen> createState() => _ProfileGalleryScreenState();
}

class _ProfileGalleryScreenState extends State<ProfileGalleryScreen> {
  bool isOnline = true;
  int selectedTab = 0;
  final List<File> _uploadedImages = [];

  void _handleImageUpload() async {
    if (_uploadedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can upload up to 3 images.")),
      );
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _uploadedImages.add(File(picked.path));
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _uploadedImages.removeAt(index);
    });
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabButton("Profile", 0),
          const SizedBox(width: 12),
          _tabButton("My Gallery", 1),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final bool isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 1.5,
            color: isSelected ? Colors.transparent : Colors.purple,
          ),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.purple,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              Text(
                isOnline ? "Online" : "Offline",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isOnline,
                onChanged: (val) => setState(() => isOnline = val),
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey.shade400,
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child: selectedTab == 0
                ? const ProfileTabEditable()
                : GalleryTab(
                    images: _uploadedImages,
                    onUpload: _handleImageUpload,
                    onDelete: _deleteImage,
                  ),
          ),
        ],
      ),
    );
  }
}

class ProfileTabEditable extends StatefulWidget {
  const ProfileTabEditable({super.key});

  @override
  State<ProfileTabEditable> createState() => _ProfileTabEditableState();
}

class _ProfileTabEditableState extends State<ProfileTabEditable> {
  Map<String, List<String>> profileDetails = {
    "My Languages": ["Telugu"],
    "My Interests": ["Family and parenting", "Society and politics"],
    "Hobbies": ["Cooking", "Writing"],
    "Sports": ["Cricket"],
    "Film": ["NO FILMS"],
    "Music": ["2020s"],
    "Travel": ["Mountains"],
  };

  void _editCategory(String key) async {
    TextEditingController controller = TextEditingController();
    List<String>? currentItems = List.from(profileDetails[key]!);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit $key"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < currentItems.length; i++)
              TextFormField(
                initialValue: currentItems[i],
                onChanged: (value) => currentItems[i] = value,
              ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Add more"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                currentItems.add(controller.text);
              }
              setState(() => profileDetails[key] = currentItems);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  ShaderMask _gradientText(String text) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
        ).createShader(bounds);
      },
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Consistent width for alignment
            child: Row(
              children: [
                Text(label, style: const TextStyle(color: Colors.black)),
                const Text(" : "),
              ],
            ),
          ),
          Expanded(child: _gradientText(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Elevated card with profile basics
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("Nick Name", "Jennie"),
                  _buildRow("Gender", "Female"),
                  _buildRow("Date of Birth", "19th July 2025"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Other categories: no elevation
          ...profileDetails.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header + Edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _editCategory(entry.key),
                        child: Row(
                          children: const [
                            Icon(Icons.edit, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: entry.value.map((item) {
                      return Chip(
                        label: Text(item),
                        backgroundColor: Colors.pink[50],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class GalleryTab extends StatelessWidget {
  final List<File> images;
  final VoidCallback onUpload;
  final void Function(int) onDelete;

  const GalleryTab({
    required this.images,
    required this.onUpload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...images.asMap().entries.map((entry) {
            int index = entry.key;
            File img = entry.value;
            return Stack(
              children: [
                Container(
                  width: 120,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(img),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    color: Colors.black45,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () => onDelete(index),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          if (images.length < 3)
            GestureDetector(
              onTap: onUpload,
              child: Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        "Upload photo",
                        style: TextStyle(color: Colors.grey),
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
