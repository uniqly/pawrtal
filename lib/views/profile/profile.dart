import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/viewmodels/profile/profile_viewmodel.dart';
import 'package:pawrtal/views/profile/profile_media.dart';
import 'package:pawrtal/views/profile/profile_posts.dart';

class ProfileView extends ConsumerWidget {
  final String userId;
  const ProfileView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileViewModel = ref.watch(ProfileViewModelNotifierProvider(uid: userId));
    
    return profileViewModel.when( 
      loading: () => const CircularProgressIndicator(),
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
                          onPressed: () {},
                          icon: const Icon(Icons.messenger)
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu)
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Stack( 
                        children: [
                          SizedBox(
                            height: 374,
                            width: MediaQuery.of(context).size.width
                          ),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(userData['banner']),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            top: 100,
                            child: Padding( 
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column( 
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                          //ref.read(mainUserProvider.notifier).incrFollows();
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
                                        onPressed: () {
                                          //ref.read(mainUserProvider.notifier).incrFollows();
                                        },
                                        child: const Text(
                                          'Follow',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ), 
                                      ),
                                    ],
                                  ),
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
                                    '@${userData['handle']}',
                                    style: TextStyle( 
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.surfaceTint,
                                    ),
                                  ),
                                  Text(
                                    userData['bio'],
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
                                        userData['location'] ?? 'Unknown',
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
                          ),
                        ],
                      ),
                    ),
                  ],
                  body: TabBarView( 
                    children: [ 
                      ProfilePostsView(userId: userId),
                      ProfileMediaView(userId: userId),
                      const Text('likes'),
                      const Text('communitites'),
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