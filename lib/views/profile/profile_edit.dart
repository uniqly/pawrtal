import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';

import 'profile_editable_box.dart';

enum ImageType { banner, pfp }

class ProfileEditView extends ConsumerStatefulWidget {
  const ProfileEditView({super.key});

  @override
  ConsumerState<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
  late final UserModel _profile;
  late final Future<void> Function(File? pfp, File? banner, String displayName,
    String userName, String bio, String location) _saveEdits;
  bool _updatedBanner = false;
  bool _updatedProfile = false;
  bool _notSubmitted = true;
  File? _newBanner;
  File? _newPfp;
  late final TextEditingController _displayNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;


  @override
  void initState() {
    super.initState();
    _profile = ref.read(appUserProvider).value!;
    _saveEdits = ref.read(profileViewModelNotifierProvider(uid: _profile.uid)).value!.updateProfile;
    log(_profile.toString());
    _displayNameController = TextEditingController(text: _profile.displayName);
    _usernameController = TextEditingController(text: _profile.username);
    _bioController = TextEditingController(text: _profile.bio);
    _locationController = TextEditingController(text: _profile.location);
  }

  @override
  void dispose() {
    super.dispose();
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
  }

  void _updateField(String s) { 
    setState(() {
      log('new value: $s');
    });
  }

  void _pickImage(ImageType type) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          if (type == ImageType.banner) {
            _updatedBanner = true;
            _newBanner = File(image.path);
          } else {
            _updatedProfile = true;
            _newPfp = File(image.path);
          }
        });
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  // TODO: check for unique username before allowing
  bool get _hasChanges {
    // only allow to save if fields have been changed
    // username not changed to empty
    final textcheck =
      _usernameController.text.isNotEmpty && (
      _displayNameController.text != _profile.displayName || 
      _usernameController.text != _profile.username || 
      _bioController.text != _profile.bio || 
      _locationController.text != _profile.location);
    return textcheck || _updatedBanner || _updatedProfile;
  }

  @override
  build(BuildContext context) {

    return Scaffold( 
      appBar: AppBar( 
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text( 
          'Edit Pawfile',
          style: TextStyle( 
            fontWeight: FontWeight.bold,
          )
        ),
        actions: [ 
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton( 
              style: TextButton.styleFrom( 
                backgroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                disabledForegroundColor: Theme.of(context).colorScheme.surfaceDim,
              ),
              onPressed: _hasChanges && _notSubmitted ? () async { 
                setState(() { // lock form when button is pressed
                  _notSubmitted = false;
                });
                await _saveEdits(_newPfp, _newBanner, _displayNameController.text, 
                  _usernameController.text, _bioController.text, _locationController.text).whenComplete(() {
                    const success = SnackBar( 
                      content: Text('Saved Profile!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(success);
                    Navigator.of(context).pop();
                    //await ref.read(mainUserProvider.notifier).refresh();
                  }).onError((s, e) { 
                    final error = SnackBar( 
                      content: Text('Error with upload, $e'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(error);
                    setState(() { // unlock form if unsuccessful
                      _notSubmitted = true;
                    });
                  });
              } : null,
              child: const Text('Save'), 
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column( 
          children: [ 
            Stack( 
              alignment: Alignment.bottomCenter,
              children: [ 
                Padding( 
                  padding: const EdgeInsets.only(bottom: 75.0) ,
                  child: Stack(  
                    alignment: Alignment.bottomRight,
                    children: [ 
                      Container( 
                        height: 150,
                        decoration: BoxDecoration( 
                          image: DecorationImage( 
                            fit: BoxFit.cover,
                            image: !_updatedBanner ? NetworkImage(_profile.banner!) : FileImage(_newBanner!) as ImageProvider<Object>,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () { 
                          _pickImage(ImageType.banner);
                        },
                        icon: const Icon(Icons.panorama_rounded),
                      ), 
                    ]
                  ),
                ), 
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar( 
                      radius: 77,
                      backgroundColor: Colors.white,
                      child: CircleAvatar( 
                        radius: 75,
                        backgroundImage: !_updatedProfile ? NetworkImage(_profile.pfp!) : FileImage(_newPfp!) as ImageProvider<Object>,
                      ),
                    ),
                    IconButton.filled(  
                      onPressed: () { 
                        _pickImage(ImageType.pfp);
                      },
                      icon: const Icon(Icons.portrait_rounded),
                    )
                  ],
                )
              ],
            ),
            ProfileEditableBox(
              fieldName: 'Display Name:',
              onChanged: _updateField,
              icon: Icons.create_rounded,
              controller: _displayNameController,
            ), 
            ProfileEditableBox( 
              fieldName: 'Username:',
              onChanged: _updateField,
              icon: Icons.person_rounded,
              prefix: const Text('@'),
              controller: _usernameController,
            ),
            ProfileEditableBox( 
              fieldName: 'Biography:',
              onChanged: _updateField,
              icon: Icons.auto_stories_rounded,
              controller: _bioController,
            ),
            ProfileEditableBox( 
              fieldName: 'Location:',
              onChanged: _updateField,
              icon: Icons.location_on_rounded,
              controller: _locationController,
            ),
            const SizedBox(height: 20.0,),
          ],
        ),
      )
    );
  }
}
