import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';
import 'package:pawrtal/views/portals/portal_card.dart';

class ProfileCommunititesView extends ConsumerStatefulWidget {
  final String userId;

  const ProfileCommunititesView({super.key, required this.userId});

  @override
  ConsumerState<ProfileCommunititesView> createState() => _ProfileCommunititesViewState();
}

class _ProfileCommunititesViewState extends ConsumerState<ProfileCommunititesView> with AutomaticKeepAliveClientMixin<ProfileCommunititesView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) { 
    super.build(context);
    final profileViewModel = ref.watch(ProfileViewModelNotifierProvider(uid: widget.userId));

    return profileViewModel.when( 
      loading: () => const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
      error: (err, stack) => Text('error: $err'),
      data: (viewmodel) => StreamBuilder<List<PortalModel>>(  
        stream: viewmodel.portals,
        builder: (context, snapshot) { 
          log('portals: ${snapshot.data}');
          return snapshot.hasData ? ListView(  
            children: [  
              for (var portal in snapshot.data!)
                PortalCard(portal: portal),
              if(snapshot.data!.isEmpty)
                const Center(child: Text('User is not in any community')),
            ],
          ) : const CircularProgressIndicator();
        }
      ),
    );
  }
}