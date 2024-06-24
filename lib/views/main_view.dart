import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/services/auth.dart';
import 'package:pawrtal/shared/loading.dart';
import 'package:pawrtal/test/test_user.dart';
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

enum PageTab { home, profile, none }

class _MainViewState extends ConsumerState<MainView> {
  var currTab = PageTab.home;
  var pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
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
    //TODO: add state for user and posts
    return user.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        log('Error: $err\nStack: $stack');
        return Text('error: $err');
      },
      data: (mainUser) {
        log('User data: $mainUser');
        return mainUser != null
            ? Scaffold(
                body: currTab == PageTab.home
                    ? const HomeView()
                    : currTab == PageTab.profile
                        ? ProfileView(userId: mainUser.uid)
                        : Container(),
                bottomNavigationBar: NavigationBar(
                  height: 54,
                  selectedIndex: pageIndex,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  indicatorColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll<Color>(
                      Colors.transparent),
                  onDestinationSelected: (index) async {
                    setState(() {
                      pageIndex = index;
                    });
                    switch (index) {
                      case 0:
                        setState(() {
                          currTab = PageTab.home;
                        });
                        break;
                      case 1:
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateView()),
                        );
                        break;
                      case 2:
                        setState(() {
                          currTab = PageTab.profile;
                        });
                        break;
                      case 3:
                        setState(() {
                          currTab = PageTab.none;
                        });
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MenuView()),
                        );
                        break;
                    }
                  },
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  destinations: [
                    const NavigationDestination(
                      icon: Icon(
                        Icons.home_outlined,
                        size: 28,
                      ),
                      selectedIcon: Icon(
                        Icons.home,
                        size: 28,
                      ),
                      label: '',
                    ),
                    const NavigationDestination(
                      icon: Icon(
                        Icons.add_rounded,
                        size: 28,
                      ),
                      selectedIcon: Icon(
                        Icons.add_rounded,
                        size: 32,
                      ),
                      label: '',
                    ),
                    NavigationDestination(
                      icon: CircleAvatar(
                        backgroundColor:
                            pageIndex == 2 ? Colors.pinkAccent : Colors.transparent,
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
              )
            : const Loading();
      },
    );
  }
}