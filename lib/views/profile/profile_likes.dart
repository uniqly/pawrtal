import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';
import 'package:pawrtal/views/posts/post_list_view.dart';

class ProfileLikesView extends ConsumerStatefulWidget {
  final String userId;

  const ProfileLikesView({super.key, required this.userId});

  @override
  ConsumerState<ProfileLikesView> createState() => _ProfileLikesViewState();
}

class _ProfileLikesViewState extends ConsumerState<ProfileLikesView> with AutomaticKeepAliveClientMixin<ProfileLikesView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) { 
    super.build(context);
    final profileViewModel = ref.watch(ProfileViewModelNotifierProvider(uid: widget.userId));

    return profileViewModel.when( 
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('error: $err'),
      data: (viewmodel) => PostListView(postStream: viewmodel.likedPosts),
    );
  }
}