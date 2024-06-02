import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/viewmodels/create/create_post_viewmodel.dart';

class CreateChoosePortalView extends ConsumerStatefulWidget {
  const CreateChoosePortalView({super.key});

  @override
  ConsumerState<CreateChoosePortalView> createState() => _CreateChoosePortalViewState();
}

class _CreateChoosePortalViewState extends ConsumerState<CreateChoosePortalView> {
  @override
  Widget build(BuildContext context) {
    final createPostViewModel = ref.watch(createPostViewModelNotifierProvider);

    return Container( 
      color: Colors.white,
      child: SafeArea( 
        child: Scaffold( 
          appBar: AppBar( 
            backgroundColor: Colors.white,
            title: const Text(
              'Post to',
              style: TextStyle( 
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const CloseButton(),
          ),
          body: Text('$createPostViewModel'),
        ),
      ),
    );
  }
}