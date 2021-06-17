import 'package:flutter/material.dart';
import 'package:untitled/app/home/cupertino_home_scaffold.dart';
import 'package:untitled/app/home/edit_job_page.dart';
import 'package:untitled/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  Map<TabItem, WidgetBuilder> get widgetBuilders{
   return {
    TabItem.jobs: (_)=> EditJobPage(),
   TabItem.entries: (_) => Container(),
     TabItem.account: (_) => Container(color: Colors.indigoAccent,),
  };
}
  void _select(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }




}
