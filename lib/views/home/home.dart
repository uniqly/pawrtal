import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/views/posts/post_list_view.dart';
import 'package:pawrtal/viewmodels/home/home_viewmodel.dart';
import 'package:pawrtal/viewmodels/messaging/message_view.dart';

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
      loading: () => const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MessageView()),
                          );
                        },
                        icon: const Icon(Icons.messenger)
                      ),
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
