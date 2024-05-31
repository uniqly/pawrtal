import 'package:flutter/material.dart';
import 'package:pawrtal/models/posts/post.dart';
import 'package:pawrtal/models/posts/post_tile.dart';
import 'package:pawrtal/views/profile/profile.dart';
import 'package:pawrtal/test/placeholder_users.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(  // TODO: test button
            onPressed: () {
              Navigator.of(context).push( 
                MaterialPageRoute( 
                  builder: (context) => ProfileView(user: mainUser)
                )
              );
            },
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar( 
                scrolledUnderElevation: 0,
                backgroundColor: Colors.white,
                snap: true,
                floating: true,
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
      ),
    );
  }
}