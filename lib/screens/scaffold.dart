// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fosdem/utils/style.dart';
import 'package:fosdem/utils//utils.dart';
import 'package:fosdem/widgets/fosdem_app_bar.dart';


//import '../routing.dart';
//import 'scaffold_body.dart';

/// The enum for scaffold tab.
enum ScaffoldTab {eventlist, favoriteslist, tracklist, conferencelist, settings }

class FosdemScaffold extends StatelessWidget {
  const FosdemScaffold({
    required this.selectedTab,
    required this.child,
    Key? key,
  }) : super(key: key);

  final ScaffoldTab selectedTab;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final routeState = GoRouter.of(context).location;
    final selectedIndex = _getSelectedIndex(routeState);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: AppBar().preferredSize.height),
            child: child,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FosdemAppBar(capitalize(routeState.replaceFirst('/', ''))),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex, //New
        onTap: (int value) => _onItemTapped(value, context),
        selectedItemColor: bottomNavigationBarSelectedItemColor,
        unselectedItemColor: bottomNavigationBarUnselectedItemColor,
        items: const [
          BottomNavigationBarItem(
            label: 'Events',
            icon: Icon(Icons.chat_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'Tracks',
            icon: Icon(Icons.add_road),
          ),
          BottomNavigationBarItem(
            label: 'Years',
            icon: Icon(Icons.view_agenda),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate.startsWith('/eventlist')) return 0;
    if (pathTemplate == '/favoriteslist') return 1;
    if (pathTemplate == '/tracklist') return 2;
    if (pathTemplate == '/conferencelist') return 3;
    if (pathTemplate == '/settings') return 4;
    return 0;
  }

  void _onItemTapped(int value, BuildContext context) {
    switch (ScaffoldTab.values[value]) {
      case ScaffoldTab.eventlist:
        context.go('/eventlist');
        break;
      case ScaffoldTab.favoriteslist:
        context.go('/favoriteslist');
        break;
      case ScaffoldTab.tracklist:
        context.go('/tracklist');
        break;
      case ScaffoldTab.conferencelist:
        context.go('/conferencelist');
        break;
      case ScaffoldTab.settings:
        context.go('/settings');
        break;
    }
  }
}
