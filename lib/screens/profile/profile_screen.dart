import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/screens/profile/edit_profile_form.dart';
import 'package:ybt_match/screens/profile/user_achievements.dart';
import 'package:ybt_match/services/auth_service.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/services/storage_service.dart';
import 'package:ybt_match/widgets/widgets.dart';
import 'package:ybt_match/screens/wallet/wallet_screen.dart';
import 'package:ybt_match/screens/profile/customer_support_form.dart';
import 'package:ybt_match/screens/settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = locator<AuthService>();
  final StorageService _storageService = locator<StorageService>();
  File? _image;

  Future<void> _pickImage() async {
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null) return;

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Immediately upload the image
      try {
        final photoUrl = await _storageService.uploadProfilePhoto(user.uid, _image!);
        await locator<FirestoreService>().updateUserProfile(user.uid, photoUrl: photoUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload photo: ${e.toString()}')),
        );
      }
    }
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const EditProfileForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await _authService.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : (user.photoUrl != null ? NetworkImage(user.photoUrl!) : null) as ImageProvider?,
                child: _image == null && user.photoUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
            Text(user.email, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (user.gameType != null && user.gameId != null)
              Text('${user.gameType}: ${user.gameId}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            UserAchievements(
              matchesJoined: user.matchesJoined,
              matchesWon: user.matchesWon,
              matchesLost: user.matchesLost,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Edit Profile',
              onPressed: () => _showEditProfileSheet(context),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('My Wallet'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WalletScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Contact Support'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: CustomerSupportForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
