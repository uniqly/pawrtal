import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/portals/portal_model.dart';
import 'package:pawrtal/views/portals/portal.dart';

class PortalsList extends StatelessWidget {
  const PortalsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Subpawrtals',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('portals').orderBy('memberCount', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final portalsDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: portalsDocs.length,
            itemBuilder: (context, index) {
              var portalDoc = portalsDocs[index];
              return FutureBuilder<PortalModel>(
                future: PortalModel.portalFromSnapshot(portalDoc as DocumentSnapshot<Map<String, dynamic>>),
                builder: (context, portalSnapshot) {
                  if (!portalSnapshot.hasData) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  var portal = portalSnapshot.data!;
                  return ListTile(
                    leading: portal.picture.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(portal.picture),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.image),
                          ),
                    title: Text('p/${portal.name}'),
                    subtitle: Text('${portal.memberCount} members'),
                    onTap: () { 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PortalView(portal: portal)));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}