import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/portals/portal_model.dart';

class PortalsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: const Text('Pawrtals'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('portals').snapshots(),
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
                    leading: portal.picture != null && portal.picture!.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(portal.picture!),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.image),
                          ),
                    title: Text(portal.name ?? 'No Name'),
                    subtitle: Text('${portal.memberCount ?? 0} members'),
                    onTap: () {},
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