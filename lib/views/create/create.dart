import 'package:flutter/material.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  var isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  onPressed: isButtonDisabled ? null : () {},
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
                setState(() {
                  isButtonDisabled = !isButtonDisabled;
                });
              },
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.surface,
              child: const Icon(Icons.add_photo_alternate_outlined, size: 40,),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column( 
              children: [ 
                TextFormField( 
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
                ),
                TextFormField( 
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
          )
        ),
      ),
    );
  }
}