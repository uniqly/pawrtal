import 'package:flutter/material.dart';
import 'package:pawrtal/posts/post.dart';
import 'package:pawrtal/posts/post_tile.dart';
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
      appBar: AppBar( 
        title: const Text( 
          'pawrtal',
        ),
        actions: [ 
          IconButton( 
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline)
          ),
          IconButton( 
            onPressed: () {},
            icon: const Icon(Icons.messenger)
          )
        ],
      ),
      body: ListView.builder( 
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) { 
          return PostTile(post: posts[index]);
        },
      ),
      bottomNavigationBar: NavigationBar( 
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination( 
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '',
          ),
          NavigationDestination( 
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '',
          ),
          NavigationDestination( 
            icon: Icon(Icons.add_outlined),
            selectedIcon: Icon(Icons.add),
            label: '',
          ),
          NavigationDestination( 
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: '',
          ),
          NavigationDestination( 
            icon: CircleAvatar( 
              backgroundImage: AssetImage(pfpMe),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}