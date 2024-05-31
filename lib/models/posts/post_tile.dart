import 'package:flutter/material.dart';
import 'package:pawrtal/models/posts/post.dart';

class PostTile extends StatefulWidget {
  final Post post;

  const PostTile({
    super.key,
    required this.post,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  void toggleLike() {
    setState(() {
      widget.post.toggleLike();
    });
  }

  void toggleBookmark() {
    setState(() {
      widget.post.toggleBookmark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        // subportal picture and name
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row( 
            children: [ 
              CircleAvatar( 
                backgroundImage: widget.post.portal.portalPfp,
              ),
              const SizedBox(width: 5.0,),
              Text( 
                'p/${widget.post.portal.name}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 18.0),
              )
            ],
          ),
        ),
        // caption and content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: widget.post.captionText,
        ),
        GestureDetector(
          onDoubleTap: toggleLike,
          child: widget.post.content
        ),
        // actions bar of post
        Row( 
          children: [
            TextButton.icon( 
              onPressed: toggleLike,
              icon: widget.post.isLiked  
                ? const Icon(Icons.favorite, color: Colors.red,)
                : const Icon(Icons.favorite_outline),
              label: Text('${widget.post.likeCount}'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.message_outlined),
              label: Text('${widget.post.commentCount}'),
            ),
            IconButton( 
              onPressed: toggleBookmark,
              icon: widget.post.isBookmarked
                ? const Icon(Icons.bookmark) 
                : const Icon(Icons.bookmark_outline),
            ),
          ],
        ),
      ],
    );
  }
}