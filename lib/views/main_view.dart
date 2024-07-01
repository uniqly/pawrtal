import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:pawrtal/views/auth/authenticate.dart';
import 'package:pawrtal/views/create/create.dart';
import 'package:pawrtal/views/menu_view.dart';
import 'package:pawrtal/views/profile/profile.dart';

import 'home/home.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

enum PageTab { home, profile }

class _MainViewState extends ConsumerState<MainView> {
  var currTab = PageTab.home;
  var pageIndex = 0;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final auth = ref.read(appUserProvider.future);
      final user = await auth;
      if (user == null && mounted) {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Authenticate()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserProvider);
    return user.when( 
      loading: () => const Loading(),
      error: (err, stack) { 
        log('$stack');
        return Text('error: $err');
      },
      data: (mainUser) { 
        log('$mainUser');
        return mainUser != null ? Scaffold( 
          body: currTab == PageTab.home ? const HomeView() : ProfileView(userId: mainUser.uid),
          bottomNavigationBar: NavigationBar( 
            height: 54,
            selectedIndex: pageIndex,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            indicatorColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
            onDestinationSelected: (index) async {
              setState(() {
                pageIndex = index;
              });
              switch (index) {
                case 0: {
                  currTab = PageTab.home;
                }
                case 1: {
                  await Navigator.push(context, MaterialPageRoute( 
                    builder: (context) => const CreateView(),
                  ));
                }
                case 2: {
                  currTab = PageTab.profile;
                }
                case 3:
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuView()),
                  );
              }
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              NavigationDestination( 
                icon: currTab == PageTab.home ? const Icon(
                  Icons.home,
                  size: 28,
                ) : const  Icon(
                  Icons.home_outlined,
                  size: 28,
                ),
                label: '',
              ),
              const NavigationDestination( 
                icon: Icon(
                  Icons.add_rounded,
                  size: 28,
                ),
                label: '',
              ),
              NavigationDestination( 
                icon: CircleAvatar(
                  backgroundColor: currTab == PageTab.profile ? Colors.pinkAccent : Colors.transparent,
                  radius: 22,
                  child: CircleAvatar( 
                    backgroundImage: NetworkImage(mainUser.pfp!),
                    radius: 20,
                  ),
                ),
                label: '',
              ),
              const NavigationDestination(
                icon: Icon(
                  Icons.menu,
                  size: 28,
                ),
                selectedIcon: Icon(
                  Icons.menu,
                  size: 28,
                ),
                label: 'Menu',
              ),
            ],
          ),
        ) : const Loading();
      }
    );
  }
}