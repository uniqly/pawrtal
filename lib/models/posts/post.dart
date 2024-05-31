import 'package:flutter/material.dart';
import 'package:pawrtal/models/posts/post_image_gallery.dart';
import 'package:pawrtal/models/subpawrtal/subpawrtal.dart';
import 'package:pawrtal/models/user/app_user.dart';

class Post {
  final SubPawrtal portal;
  final AppUser poster;
  final String caption;
  bool isLiked = false;
  bool isBookmarked = false;
  int likeCount;
  int commentCount;

  Post({required this.portal, required this.poster, required this.caption, this.likeCount = 0, this.commentCount = 0});

  Widget get captionText => Text(
    caption,
    textAlign: TextAlign.left,
    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  );

  Widget get content => const SizedBox.shrink();
  
  void toggleLike() { 
    isLiked = !isLiked; 
    likeCount = isLiked ? likeCount + 1 : likeCount - 1;
  }

  void toggleBookmark() {
    isBookmarked = !isBookmarked;
  }
}

class ImagePost extends Post {
  final List<String> imageStrings;

  ImagePost({required super.portal, required super.poster, required super.caption,
   super.likeCount = 0, super.commentCount = 0, required this.imageStrings});

  @override
  Widget get content => PostGallery(imageStrings: imageStrings);
}

class PostGallery extends StatelessWidget {
  const PostGallery({
    super.key,
    required this.imageStrings,
  });

  final List<String> imageStrings;

  @override
  Widget build(BuildContext context) {
    return PostImageGallery(imageStrings: imageStrings);
  }
}
