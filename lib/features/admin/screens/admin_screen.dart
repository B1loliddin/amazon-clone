import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/orders_screen.dart';
import 'package:amazon_clone/features/admin/screens/posts_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // constants
  final double _bottomNavigationBarItemWidth = 42;
  final double _bottomNavigationBarItemBorderWidth = 5;

  // current page index
  int _currentPage = 0;

  // pages
  final _pages = [
    const PostsScreen(),
    Center(child: Text('Analytics Screen')),
    OrdersScreen(),
  ];

  // functions
  void _updatePage(int page) => setState(() => _currentPage = page);

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;

    return Scaffold(
      body: _pages[_currentPage],
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image(
                width: 120,
                height: 45,
                color: GlobalVariables.blackColor,
                image: AssetImage('assets/images/amazon_in.png'),
              ),
            ),
            Text(
              'Admin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        flexibleSpace: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
          child: SizedBox(
            height: phonePadding.top + 56,
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        currentIndex: _currentPage,
        backgroundColor: GlobalVariables.whiteColor,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        onTap: _updatePage,
        items: [
          /// #costs
          BottomNavigationBarItem(
            label: '',
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: _bottomNavigationBarItemBorderWidth,
                    color: _currentPage == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.whiteColor,
                  ),
                ),
              ),
              child: SizedBox(
                width: _bottomNavigationBarItemWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.home_outlined,
                      size: 28,
                      key: ValueKey<int>(_currentPage),
                      color: _currentPage == 0
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.unselectedNavBarColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// #analytics
          BottomNavigationBarItem(
            label: '',
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: _bottomNavigationBarItemBorderWidth,
                    color: _currentPage == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.whiteColor,
                  ),
                ),
              ),
              child: SizedBox(
                width: _bottomNavigationBarItemWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.analytics_outlined,
                      size: 28,
                      key: ValueKey<int>(_currentPage),
                      color: _currentPage == 1
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.unselectedNavBarColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// #orders
          BottomNavigationBarItem(
            label: '',
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: _bottomNavigationBarItemBorderWidth,
                    color: _currentPage == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.whiteColor,
                  ),
                ),
              ),
              child: SizedBox(
                width: _bottomNavigationBarItemWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.all_inbox_outlined,
                      size: 28,
                      key: ValueKey<int>(_currentPage),
                      color: _currentPage == 2
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.unselectedNavBarColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
