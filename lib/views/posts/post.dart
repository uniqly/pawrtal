import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/comments/comment_model.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/posts/comments/comment_tile.dart';
import 'package:pawrtal/views/posts/post_tile.dart';

class PostView extends ConsumerStatefulWidget {
  final PostModel post;
  const PostView({super.key, required this.post});

  @override
  ConsumerState<PostView> createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  late final TextEditingController _commentController;
  late final UserModel _user;

  @override 
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _user = ref.read(appUserProvider).value!;
  }

  @override 
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView( 
            headerSliverBuilder: (context, _) => [
              const SliverAppBar( 
                scrolledUnderElevation: 0.0,
                backgroundColor: Colors.white,
                title: Text(
                  'Post',
                  style: TextStyle(  
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
            body: StreamBuilder<List<CommentModel>>(
              stream: widget.post.comments,
              builder: (context, snapshot) => snapshot.hasData ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [ 
                        PostTile(post: widget.post, showDescription: true),
                        if (snapshot.data!.isEmpty)
                          const Center( 
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text('No Comments Yet'),
                            ),
                          ),
                        for (var comment in snapshot.data!) 
                          CommentTile(comment: comment)
                      ],
                    ),
                  ),
                  Container(
                    height: 54,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Row( 
                        children: [ 
                          SizedBox(
                            width: 40,
                            child: CircleAvatar( 
                              backgroundColor: Colors.white,  
                              backgroundImage: NetworkImage(_user.pfp!),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: TextField( 
                                maxLines: null,
                                controller: _commentController,
                                decoration: InputDecoration( 
                                  contentPadding: const EdgeInsets.all(6.0),
                                  hintText: 'Add a comment',
                                  border: OutlineInputBorder( 
                                    borderSide: BorderSide( 
                                      color: Theme.of(context).colorScheme.surfaceTint,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  fillColor: Theme.of(context).colorScheme.primaryContainer,
                                  filled: true,
                                  suffixIcon: _commentController.text.isNotEmpty ? IconButton( 
                                    onPressed: () async {
                                      await widget.post.uploadComment(
                                        message: _commentController.text,
                                        commenter: _user
                                      ).whenComplete(() {
                                        const success = SnackBar( 
                                          content: Text('Sent Comment!'),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(success);
                                        //await ref.read(mainUserProvider.notifier).refresh();
                                      }).onError((s, e) { 
                                        final error = SnackBar( 
                                          content: Text('Error with upload, $e'),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(error);
                                      });
                                    },
                                    icon: const Icon(Icons.send_rounded),
                                  ) : null,
                                ),
                                onChanged: (value) => setState(() {}),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ) : const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
            ),
          )
        ),
      ),
    );
  }
}