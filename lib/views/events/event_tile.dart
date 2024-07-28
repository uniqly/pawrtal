import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/events/events_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/events/create_event_view.dart';
import 'package:pawrtal/views/events/event_details_view.dart';

class EventTile extends ConsumerStatefulWidget {
  final EventModel event;
  const EventTile({super.key, required this.event});

  @override
  ConsumerState<EventTile> createState() => _EventTileState();
}

class _EventTileState extends ConsumerState<EventTile> {
  late UserModel user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ref.read(appUserProvider).value!;
  }
  
  bool get _isLiked => widget.event.hasInterestedUser(user);
  bool get _isCreator => user.uid == widget.event.creator.uid;

  Widget _loadEventImage() {
    if (widget.event.image.isNotEmpty) {
      return Image.network(
        widget.event.image,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      // Display default image
      return Image.asset(
        'assets/app/default_image.png', // Update this path to your default image
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  void _toggleInterest() async {
    if (!_isLiked) { 
      await widget.event.addInterestedUser(user);
    } else {
      await widget.event.removeInterestedUser(user);
    }

    setState(() {});
  }

  Widget _deleteButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          // Show delete confirmation dialog
          bool? confirmDelete = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Delete Event'),
                content: const Text('Are you sure you want to delete this event?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
      
          if (confirmDelete == true) {
            await widget.event.delete();
          }
        },
        child: const Text('Delete'),
      ),
    );
  }

  Widget _editButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEventView(
                event: widget.event,
              ),
            ),
          );
        },
        child: const Text('Edit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card( 
      margin: const EdgeInsets.all(10.0),
      child: InkWell(  
        onTap: () { 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventDetailsView( 
              event: widget.event,
            ))
          );
        },
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            _loadEventImage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                widget.event.eventTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                widget.event.dateRange,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                widget.event.eventLocation,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding( 
              padding: const EdgeInsets.all(8.0),
              child: Column(  
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [  
                  ElevatedButton.icon(  
                    onPressed: _toggleInterest,
                    icon: _isLiked ? const Icon(Icons.star) 
                      : const Icon(Icons.star_border),
                    label: Text(  
                      '${widget.event.numInterested} Interested',
                    ),
                  ),
                  if (_isCreator) 
                    Row(  
                      children: [  
                        _editButton(),
                        const SizedBox(width: 10.0,),
                        _deleteButton()
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}