import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/portals/portal.dart';
import 'package:pawrtal/views/posts/post_image_gallery.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/views/profile/profile.dart';

class PostTile extends ConsumerStatefulWidget {
  final PostModel post;
  final bool showDescription;
  final bool userInsteadOfPortal;
  
  PostTile({
    super.key,
    required this.post,
    this.showDescription = false,
    this.userInsteadOfPortal = false,
  }) { log('${post.caption}'); }

  @override
  ConsumerState<PostTile> createState() => _PostTileState();
}

class _PostTileState extends ConsumerState<PostTile> {
  late final UserModel _currUser;

  @override
  void initState() {
    super.initState();
    _currUser = ref.read(appUserProvider).value!;
  }

  void _toggleLike() async {
    if (widget.post.isLikedBy(_currUser)) {
      await widget.post.removeUserFromLikes(_currUser);
    } else {
      await widget.post.addUserToLikes(_currUser);
    }

    if (mounted) {
      setState(() {});
    }
  }

  // TODO: Implement likes / bookmark logic
  @override
  Widget build(BuildContext context) {
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        // subportal picture and name
        GestureDetector(
          onTap: () { 
            widget.userInsteadOfPortal ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileView(userId: widget.post.poster!.uid)), 
            ) : Navigator.push(  
              context, 
              MaterialPageRoute(builder: (context) => PortalView(portal: widget.post.portal!)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
            child: Row( 
              children: [ 
                CircleAvatar( 
                  backgroundImage: NetworkImage(
                    widget.userInsteadOfPortal ? widget.post.poster!.pfp! : widget.post.portal!.picture!
                  ),
                ),
                const SizedBox(width: 5.0,),
                Text( 
                  widget.userInsteadOfPortal ? '@${widget.post.poster!.username}' : 'p/${widget.post.portal!.name}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 18.0),
                )
              ],
            ),        // caption and description
          ),
        ),
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
              icon: widget.post.isLikedBy(_currUser)
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
              //icon: _post.isBookmarked
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