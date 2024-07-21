import 'package:flutter/material.dart';
import 'package:pawrtal/models/comments/comment_model.dart';
import 'package:pawrtal/views/profile/profile.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final poster = comment.poster;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(  
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          Row(  
            children : [ 
              GestureDetector(
                onTap: () { 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(userId: poster.uid)));
                },
                child: Row(
                  children: [
                    CircleAvatar(  
                      backgroundImage: NetworkImage(poster.pfp),
                    ),
                    const SizedBox(width: 5.0),
                    Text('@${poster.username}'),
                  ],
                ),
              ),
              const Spacer(),
              Timeago( 
                builder: (_, value) => Text(value), 
                date: comment.postedDate 
              ),
            ],
          ),
          Text(comment.message),
          const Divider(height: 0),
        ],
      ),
    );
  }
}