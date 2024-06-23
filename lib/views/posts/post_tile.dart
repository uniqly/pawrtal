import 'package:flutter/material.dart';
import 'package:pawrtal/views/posts/post_image_gallery.dart';
import 'package:pawrtal/models/posts/post_model.dart';

class PostTile extends StatelessWidget {
  final PostModel post;

  const PostTile({
    super.key,
    required this.post,
  });

  // TODO: Implement likes / bookmark logic
  @override
  Widget build(BuildContext context) {
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        // subportal picture and name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          child: Row( 
            children: [ 
              CircleAvatar( 
                backgroundImage: NetworkImage(post.portal!.picture!),
              ),
              const SizedBox(width: 5.0,),
              Text( 
                'p/${post.portal!.name}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 18.0),
              )
            ],
          ),
        ),
        // caption and content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            post.caption!,
            style: const TextStyle( 
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        post.images!.isNotEmpty ? PostImageGallery(imageStrings: post.images!) : const SizedBox.shrink(),
        // actions bar of post
        Row( 
          children: [
            TextButton.icon( 
              onPressed: () {},
              //icon: widget.post.isLiked  
              //  ? const Icon(Icons.favorite, color: Colors.red,)
              //  : const Icon(Icons.favorite_outline),
              icon: const Icon(Icons.favorite_outline),
              label: Text('${post.likeCount}'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.message_outlined),
              label: Text('${post.commentCount}'),
            ),
            IconButton( 
              onPressed: () {},
              //icon: widget.post.isBookmarked
              //  ? const Icon(Icons.bookmark) 
              //  : const Icon(Icons.bookmark_outline),
              icon: const Icon(Icons.bookmark_outline),
            ),
          ],
        ),
        const Divider( 
          height: 0,
        ),
      ],
    );
  }
}