import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shield/Contacts/Contacts.dart';
import 'package:shield/Screens/Home.dart';
import 'package:shield/Screens/Profile.dart';

class Home_Page extends StatefulWidget {
  final String Name;
  const Home_Page({Key? key, required this.Name}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    page = 0;
  }

  late PageController pageController;
  void navigationTapped(int _page) {
    pageController.jumpToPage(_page);
  }

  void pageChanged(int _page) {
    setState(() {
      page = _page;
    });
  }

  int page = 0;
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: pageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Home(Name: widget.Name),
          Contacts(Name: widget.Name),
          Profile(Name: widget.Name),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        border: const Border(),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: page == 0 ? Colors.green : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.contacts,
              color: page == 1 ? Colors.green : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: page == 2 ? Colors.green : Colors.grey,
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
