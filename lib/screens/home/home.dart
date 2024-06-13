// Deprecated: to delete
/*
import 'package:flutter/material.dart';
import 'package:pawrtal/posts/post.dart';
import 'package:pawrtal/posts/post_tile.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:pawrtal/subpawrtal/subpawrtal.dart';
import 'package:pawrtal/test/placeholder_images.dart';
import 'package:pawrtal/user/app_user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var pageIndex = 0;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    // testing
    var me = AppUser.testUser('0', name: 'samoyed lover', pfp: pfpMe);
    var samoyedPortal = SubPawrtal('samoyed', pfpMe);
    var posts = [ 
      ImagePost(
        portal: samoyedPortal,
        poster: me,
        caption: 'Samoyed at Colour Run',
        imageStrings: [image1, 'invalid', image1],
        likeCount: 1344, commentCount: 345),
      Post( 
        portal: samoyedPortal,
        poster: me,
        caption: 'How to take care of samoyed in hot weather',
        likeCount: 44, commentCount: 17
      )
    ];

    return Scaffold( 
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar( 
              backgroundColor: Colors.white,
              title: const Image( 
                width: 150,
                image: AssetImage('assets/app/pawrtal_bar.png'),
              ),
              actions: [ 
                // search button
                IconButton( 
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                // notifications button
                IconButton( 
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_outline)
                ),
                // messages button
                IconButton( 
                  onPressed: () {},
                  icon: const Icon(Icons.messenger)
                ),
                // logout button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey[400], // background color
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    if (mounted) {
                      await _auth.signOut();
                      // Navigate to Authenticate screen
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                )
              ],
            ),
            SliverList.builder( 
              itemCount: posts.length,
              itemBuilder: (context, index) { 
                return PostTile(post: posts[index]);
              },
            ),
          ]
        ),
      ),
      bottomNavigationBar: NavigationBar( 
        height: 54,
        selectedIndex: pageIndex,
        indicatorColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        onDestinationSelected: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          const NavigationDestination( 
            icon: Icon(
              Icons.home_outlined,
              size: 28,
            ),
            selectedIcon: Icon(
              Icons.home,
              size: 28,
            ),
            label: '',
          ),
          const NavigationDestination( 
            icon: Icon(
              Icons.add_rounded,
              size: 28,
            ),
            selectedIcon: Icon(
              Icons.add_rounded,
              size: 32,
            ),
            label: '',
          ),
          NavigationDestination( 
            icon: CircleAvatar(
              backgroundColor: pageIndex == 2 ? Colors.pinkAccent : Colors.transparent,
              radius: 22,
              child: const CircleAvatar( 
                backgroundImage: AssetImage(pfpMe),
                radius: 20,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
*/