import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/views/posts/post_tile.dart';
import 'package:pawrtal/viewmodels/home/home_viewmodel.dart';
import 'package:pawrtal/views/profile/profile.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.watch(homeViewModelNotifierProvider);

    return homeViewModel.when( 
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (viewmodel) { 
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              floatingActionButton: FloatingActionButton(  // TODO: test button
                onPressed: () async {
                  Navigator.of(context).push( 
                    MaterialPageRoute( 
                      builder: (context) => ProfileView(userId: viewmodel.user.uid)
                    )
                  );
                },
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar( 
                    scrolledUnderElevation: 0,
                    backgroundColor: Colors.white,
                    snap: true,
                    floating: true,
                    title: const Image( 
                      width: 150,
                      image: AssetImage('assets/app/pawrtal_bar.png'),
                    ),
                    actions: [ 
                      // search button
                      IconButton( 
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                      // notifications button
                      IconButton( 
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_outline)
                      ),
                      // messages button
                      IconButton( 
                        onPressed: () {},
                        icon: const Icon(Icons.messenger)
                      )
                    ],
                  ),
                  StreamBuilder<List<PostModel>>( 
                    stream: viewmodel.posts,
                    builder: (context, snapshot) { 
                      return snapshot.hasData ? SliverList.list(
                        children: [ 
                          for (var post in snapshot.data!) 
                            PostTile(post: post,)
                        ], 
                      ) : const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}