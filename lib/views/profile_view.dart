import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'home_view_model.dart';
import 'profile_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    
    // One-time init of controller
    if (_nameController.text.isEmpty && userProfile != null) {
      _nameController.text = userProfile.name;
    }

    final viewModel = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar Section
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => _showImagePickerSheet(context, viewModel),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF334155), width: 3),
                      image: userProfile?.profileImagePath != null
                          ? DecorationImage(
                              image: FileImage(File(userProfile!.profileImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: userProfile?.profileImagePath == null
                        ? const Icon(Icons.person, size: 48, color: Colors.grey)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _showImagePickerSheet(context, viewModel),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFBEF264),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Personal Info'),
          _buildTextField('Name', _nameController),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Preferences'),
          _buildOptionTile('Units', 'Metric (kg)', Icons.scale),
          _buildOptionTile('Theme', 'Dark Mode', Icons.dark_mode),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Data'),
          _buildActionTile('Export Data', Icons.download),
          InkWell(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E293B),
                  title: const Text('Clear All Data?', style: TextStyle(color: Colors.white)),
                  content: const Text('This will reset the app to its initial state. This cannot be undone.', style: TextStyle(color: Color(0xFF94A3B8))),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true), 
                      child: const Text('Clear', style: TextStyle(color: Colors.red))
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                await viewModel.clearAllData();
                // Auth listen will handle redirect
              }
            },
            child: _buildActionTile('Clear All Data', Icons.delete_forever, isDestructive: true),
          ),

          const SizedBox(height: 48),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                 await viewModel.updateName(_nameController.text);
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated')));
                   context.pop();
                 }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBEF264),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Save Changes'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF94A3B8), size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF475569)),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.red : const Color(0xFF94A3B8), size: 20),
          const SizedBox(width: 12),
          Text(
            title, 
            style: TextStyle(
              color: isDestructive ? Colors.red : Colors.white, 
              fontWeight: FontWeight.w600
            )
          ),
        ],
      ),
    );
  }
  void _showImagePickerSheet(BuildContext context, ProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Gallery', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('Camera', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
