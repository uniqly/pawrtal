import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/test/placeholder_images.dart';
import 'package:pawrtal/test/test_user.dart';
import 'package:pawrtal/viewmodels/create/create_post_viewmodel.dart';

class CreateChoosePortalView extends ConsumerStatefulWidget {
  const CreateChoosePortalView({super.key});

  @override
  ConsumerState<CreateChoosePortalView> createState() => _CreateChoosePortalViewState();
}

class _CreateChoosePortalViewState extends ConsumerState<CreateChoosePortalView> {
  String query = '';
  int? selectedIndex;
  String? selectedPortalId;

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
              backgroundColor: Colors.white,
              title: const Text(
                'Post to',
                style: TextStyle( 
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [ 
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: TextButton( 
                    onPressed: selectedIndex != null ? () async { 
                      viewmodel.updateForm(portalId: selectedPortalId);
                      await viewmodel.createPost().whenComplete(() async {
                        const success = SnackBar( 
                          content: Text('Success!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(success);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        //await ref.read(mainUserProvider.notifier).refresh();
                      }).onError((s, e) { 
                        final error = SnackBar( 
                          content: Text('Error with upload, $e'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(error);
                      });
                    } : null,
                    style: TextButton.styleFrom( 
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      disabledForegroundColor: Theme.of(context).colorScheme.surfaceDim,
                    ),
                    child: const Text('Create Post'),
                  ),
                ),
              ],
              leading: const CloseButton(),
            ),
            body: Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column( 
                children: [ 
                  TextFormField( 
                    onFieldSubmitted: (value) => setState(() => query = value),
                  ),
                  Expanded(
                    child: StreamBuilder<List<PortalModel>>( 
                      stream: viewmodel.portalQuery(query),
                      builder: (context, snapshot) { 
                          log('snap: $snapshot');
                          final data = snapshot.data;
                          log('post (pawrtals): $data');
                          return snapshot.hasData ? ListView.builder( 
                            itemCount: data!.length,
                            itemBuilder: (context, index) { 
                              final portal = data[index];
                              return Card( 
                                child: ListTile( 
                                  enabled: true,
                                  selected: index == selectedIndex,
                                  leading: CircleAvatar( 
                                    backgroundImage: NetworkImage(portal.picture!),
                                    onBackgroundImageError: (err, s) => const AssetImage(pfpOther),
                                    radius: 35.0,
                                  ),
                                  trailing: selectedIndex == index ? const Icon(Icons.check_circle_outline) : null,
                                  title: Text('p/${portal.name}'),
                                  subtitle: Text('${NumberFormat.compact().format(portal.memberCount)} members'),
                                  onTap: () { 
                                    setState(() {
                                      if (index == selectedIndex) { // toggle off
                                        selectedIndex = null;
                                        selectedPortalId = null;
                                      } else { 
                                        selectedIndex = index;
                                        selectedPortalId = portal.uid;
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ) : const SizedBox.shrink();
                      }
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      )
    );
  }
}