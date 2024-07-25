import 'package:flutter/material.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/views/posts/post.dart';
import 'package:pawrtal/views/posts/post_tile.dart';

class PostListView extends StatelessWidget {
  final Stream<List<PostModel>> postStream;
  final bool showDescription;
  final bool userInsteadOfPortal;
  final bool chatRedirect;
  final String emptyMessage;

  const PostListView({
    super.key,
    required this.postStream,
    this.showDescription = false,
    this.userInsteadOfPortal = false,
    this.chatRedirect = true,
    this.emptyMessage = 'No Posts Found',
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
                child: PostTile( 
                  post: post,
                  showDescription: showDescription,
                  userInsteadOfPortal: userInsteadOfPortal,
                )
              ),
            if (snapshot.data!.isEmpty)
              Center(child: Text(emptyMessage)),
          ], 
        ) : const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
      },
    );
  }
}