import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/services/auth.dart';  // Import AuthService

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();

  String _eventName = '';
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _eventLocation = '';
  String _eventDescription = '';
  File? _eventImage;
  String eventId = '';
  String creatorId = '';

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _eventImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_eventImage == null) return null;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('event_images/$fileName');
    await storageRef.putFile(_eventImage!);
    return await storageRef.getDownloadURL();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        _startTimeController.text = picked.format(context);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
        _endTimeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 241, 232, 245),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _eventImage == null
                  ? Image.asset(
                      'assets/app/default_image.png',
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      _eventImage!,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 10.0),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.pink[100]),
                onPressed: _pickImage,
                child: const Text('Pick Event Image'),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventName = value!;
                },
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a start date';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () => _selectStartDate(context),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a start time';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () => _selectStartTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an end date';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () => _selectEndDate(context),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an end time';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () => _selectEndTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventLocation = value!;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventDescription = value!;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      // Get a Firestore instance
                      final firestore = FirebaseFirestore.instance;

                      // Upload image and get URL
                      String? imageUrl = await _uploadImage();

                      // Get the current user ID
                      String? creatorId = await AuthService().getCurrentUserId();

                      // Add a new document with a generated ID
                      await firestore.collection('events').add({
                        'eventName': _eventName,
                        'startDate': _startDate?.toIso8601String(),
                        'startTime': _startTime?.format(context),
                        'endDate': _endDate?.toIso8601String(),
                        'endTime': _endTime?.format(context),
                        'eventLocation': _eventLocation,
                        'eventDescription': _eventDescription,
                        'eventImage': imageUrl,
                        'creatorId': creatorId,
                        'eventId': eventId,
                      });

                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error saving event: $e');
                      // Show an error dialog or handle the error as needed
                    }
                  }
                },
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}