import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/posts/post_model.dart';
import 'package:pawrtal/views/posts/post_tile.dart';
import 'package:pawrtal/viewmodels/home/home_viewmodel.dart';
import 'package:pawrtal/views/profile/profile.dart';
import 'package:pawrtal/services/auth.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin<HomeView> {
  final AuthService _auth = AuthService();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => const ProfileView(userId: 'otheruser')
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
                      ),
                      // logout button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey[400], // background color
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (mounted) {
                            await AuthService.signOut();
                            // Navigate to Authenticate screen
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
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
                      ) : const SliverToBoxAdapter(child: CircularProgressIndicator());
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