import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';
import 'package:pawrtal/views/posts/post_list_view.dart';

class ProfileBookmarksView extends ConsumerStatefulWidget {
  const ProfileBookmarksView({super.key});

  @override
  ConsumerState<ProfileBookmarksView> createState() => _ProfileBookmarksViewState();
}

class _ProfileBookmarksViewState extends ConsumerState<ProfileBookmarksView> {
  @override
  Widget build(BuildContext context) { 
    final profile = ref.watch(appUserProvider).value!;
    final profileViewModel = ref.watch(ProfileViewModelNotifierProvider(uid: profile.uid));

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [ 
              const SliverAppBar(  
                backgroundColor: Colors.white,
                title: Text( 
                  'Bookmarks', 
                  style: TextStyle(  
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
            body: profileViewModel.when( 
              loading: () => const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
              error: (err, stack) => Text('error: $err'),
              data: (viewmodel) => PostListView(postStream: viewmodel.bookmarkedPosts, emptyMessage: 'No Bookmarks Found'),
            ),
          ),
        ),
      ),
    );
  }
}