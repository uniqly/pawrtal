import 'package:flutter/material.dart';
import 'package:pawrtal/models/notifications/notification_model.dart';
import 'package:pawrtal/views/notifications/notification_tile.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Container(  
      color: Colors.white,
      child: SafeArea(  
        child: Scaffold(  
          body: NestedScrollView(  
            headerSliverBuilder: (context, _) => [  
              const SliverAppBar(  
                scrolledUnderElevation: 0.0,
                backgroundColor: Colors.white,
                title: Text(
                  'Notifications',
                  style: TextStyle( 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                snap: true,
                floating: true,
              )
            ],
            body: StreamBuilder<List<NotificationModel>>(  
              stream: NotificationModel.getNotifications,
              builder: (context, snapshot) => snapshot.hasData ? ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, idx) => NotificationTile(notification: snapshot.data![idx]), 
              ) : const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
            ),
          ),
        )
      ),
    );
  }
}