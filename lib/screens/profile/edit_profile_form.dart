import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _gameIdController;
  String? _selectedGameType;
  bool _isLoading = false;

  // TODO: This should ideally come from a remote config
  final List<String> _gameTypes = ['BGMI', 'Free Fire', 'COD'];

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserModel?>(context, listen: false);
    _nameController = TextEditingController(text: user?.name ?? '');
    _gameIdController = TextEditingController(text: user?.gameId ?? '');
    _selectedGameType = user?.gameType;
  }

  void _updateProfile() async {
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null || !(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      await _firestoreService.updateUserProfile(
        user.uid,
        name: _nameController.text,
        gameType: _selectedGameType,
        gameId: _gameIdController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit Profile', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGameType,
              decoration: const InputDecoration(labelText: 'Game'),
              items: _gameTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedGameType = newValue;
                });
              },
              validator: (value) => value == null ? 'Please select a game' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _gameIdController,
              decoration: const InputDecoration(labelText: 'Game ID'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your Game ID' : null,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: CustomButton(
                  text: 'Update Profile',
                  onPressed: _updateProfile,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
