import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // Import provider for state management
import '../../models/profiledetails.dart';
import '../../controllers/api_controller.dart'; // Use the API controller instead

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Profiledetails? _user;
  bool _isLoading = true;
  String? _error;

  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _religionController = TextEditingController();
  final _bioController = TextEditingController();
  String? _selectedReligionId;

  // Sample religion options - in a real app, you'd fetch these from an API
  final List<Map<String, String>> _religions = [
    {'id': '694f63d08389fc82a4345083', 'name': 'Hindu'},
    {'id': '694f63d08389fc82a4345084', 'name': 'Muslim'},
    {'id': '694f63d08389fc82a4345085', 'name': 'Christian'},
    {'id': '694f63d08389fc82a4345086', 'name': 'Sikh'},
    {'id': '694f63d08389fc82a4345087', 'name': 'Buddhist'},
    {'id': '694f63d08389fc82a4345088', 'name': 'Jewish'},
    {'id': '694f63d08389fc82a4345089', 'name': 'Other'},
  ];

  String _gender = 'Male'; // default to match sample payload
  String? _uploadedPhotoUrl;
  File? _selectedImage;
  bool _isEditing = false; // Track if we're in editing mode

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Use the ApiController via Provider to fetch profile
      final apiController = Provider.of<ApiController>(context, listen: false);
      final result = await apiController.fetchCurrentMaleProfile();

      if (result["success"] == true && result["data"] is Map) {
        final data = result["data"] as Map;

        // Create a compatible structure for Profiledetails.fromJson
        final userData = {
          "_id": data["_id"],
          "email": data["email"],
          "mobileNumber": data["mobileNumber"],
          "interests": data["interests"] ?? [],
          "languages": data["languages"] ?? [],
          "status": data["status"],
          "reviewStatus": data["reviewStatus"],
          "isVerified": data["isVerified"],
          "isActive": data["isActive"],
          "favourites": data["favourites"] ?? [],
          "kycStatus": data["kycStatus"],
          "followers": data["followers"] ?? [],
          "femalefollowing": data["femalefollowing"] ?? [],
          "malefollowing": data["malefollowing"] ?? [],
          "malefollowers": data["malefollowers"] ?? [],
          "earnings": data["earnings"] ?? [],
          "blockList": data["blockList"] ?? [],
          "beautyFilter": data["beautyFilter"],
          "hideAge": data["hideAge"],
          "onlineStatus": data["onlineStatus"],
          "walletBalance": data["walletBalance"],
          "coinBalance": data["coinBalance"],
          "balance": data["balance"],
          "referralCode": data["referralCode"],
          "referralBonusAwarded": data["referralBonusAwarded"],
          "profileCompleted": data["profileCompleted"],
          "referredBy": data["referredBy"] ?? [],
          "hobbies": data["hobbies"] ?? [],
          "sports": data["sports"] ?? [],
          "film": data["film"] ?? [],
          "music": data["music"] ?? [],
          "travel": data["travel"] ?? [],
          "searchPreferences": data["searchPreferences"],
          "createdAt": data["createdAt"],
          "updatedAt": data["updatedAt"],
          "__v": data["__v"],
          "age": data["age"],
          "bio": data["bio"],
          "gender": data["gender"],
          "firstName": data["firstName"],
          "lastName": data["lastName"],
          "name": "${data["firstName"] ?? ''} ${data["lastName"] ?? ''}".trim(),
          "videoUrl": data["videoUrl"],
          "images": data["images"] is List
              ? data["images"].map((img) {
                  // Handle both string URLs and object structures
                  if (img is String) {
                    return img;
                  } else if (img is Map) {
                    return img["imageUrl"];
                  }
                  return "";
                }).toList()
              : [],
          "height": data["height"],
          "religion": data["religion"],
        };

        setState(() {
          _user = Profiledetails.fromJson(userData);

          // Populate form fields with profile data
          _firstNameController.text = _user?.firstName ?? '';
          _lastNameController.text = _user?.lastName ?? '';
          _ageController.text = _user?.age?.toString() ?? '';
          _heightController.text = _user?.height ?? '';
          _bioController.text = _user?.bio ?? '';
          _gender = _user?.gender?.toString() ?? 'Male';

          // Set the selected religion ID based on the loaded data
          String? selectedReligionId = _user?.religion?.toString() ?? null;
          _selectedReligionId = selectedReligionId;

          // Handle images array from the new API response structure
          List<String> imageUrls = [];
          final images = _user?.images;
          if (images != null && images.isNotEmpty) {
            // The API returns objects with imageUrl property
            if (images.first is Map) {
              final firstImage = images.first as Map;
              if (firstImage.containsKey('imageUrl')) {
                imageUrls.add(firstImage['imageUrl'].toString());
              }
            } else {
              // If it's a simple array of strings
              imageUrls = images.cast<String>();
            }
          }
          if (imageUrls.isNotEmpty) {
            _uploadedPhotoUrl = imageUrls.first;
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load profile data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading profile: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final height = _heightController.text.trim();
    final religion = _selectedReligionId ?? _religionController.text.trim();
    final bio = _bioController.text.trim();

    // Validate required fields
    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ First name is required.')),
      );
      return;
    }
    if (lastName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Last name is required.')));
      return;
    }
    if (height.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Height is required.')));
      return;
    }
    if (religion.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Religion is required.')));
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final apiController = Provider.of<ApiController>(context, listen: false);
      final result = await apiController.updateProfileDetails(
        firstName: firstName,
        lastName: lastName,
        height: height,
        religion: religion,
        imageUrl: _uploadedPhotoUrl,
        bio: bio,
        gender: _gender,
      );

      if (result['success'] == true) {
        // Reload profile after successful update
        await _fetchUserProfile();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Profile updated successfully!')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to update profile: ${result['message']}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error updating profile: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiController>(
      builder: (context, apiController, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F5FF),
          appBar: AppBar(
            title: const Text(
              "My Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
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
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (value) async {
                  if (value == 0) {
                    // Edit Profile
                    setState(() {
                      _isEditing = true;
                    });
                  } else if (value == 3) {
                    // Save Profile
                    await _saveProfile();
                    setState(() {
                      _isEditing = false;
                    });
                  } else if (value == 1) {
                    // Settings
                    // Navigate to settings
                  } else if (value == 2) {
                    // Logout
                    // Handle logout
                  }
                },
                itemBuilder: (context) => [
                  _isEditing
                      ? const PopupMenuItem(
                          value: 3,
                          child: Text("Save Profile"),
                        )
                      : const PopupMenuItem(
                          value: 0,
                          child: Text("Edit Profile"),
                        ),
                  const PopupMenuItem(value: 1, child: Text("Settings")),
                  const PopupMenuItem(value: 2, child: Text("Logout")),
                ],
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : _user == null
              ? const Center(child: Text('No profile data available'))
              : _buildProfileContent(),
        );
      },
    );
  }

  Widget _buildProfileContent() {
    // Double check that _user is not null (should not be needed due to check in body, but added for safety)
    if (_user == null) {
      return const Center(child: Text('No profile data available'));
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header - Always show with edit capability
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            (_uploadedPhotoUrl != null &&
                                _uploadedPhotoUrl!.isNotEmpty)
                            ? NetworkImage(_uploadedPhotoUrl!)
                            : (_user?.images.isNotEmpty ?? false) &&
                                  ((_user?.images.first.toString() ?? '')
                                      .isNotEmpty)
                            ? NetworkImage(_user!.images.first.toString())
                            : null,
                        child:
                            (_uploadedPhotoUrl == null ||
                                        _uploadedPhotoUrl!.isEmpty) &&
                                    !(_user?.images.isNotEmpty ?? false) ||
                                ((_user?.images.first.toString() ?? '').isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!_isEditing) ...[
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFFFF55A5),
                                          Color(0xFF9A00F0),
                                        ],
                                      ).createShader(bounds),
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    '${_user?.name ?? "No Name"}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9E6F5),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _firstNameController,
                                          decoration: const InputDecoration(
                                            hintText: 'First Name',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9E6F5),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _lastNameController,
                                          decoration: const InputDecoration(
                                            hintText: 'Last Name',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (!_isEditing) ...[
                                    const Text(
                                      "Age: ",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${_user?.age ?? 'N/A'} years",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Height: ",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${_user?.height ?? 'N/A'} cm",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ] else ...[
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9E6F5),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _ageController,
                                          keyboardType: TextInputType.number,
                                          readOnly:
                                              true, // Age calculated from DOB
                                          decoration: const InputDecoration(
                                            hintText: 'Age',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9E6F5),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _heightController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Height (cm)',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Balance: ",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "${_user?.walletBalance ?? 0}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _buildInfoChip(
                                    Icons.verified,
                                    "Verified",
                                    _user?.isVerified == true,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildInfoChip(
                                    Icons.check_circle,
                                    "Active",
                                    _user?.isActive == true,
                                  ),
                                ],
                              ),
                              if (_isEditing) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9E6F5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value:
                                          _selectedReligionId != null &&
                                              _religions.any(
                                                (r) =>
                                                    r['id'] ==
                                                    _selectedReligionId,
                                              )
                                          ? _selectedReligionId
                                          : null,
                                      isExpanded: true,
                                      hint: const Text('Select a religion'),
                                      items: _religions.map((religion) {
                                        return DropdownMenuItem(
                                          value: religion['id'],
                                          child: Text(religion['name']!),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedReligionId = newValue;
                                          // Clear the text controller when selecting from dropdown
                                          _religionController.text =
                                              newValue ?? '';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Gender', style: _labelStyle()),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _genderOption('Male', Icons.male),
                                    const SizedBox(width: 15),
                                    _genderOption('Female', Icons.female),
                                  ],
                                ),
                              ] else if (_user?.religion != null) ...[
                                const SizedBox(height: 10),
                                _buildInfoChip(
                                  Icons.church,
                                  _findReligionNameById(
                                        _user?.religion.toString(),
                                      ) ??
                                      'Religion',
                                  true,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final pickedFile = await _pickImage();
                              if (pickedFile != null) {
                                setState(() {
                                  _selectedImage = pickedFile;
                                  _uploadedPhotoUrl = pickedFile.path;
                                });
                              }
                            },
                            child: const Text('Upload Photo'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (_uploadedPhotoUrl != null) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                  _uploadedPhotoUrl = null;
                                });
                              },
                              child: const Text('Remove'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sections for profile details
            if (_isEditing) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9E6F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Tell us about yourself...',
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              _buildSection("Bio", _user?.bio ?? "No bio available"),
            ],

            _buildSectionWithChips(
              "Interests",
              (_user?.interests.cast<String>() ?? []).cast<String>(),
            ),

            _buildSectionWithChips(
              "Languages",
              (_user?.languages.cast<String>() ?? []).cast<String>(),
            ),

            _buildSectionWithChips(
              "Hobbies",
              (_user?.hobbies.cast<String>() ?? []).cast<String>(),
            ),

            _buildSectionWithChips(
              "Sports",
              (_user?.sports.cast<String>() ?? []).cast<String>(),
            ),

            _buildSectionWithChips(
              "Film",
              (_user?.film.cast<String>() ?? []).cast<String>(),
            ),

            _buildSectionWithChips(
              "Music",
              (_user?.music.cast<String>() ?? []).cast<String>(),
            ),

            _buildSectionWithChips(
              "Travel",
              (_user?.travel.cast<String>() ?? []).cast<String>(),
            ),

            const SizedBox(height: 24),

            // Contact Info
            _buildContactSection(),

            const SizedBox(height: 24),

            // Stats
            _buildStatsSection(),

            const SizedBox(height: 24),

            // Say Hi and Call buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.pinkAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.pinkAccent,
                    ),
                    label: const Text(
                      'Say Hi',
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.phone, color: Colors.white),
                    label: const Text(
                      'Call',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isActive ? Colors.green : Colors.grey),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(content, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithChips(String title, List<String> items) {
    if (items.isEmpty || items.every((item) => item.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .where((item) => item.isNotEmpty)
                .map(
                  (e) => Chip(
                    label: Text(e),
                    backgroundColor: Colors.pinkAccent.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contact Info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactRow(Icons.email, "Email", (_user?.email) ?? "N/A"),
                const Divider(height: 20),
                _buildContactRow(
                  Icons.phone,
                  "Phone",
                  (_user?.mobileNumber) ?? "N/A",
                ),
                const Divider(height: 20),
                _buildContactRow(
                  Icons.cake,
                  "Age",
                  "${(_user?.age) ?? 'N/A'} years",
                ),
                const Divider(height: 20),
                _buildContactRow(
                  Icons.account_balance_wallet,
                  "Wallet Balance",
                  "\$${(_user?.walletBalance) ?? 0}",
                ),
                const Divider(height: 20),
                _buildContactRow(
                  Icons.monetization_on,
                  "Coin Balance",
                  "${(_user?.coinBalance) ?? 0} coins",
                ),
                const Divider(height: 20),
                _buildContactRow(
                  Icons.account_balance,
                  "Balance",
                  "${(_user?.balance) ?? 0}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.pinkAccent),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistics",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  "Followers",
                  "${(_user?.malefollowers.length) ?? 0}",
                ),
                _buildStatCard(
                  "Following",
                  "${(_user?.malefollowing.length) ?? 0}",
                ),
                _buildStatCard(
                  "Favorites",
                  "${(_user?.favourites.length) ?? 0}",
                ),
                _buildStatCard("Referrals", (_user?.referralCode) ?? "N/A"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String? _findReligionNameById(String? id) {
    if (id == null) return null;
    final found = _religions.firstWhere(
      (religion) => religion['id'] == id,
      orElse: () => {'id': '', 'name': ''},
    );
    return found['name'];
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.black,
    );
  }

  Widget _genderOption(String value, IconData icon) {
    final isSelected = _gender == value;
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
      shape: const StadiumBorder(),
      onSelected: (_) {
        setState(() => _gender = value);
      },
    );
  }
}
