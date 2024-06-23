import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/posts/post_image_gallery.dart';
import 'package:pawrtal/models/posts/post_model.dart';

class PostTile extends ConsumerStatefulWidget {
  final PostModel post;
  final bool showDescription;
  
  const PostTile({
    super.key,
    required this.post,
    this.showDescription = false,
  });

  @override
  ConsumerState<PostTile> createState() => _PostTileState();
}

class _PostTileState extends ConsumerState<PostTile> {
  late final UserModel _currUser;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _currUser = ref.read(appUserProvider).value!;
    _isLiked = widget.post.isLikedBy(_currUser);
  }

  void _toggleLike() {
    if (_isLiked) {
      widget.post.removeUserFromLikes(_currUser);
    } else {
      widget.post.addUserToLikes(_currUser);
    }

    setState(() {
      _isLiked = widget.post.isLikedBy(_currUser);
    });
  }

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
                backgroundImage: NetworkImage(widget.post.portal!.picture!),
              ),
              const SizedBox(width: 5.0,),
              Text( 
                'p/${widget.post.portal!.name}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 18.0),
              )
            ],
          ),
        ),
        // caption and description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.caption!,
                style: const TextStyle( 
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              if (widget.showDescription && widget.post.description!.isNotEmpty)
              Text(widget.post.description!),
            ],
          ),
        ),
        // content (images)
        if (widget.post.images!.isNotEmpty) 
        PostImageGallery(imageStrings: widget.post.images!),
        // actions bar of post
        Row( 
          children: [
            TextButton.icon( 
              onPressed: _toggleLike,
              icon: _isLiked  
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