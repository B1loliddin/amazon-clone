import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/profile/screens/profile_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  static const String routeName = '/custom-bottom-navigation-bar';

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final double _bottomNavigationBarItemWidth = 42;
  final double _bottomNavigationBarItemBorderWidth = 5;
  int _currentPage = 0;

  final _pages = [
    const HomeScreen(),
    const ProfileScreen(),
    const CartScreen(),
  ];

  void _updatePage(int page) => setState(() => _currentPage = page);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        currentIndex: _currentPage,
        backgroundColor: GlobalVariables.whiteColor,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        onTap: _updatePage,
        items: [
          /// #home
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

          /// #profile
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
                      Icons.person_outline,
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

          /// #cart
          BottomNavigationBarItem(
            label: '',
            icon: Badge(
              alignment: const Alignment(1.1, -0.8),
              backgroundColor: GlobalVariables.whiteColor,
              label: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Text(
                    userProvider.user.cart.length > 99
                        ? '99+'
                        : userProvider.user.cart.length.toString(),
                    style: const TextStyle(color: GlobalVariables.blackColor),
                  );
                },
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.shopping_cart_outlined,
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
        ],
      ),
    );
  }
}
