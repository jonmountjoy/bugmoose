import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tuple/tuple.dart';

/// The main visual scaffold for my app, which holds the bottom navigation bar or
/// navigation rail, and the main content.
class MyScaffold extends StatefulWidget {
  MyScaffold({Key? key}) : super(key: key);

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> with RouteAware {
  static final isMacOS = !kIsWeb && Platform.isMacOS;
  static final iconLearn = Icon(Icons.school);
  late List<BottomNavigationBarItem> tabItems;
  late List<NavigationRailDestination> navigationItems;
  // state
  int selectedIndex = 0;
  List tabs = [];

  void buildItems({required bool showingRail}) {
    tabs = [
      Tuple3(Icon(Icons.show_chart), "Progress", Screen(which: "A")),
      if (showingRail) Tuple3(Icon(Icons.settings), "Prefs", Screen(which: "B"))
    ];
    tabItems = tabs
        .map((e) => BottomNavigationBarItem(icon: e.item1, label: e.item2))
        .toList();
    navigationItems = tabs
        .map((e) =>
            NavigationRailDestination(icon: e.item1, label: Text(e.item2)))
        .toList();
  }

  void _onTabTapped(int index) {
    setState(() {
      if (selectedIndex != index) {
        selectedIndex = index;
        // _sendCurrentTabToAnalytics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("MyScaffold: Build");
    return LayoutBuilder(builder: (context, constraints) {
      bool showTabBar =
          (constraints.maxHeight > constraints.maxWidth) && !isMacOS;
      bool showNavigationRail = !showTabBar;
      buildItems(showingRail: showNavigationRail);
      return Scaffold(
          body: Container(
            child: Row(children: [
              if (showNavigationRail)
                NavigationRail(
                  labelType: NavigationRailLabelType.selected,
                  destinations: navigationItems,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: _onTabTapped,
                ),
              if (showNavigationRail)
                const VerticalDivider(
                    thickness: 2, width: 2, endIndent: 0, indent: 0),
              Expanded(child: tabs[selectedIndex].item3)
            ]),
          ),
          bottomNavigationBar: !showTabBar
              ? null
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 0.2))),
                  child: BottomNavigationBar(
                    key: Key('navbar'),
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    items: tabItems,
                    currentIndex: selectedIndex,
                    onTap: _onTabTapped,
                    selectedItemColor:
                        Theme.of(context).textSelectionTheme.selectionColor,
                    // unselectedItemColor: Theme.of(context).unselectedWidgetColor,
                  ),
                ));
    });
  }

  @override
  void dispose() {
    // routeObserver.unsubscribe(this);
    super.dispose();
  }

  // @override
  // void didPush() {
  //   _sendCurrentTabToAnalytics();
  // }

  // @override
  // void didPopNext() {
  //   _sendCurrentTabToAnalytics();
  // }

  // void _sendCurrentTabToAnalytics() {
  //   // TODO
  //   // // print('SENDING tab${MainTabBar.tabs[selectedIndex].item2}');
  //   // routeObserver.analytics.setCurrentScreen(
  //   //   screenName: 'tab${MainTabBar.tabs[selectedIndex].item2}',
  //   // );
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // TODO: nullsafety - this broke when upgrading to nullsafety -removed for now.
  //   // routeObserver.subscribe(this, ModalRoute.of(context));
  // }
}

class Screen extends StatefulWidget {
  final String which;
  Screen({required this.which, Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.which),
    );
  }
}
