import 'package:pawrtal/models/posts/post.dart';
import 'package:pawrtal/test/placeholder_images.dart';
import 'package:pawrtal/test/placeholder_portals.dart';
import 'package:pawrtal/test/placeholder_users.dart';

final imgPost = ImagePost(
  portal: samoyedPortal,
  poster: mainUser,
  caption: 'Samoyed at Colour Run',
  imageStrings: [image1, image4, image3, image4],
  likeCount: 1344, commentCount: 345
);

final textPost = Post( 
  portal: samoyedPortal,
  poster: mainUser,
  caption: 'How to take care of samoyed in hot weather',
  likeCount: 44, commentCount: 17
);

final posts = [ 
  imgPost,
  textPost,
];