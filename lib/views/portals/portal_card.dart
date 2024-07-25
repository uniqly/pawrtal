import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/portals/portal.dart';

class PortalCard extends ConsumerStatefulWidget {
  final PortalModel portal;
  const PortalCard({super.key, required this.portal});

  @override
  ConsumerState<PortalCard> createState() => _PortalCardState();
}

class _PortalCardState extends ConsumerState<PortalCard> {
  late final UserModel _currUser;
  
  @override
  void initState() {
    super.initState();
    _currUser = ref.read(appUserProvider).value!;
  }

  Future<void> _toggleJoin() async {
    if (widget.portal.hasUser(_currUser)) {
      await widget.portal.removeUser(_currUser);
    } else {
      await widget.portal.addUser(_currUser);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    log('building: ${widget.portal.name}');
    return Padding(
      padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(25.0),
        onTap: () { 
          Navigator.push(context, MaterialPageRoute(builder: (context) => PortalView(portal: widget.portal)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
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
                        image: NetworkImage(widget.portal.banner),
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
                        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                        child: CircleAvatar(  
                          radius: 40, 
                          backgroundImage: NetworkImage(widget.portal.picture),
                        ),
                      ),
                      const SizedBox(width: 5.0,),
                      Column(  
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [  
                          Text(
                            'p/${widget.portal.name}',
                            style: TextStyle(  
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${NumberFormat.compact().format(widget.portal.memberCount)} members', 
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
                          widget.portal.hasUser(_currUser) ? 'Joined' : 'Join',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}