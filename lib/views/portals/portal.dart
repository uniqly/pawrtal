import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/posts/post_list_view.dart';

class PortalView extends ConsumerStatefulWidget {
  final PortalModel portal;

  const PortalView({super.key, required this.portal});

  @override
  ConsumerState<PortalView> createState() => _PortalViewState();
}

class _PortalViewState extends ConsumerState<PortalView> {
  late final UserModel _currUser;
  late final PortalModel _portal;

  @override 
  void initState() {
    super.initState();
    _portal = widget.portal;
    _currUser = ref.read(appUserProvider).value!;
  }

  Future<void> _toggleJoin() async {
    if (_portal.hasUser(_currUser)) {
      await _portal.removeUser(_currUser);
    } else {
      await _portal.addUser(_currUser);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(  
      color: Colors.white,
      child: SafeArea(  
        child: Scaffold( 
          body: NestedScrollView(  
            headerSliverBuilder: (context, _) => [ 
              const SliverAppBar( 
                scrolledUnderElevation: 0.0,
                backgroundColor: Colors.white,
                title: Text( 
                  'Subpawrtal',
                  style: TextStyle( 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                snap: true,
                floating: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Stack( 
                    alignment: Alignment.bottomCenter,
                    children: [  
                      Padding(
                        padding: const EdgeInsets.only(bottom: 64.0),
                        child: Container(  
                          height: 100,
                          decoration: BoxDecoration(  
                            color: Theme.of(context).colorScheme.surfaceContainerHigh,
                            image: DecorationImage(  
                              image: NetworkImage(_portal.banner),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(  
                        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                        child: Row(  
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [  
                            CircleAvatar(  
                              radius: 41, 
                              backgroundColor: Colors.white,
                              child: CircleAvatar(  
                                radius: 40, 
                                backgroundImage: NetworkImage(_portal.picture),
                              ),
                            ),
                            const SizedBox(width: 5.0,),
                            Column(  
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [  
                                Text(
                                  'p/${_portal.name}',
                                  style: TextStyle(  
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${NumberFormat.compact().format(_portal.memberCount)} members', 
                                  style: const TextStyle(  
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            TextButton( 
                              style: TextButton.styleFrom( 
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.surface,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: _toggleJoin,
                              child: Text(  
                                _portal.hasUser(_currUser) ? 'Joined' : 'Join',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
            body: PostListView(  
              postStream: _portal.posts,
              userInsteadOfPortal: true,
            )
          ),
        ),
      ),
    );
  }
}