import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';
import 'package:pawrtal/views/posts/post_list_view.dart';

class ProfilePostsView extends ConsumerStatefulWidget {
  final String userId;

  const ProfilePostsView({super.key, required this.userId});

  @override
  ConsumerState<ProfilePostsView> createState() => _ProfilePostsViewState();
}

class _ProfilePostsViewState extends ConsumerState<ProfilePostsView> with AutomaticKeepAliveClientMixin<ProfilePostsView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) { 
    super.build(context);
    final profileViewModel = ref.watch(ProfileViewModelNotifierProvider(uid: widget.userId));

    return profileViewModel.when( 
      skipLoadingOnReload: true,
      loading: () => const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
      error: (err, stack) => Text('error: $err'),
      data: (viewmodel) => PostListView(postStream: viewmodel.posts),
    );
  }
}