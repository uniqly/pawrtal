import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  List<File> _images = [];
  void _pickImages() async {
    try {
      //final image = await ImagePicker().pickImage(source:  ImageSource.gallery);
      final images = await ImagePicker().pickMultiImage();
      log('$images');

      final temp = images.map((image) => File(image.path)).toList();
      setState(() {
        _images = temp;
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  void _removeImage(File image) {
    if (_images.contains(image)) {
      setState(() {
        _images.remove(image);
      });
    }
  }

  @override
  void dispose() { 
    super.dispose();
    captionController.dispose();
    descriptionController.dispose();
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
                      viewmodel.updateForm(
                        caption: captionController.text,
                        description: descriptionController.text,
                        images: _images
                      );
                      log('form: $viewmodel');
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
              child: FloatingActionButton( 
                onPressed: () { 
                  _pickImages(); 
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 120,
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: ShaderMask(
                        shaderCallback: (rect) { 
                          return const LinearGradient( 
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight, 
                            colors: [Colors.transparent, Colors.purple],
                            stops: [0.8, 1.0],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: ListView.builder( 
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) => Stack(
                            alignment: Alignment.topRight,
                            children: [ 
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.file(
                                    _images[index],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.red, 
                                child: IconButton(
                                  color: Theme.of(context).colorScheme.surfaceContainer,
                                  onPressed: () => _removeImage(_images[index]), 
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 15.0,
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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