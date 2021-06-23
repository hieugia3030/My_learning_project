import 'package:flutter/material.dart';
import 'package:untitled/app/home/account/account_page.dart';
import 'package:untitled/app/home/cupertino_home_scaffold.dart';
import 'package:untitled/app/home/edit_job_page.dart';
import 'package:untitled/app/home/entries/entries_page.dart';
import 'package:untitled/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map <TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders{
   return {
    TabItem.jobs: (_)=> EditJobPage(),
   TabItem.entries: (context) => EntriesPage.create(context),
     TabItem.account: (_) => AccountPage(),
  };
}
  void _select(TabItem tabItem) {
    if(_currentTab == tabItem){
       navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }else{
      setState(() {
        _currentTab = tabItem;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => ! await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        navigatorKeys: navigatorKeys,
          currentTab: _currentTab,
          onSelectedTab: _select,
        widgetBuilders: widgetBuilders,
      ),
    );
  }
}
