import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/events/events_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/profile/profile.dart';

class EventDetailsView extends ConsumerStatefulWidget {
  final EventModel event;

  const EventDetailsView({
    super.key,
    required this.event,
  });

  @override
  ConsumerState<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends ConsumerState<EventDetailsView> {
  late UserModel user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ref.read(appUserProvider).value!;
  }
  
  bool get _isLiked => widget.event.hasInterestedUser(user);
  
  void _toggleInterest() async {
    if (!_isLiked) { 
      await widget.event.addInterestedUser(user);
    } else {
      await widget.event.removeInterestedUser(user);
    }

    log(widget.event.numInterested.toString());

    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [ 
              SliverAppBar( 
                backgroundColor: Colors.white,
                pinned: true,
                scrolledUnderElevation: 0.0,
                title: Text(
                  widget.event.eventTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold),
                  ),
              ),
              SliverToBoxAdapter(  
                child: Column(  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _loadEventImage(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.event.eventTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Date: ${widget.event.dateRange}\nLocation: ${widget.event.eventLocation}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (widget.event.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.event.description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(  
                              onPressed: _toggleInterest,
                              icon: _isLiked ? const Icon(Icons.star) 
                                : const Icon(Icons.star_border),
                              label: Text(  
                                '${widget.event.numInterested} Interested',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              )
            ],
            body: _interestList(),
          ),
        ),
      ),
    );
  }

  Widget _loadEventImage() {
    if (widget.event.image.isNotEmpty) {
      return Image.network(
        widget.event.image,
        fit: BoxFit.cover,
        height: 250, // Adjust the height as needed
        width: double.infinity,
      );
    } else {
      return Image.asset(
        'assets/app/default_image.png',
        fit: BoxFit.cover,
        height: 250, // Adjust the height as needed
        width: double.infinity,
      );
    }
  }

  Widget _interestList() {
    return FutureBuilder<List<UserModel>>(
      future: widget.event.interestedUsers, 
      builder: (context, snapshot) => snapshot.hasData ? ListView(  
        padding: EdgeInsets.zero,
        children: [  
          _UserTile(widget.event.creator, isCreator: true),
          for (var user in snapshot.data!)
            _UserTile(user),
        ],
      ) : const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()))
    );
  }

  Widget _UserTile(UserModel user, { bool isCreator = false}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(userId: user.uid,))),
      child: ListTile(  
        leading: CircleAvatar(backgroundImage: NetworkImage(user.pfp)),
        title: Text('${user.displayName}${isCreator ? ' (Organiser)' : ''}'),
        subtitle: Text('@${user.username}'),
      ),
    );
  }
}