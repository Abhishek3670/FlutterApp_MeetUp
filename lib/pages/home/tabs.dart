import 'package:flutter/material.dart';

import 'package:mysecondapp/pages/home/tabs/accountPage.dart';
import 'package:mysecondapp/pages/home/tabs/chatRoom.dart';
import 'package:mysecondapp/pages/home/tabs/sporti_list.dart';

class TabPages extends StatefulWidget {
  TabPages({Key? key}) : super(key: key);

  @override
  _TabPagesState createState() => _TabPagesState();
}

class _TabPagesState extends State<TabPages> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  elevation: 1.0,
                  backgroundColor: Colors.white,
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TabBar(
                        indicator: BoxDecoration(color: Colors.transparent),
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.deepPurple,
                        tabs: [
                          Tab(icon: Icon(Icons.account_box)),
                          Tab(icon: Icon(Icons.person_search)
//                      child: customSwitch(select: true),
                              ),
                          Tab(icon: Icon(Icons.chat_bubble)),
                        ],
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  //  controller: _tabController,
                  children: [
                    AccountTab(),
                    SportiList(),
                    ChatRoom(),
                  ],
                ))));
  }
}
