import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';
import 'package:pawrtal/views/profile/profile_communities.dart';
import 'package:pawrtal/views/profile/profile_edit.dart';
import 'package:pawrtal/views/profile/profile_likes.dart';
import 'package:pawrtal/views/profile/profile_media.dart';
import 'package:pawrtal/views/profile/profile_posts.dart';
import 'package:pawrtal/viewmodels/messaging/message_view.dart';


class ProfileView extends ConsumerStatefulWidget {
  final String userId;
  const ProfileView({super.key, required this.userId});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
@override
  Widget build(BuildContext context) {
    final profileViewModel = ref.watch(ProfileViewModelNotifierProvider(uid: widget.userId));
    
    return profileViewModel.when( 
      skipLoadingOnReload: true,
      loading: () => const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator())),
      //loading: () => const Loading(),
      error: (err, stack) => Text('error: $err'),
      data: (viewmodel) { 
        final userData = viewmodel.profileInfo;
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              body: DefaultTabController(
                length: 4,
                child: NestedScrollView( 
                  headerSliverBuilder: (context, _) => [
                    SliverAppBar(
                      scrolledUnderElevation: 0,
                      backgroundColor: Colors.white,
                      title: const Text(
                        'Profile',
                        style: TextStyle( 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      snap: true,
                      floating: true,
                      actions: [ 
                        // search button
                        IconButton( 
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                        // notifications button
                        IconButton( 
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_outline)
                        ),
                        // messages button
                        IconButton( 
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MessageView()),
                            );
                          },
                          icon: const Icon(Icons.messenger)
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Stack( 
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50.5),
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: NetworkImage(userData['banner']),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CircleAvatar( 
                                      backgroundColor: Colors.white,
                                      radius: 51,
                                      child: CircleAvatar( 
                                        backgroundImage: NetworkImage(userData['pfp']),
                                        radius: 50,
                                      ),
                                    ),
                                    // button depending on userprofile
                                    viewmodel.isCurrUserProfile ? TextButton(
                                      style: TextButton.styleFrom( 
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Theme.of(context).colorScheme.surface,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          const ProfileEditView()
                                        ));
                                      },
                                      child: const Text(
                                        'Edit Pawfile',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ), 
                                    ) : TextButton(
                                      style: TextButton.styleFrom( 
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Theme.of(context).colorScheme.surface,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: viewmodel.toggleFollow,
                                      child: Text(
                                        viewmodel.isUserFollowingProfile ? 'Following' : 'Follow',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ), 
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding( 
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column( 
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Text(
                                    userData['name'],
                                    style: const TextStyle( 
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '@${userData['username']}',
                                  style: TextStyle( 
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.surfaceTint,
                                  ),
                                ),
                                Text(
                                  userData['bio'].isEmpty ? '- empty bio -' : userData['bio'],
                                  style: const TextStyle( 
                                    fontSize: 14,
                                  ),
                                ),
                                Row( 
                                  children: [ 
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    Text(
                                      userData['location'].isEmpty ? 'Unknown Location' : userData['location'],
                                      style: TextStyle( 
                                        color: Theme.of(context).colorScheme.secondary, 
                                      ),
                                    )
                                  ],
                                ),
                                Row( 
                                  children: [ 
                                    Text(
                                      '${NumberFormat.compact().format(userData['following'])} following',
                                      style: const TextStyle( 
                                        fontWeight: FontWeight.bold,
                                      ),   
                                    ),
                                    const SizedBox(width: 20,),
                                    Text(
                                      '${NumberFormat.compact().format(userData['followers'])} followers',
                                      style: const TextStyle( 
                                        fontWeight: FontWeight.bold,
                                      ),   
                                    ),
                                  ],
                                ),
                                const TabBar( 
                                  labelPadding: EdgeInsets.symmetric(horizontal: 15.0),
                                  indicatorPadding: EdgeInsets.only(bottom: 10, left: 0, right: 0),
                                  padding: EdgeInsets.zero,
                                  dividerHeight: 0.0,
                                  labelStyle: TextStyle( 
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  tabAlignment: TabAlignment.center,
                                  isScrollable: true,
                                  tabs: [
                                    Tab( 
                                      text: 'Posts',
                                    ),
                                    Tab( 
                                      text: 'Media',
                                    ),
                                    Tab( 
                                      text: 'Likes'
                                    ),
                                    Tab( 
                                      text: 'Communitites',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  body: TabBarView( 
                    children: [ 
                      ProfilePostsView(userId: widget.userId),
                      ProfileMediaView(userId: widget.userId),
                      ProfileLikesView(userId: widget.userId),
                      ProfileCommunititesView(userId: widget.userId),
                    ],
                  )
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}