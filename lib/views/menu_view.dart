import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:pawrtal/viewmodels/messaging/message_view.dart';
import 'package:pawrtal/views/events/events_view.dart';
import 'package:pawrtal/views/portals/portal_list.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 240, 219, 243),
            body: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  scrolledUnderElevation: 0.0,
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    'Menu',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: GridView.count(
                    padding: const EdgeInsets.all(6.0),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildGridTile(Icons.event, 'Events', () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventsView()),
                      );
                      }),
                      _buildGridTile(Icons.message, 'Messages', () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MessageView()),
                      );
                      }),
                      _buildGridTile(Icons.emoji_events, 'Compawtitions', () {
                        // Navigate to Events page
                      }),
                       _buildGridTile(Icons.pets, 'Subpawrtals', () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PortalsList()),
                      );
                      }),
                      _buildGridTile(Icons.settings, 'Profile Settings', () {
                        // Navigate to Profile Settings page
                      }),
                      _buildGridTile(Icons.notifications, 'Notifications', () {
                        // Navigate to Notifications page
                      }),
                      _buildGridTile(Icons.bookmark, 'Saved Posts', () {
                        // Navigate to Saved Posts page
                      }),
                      _buildGridTile(Icons.logout, 'Logout', () async {
                        setState(() {
                          loading = true;
                        });
                        await _auth.signOut();
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                        setState(() {
                          loading = false;
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildGridTile(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}