import 'package:flutter/material.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/views/posts/post.dart';
import 'package:pawrtal/views/posts/post_tile.dart';

class PostListView extends StatelessWidget {
  final Stream<List<PostModel>> postStream;

  const PostListView({
    super.key,
    required this.postStream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>( 
      stream: postStream,
      builder: (context, snapshot) { 
        return snapshot.hasData ? ListView(
          children: [ 
            for (var post in snapshot.data!) 
              InkWell(
                onTap: () { 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostView(post: post)));
                },
                child: PostTile(post: post)
              )
          ], 
        ) : const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
      },
    );
  }
}