import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';

class ProfileMediaView extends ConsumerStatefulWidget {
  final String userId;

  const ProfileMediaView({super.key, required this.userId});

  @override
  ConsumerState<ProfileMediaView> createState() => _ProfileMediaViewState();
}

class _ProfileMediaViewState extends ConsumerState<ProfileMediaView> with AutomaticKeepAliveClientMixin<ProfileMediaView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final profileViewModel = ref.watch(ProfileViewModelNotifierProvider(uid: widget.userId));

    return profileViewModel.when( 
      loading: () => const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
      error: (err, stack) => Text('error: $err'),
      data: (viewmodel) { 
        return StreamBuilder(  
          stream: viewmodel.media,
          builder: (context, snapshot) { 
            return snapshot.hasData ? ListView(
              children: [
                GridView.builder( 
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
                    crossAxisCount: 2,
                  ), 
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect( 
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container( 
                          color: Colors.grey[400],
                          child: Image( 
                            fit: BoxFit.cover,
                            image: NetworkImage(snapshot.data![index]),
                            errorBuilder: (context, err, stack) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    );
                  }
                ),
                if (snapshot.data!.isEmpty)
                  const Center(child: Text('No Media Found')),
              ],
            ) : const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
          },
        );
      }
    );
  }
}