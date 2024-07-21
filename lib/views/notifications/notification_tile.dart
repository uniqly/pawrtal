import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pawrtal/models/notifications/notification_model.dart';

class NotificationTile extends StatefulWidget {
  final NotificationModel notification;
  const NotificationTile({super.key, required this.notification});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (contxt) { 
      if (context.mounted) { 
        setState(() {log('refresh timer, ${widget.notification.uid}');});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(  
      padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: ListTile( 
          title: RichText(
            text: TextSpan( 
              style: const TextStyle(  
                color: Colors.black,
              ),
              children: [ 
                TextSpan( 
                  text: '${widget.notification.title ?? ''} • ',
                  style: const TextStyle( 
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextSpan(  
                  text: widget.notification.formatedTimeAgo,
                )
              ],
            )
          ),
          leading: widget.notification.image != null ? CircleAvatar(  
            backgroundImage: NetworkImage(widget.notification.image!),
          ) : null,
          trailing: IconButton(  
            icon: const Icon(Icons.close),
            onPressed: widget.notification.clear,
          ),
          subtitle: widget.notification.message != null ? Text(
            widget.notification.message!,
            style: TextStyle( 
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ) : null,
        ),
      )
    );
  }
}