import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/viewmodels/create/create_post_viewmodel.dart';
import 'package:pawrtal/views/create/create_choose_portal.dart';

class CreateView extends ConsumerStatefulWidget {
  const CreateView({super.key});

  @override
  ConsumerState<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends ConsumerState<CreateView> {
  final _formKey = GlobalKey<FormState>();
  final captionController = TextEditingController();
  final descriptionController = TextEditingController();

  bool _validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(createPostViewModelNotifierProvider);

    return notifier.when( 
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('error: $err'),
      data: (viewmodel) => Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold( 
            appBar: AppBar( 
              leading: const CloseButton(),
              backgroundColor: Colors.white,
              title: const Text(
                'Create Post',
                style: TextStyle( 
                  fontWeight: FontWeight.bold,
                )
              ),
              actions: [ 
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: TextButton( 
                    style: TextButton.styleFrom( 
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      disabledForegroundColor: Theme.of(context).colorScheme.surfaceDim,
                    ),
                    onPressed: _validate() ? () { 
                      log('$viewmodel');
                      viewmodel.updateForm(
                        caption: captionController.text,
                        description: descriptionController.text
                      );
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CreateChoosePortalView()
                        )
                      );
                    } : null,
                    child: const Text('Next'), 
                  ),
                ),
              ],
            ),
            floatingActionButton: SizedBox(
              height: 75,
              width: 75,
              child: FloatingActionButton( // TODO: Implement picture picker
                onPressed: () { 
                },
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                child: const Icon(Icons.add_photo_alternate_outlined, size: 40,),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: _formKey,
                child: Column( 
                  children: [ 
                    TextFormField( 
                      validator: (value) => value?.isEmpty ?? true ? '' : null,
                      controller: captionController,
                      decoration: InputDecoration( 
                        border: InputBorder.none,
                        hintText: 'Add a title...',
                        hintStyle: TextStyle( 
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      ),     
                      maxLines: null,
                      minLines: 2,
                      style: TextStyle( 
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondaryContainer, 
                      ),
                      onChanged: (value) => setState(() => log('${_formKey.currentState?.validate()})')),
                    ),
                    TextFormField( 
                      controller: descriptionController,
                      decoration: InputDecoration( 
                        border: InputBorder.none,
                        hintText: 'Add a description (optional)',
                        hintStyle: TextStyle( 
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      ),
                      style: TextStyle( 
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      maxLines: null,
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      )
    ); 
  }
}