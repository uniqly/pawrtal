import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/models/events/events_model.dart';
import 'package:pawrtal/services/auth.dart';

class CreateEventView extends StatefulWidget {
  final EventModel? event;

  const CreateEventView({super.key, this.event});

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();

  String _eventName = '';
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  String _eventLocation = '';
  String _eventDescription = '';
  String _eventImage = '';
  String creatorId = '';
  File? selectedFile;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _startDateTimeController = TextEditingController();
  final TextEditingController _endDateTimeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // check if we are editing the event, and set form state
    if (widget.event != null) {
      _eventName = widget.event!.eventTitle;
      _eventLocation = widget.event!.eventLocation;
      _eventDescription = widget.event!.description;
      _eventImage = widget.event!.image;

      // Parse date and time fields if they exist
      _startDateTime = widget.event!.startDateTime;
      _startDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(_startDateTime!);

      _endDateTime = widget.event!.endDateTime;
      _endDateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(_endDateTime!);
    }
  }

  String? validateDatesAndTimes() {
    if (_startDateTime == null || _endDateTime == null) {
      return 'Start date/time and end date/time cannot be null';
    }

    if (!_startDateTime!.isBefore(_endDateTime!)) {
      return 'Start date/time must be before end date/time';
    }

    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (selectedFile == null) {
      return widget.event != null 
        ? _eventImage
        : '';
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('event_images/$fileName');
    await storageRef.putFile(selectedFile!);
    return await storageRef.getDownloadURL();
  }

  Future<void> _selectStartDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDateTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _startDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _startDateTimeController.text = DateFormat('dd MMMM yyyy, HH:mm').format(_startDateTime!);
        });
      }
    }
  }

  Future<void> _selectEndDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endDateTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _endDateTimeController.text = DateFormat('dd MMMM yyyy, HH:mm').format(_endDateTime!);
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    final dateValidationMessage = validateDatesAndTimes(); // Call the validateDatesAndTimes method
    if (_formKey.currentState!.validate() && dateValidationMessage == null) {
      _formKey.currentState!.save();

      try {
        // Get a Firestore instance
        final firestore = FirebaseFirestore.instance;

        // Upload image and get URL
        String? imageUrl = await _uploadImage();

        // Get the current user ID
        String? creatorId = await AuthService().getCurrentUserId();

        final eventData = {
          'eventName': _eventName,
          'startDateTime': _startDateTime,
          'endDateTime': _endDateTime,
          'eventLocation': _eventLocation,
          'eventDescription': _eventDescription,
          'eventImage': imageUrl,
          'creatorId': creatorId,
        };

        if (widget.event != null) {
          // Editing existing event
          await widget.event!.dbRef.update(eventData);
        } else {
          // Creating new event
          await firestore.collection('events').add(eventData);
        }

        // Navigate back to the previous screen
        if (context.mounted) { 
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error saving event: $e');
        // Show an error dialog or handle the error as needed
      }
    } else if (dateValidationMessage != null) {
      // Show an error message if date validation fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(dateValidationMessage),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : 'Create Event'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 241, 232, 245),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (selectedFile != null) 
                  Image.file(
                    selectedFile!,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
              else widget.event == null
                ? Image.asset(
                    'assets/app/default_image.png',
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    _eventImage,
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
                initialValue: _eventName,
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
                  _eventName = value ?? '';
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _startDateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Start Date & Time',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectStartDateTime(context),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _endDateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'End Date & Time',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectEndDateTime(context),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: _eventLocation,
                decoration: const InputDecoration(
                  labelText: 'Event Location',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _eventLocation = value ?? '';
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: _eventDescription,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) {
                  _eventDescription = value ?? '';
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
                onPressed: _saveEvent,
                child: const Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}