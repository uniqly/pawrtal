import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/views/auth/authenticate.dart';
import 'package:pawrtal/views/posts/post_list_view.dart';
import 'package:pawrtal/viewmodels/home/home_viewmodel.dart';
import 'package:pawrtal/services/auth.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin<HomeView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final homeViewModel = ref.watch(homeViewModelNotifierProvider);

    return homeViewModel.when( 
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (viewmodel) { 
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, _) => [
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
                          await AuthService.signOut();
                          // Navigate to Authenticate screen
                          if (context.mounted) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Authenticate()));
                          }
                        },
                      )
                    ],
                  ),
                ],
                body: PostListView(postStream: viewmodel.posts),
              ),
            ),
          ),
        );
      }
    );
  }
}
