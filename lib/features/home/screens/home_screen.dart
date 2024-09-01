import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/features/home/screens/category_deals_screen.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/home/widgets/carousel_image.dart';
import 'package:amazon_clone/features/home/widgets/category_item.dart';
import 'package:amazon_clone/features/home/widgets/deal_of_day_item.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;

    // functions
    void navigateToCategoryDealsScreen(String category) {
      Navigator.pushNamed(
        context,
        CategoryDealsScreen.routeName,
        arguments: category,
      );
    }

    void navigateToSearchScreen(String searchQuery) {
      Navigator.pushNamed(
        context,
        SearchScreen.routeName,
        arguments: searchQuery,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            height: 40,
            child: TextFormField(
              onFieldSubmitted: navigateToSearchScreen,
              decoration: const InputDecoration(
                filled: true,
                fillColor: GlobalVariables.whiteColor,
                hintText: 'Search Amazon.com',
                prefixIcon: Icon(Icons.search),
                hintStyle: TextStyle(
                  color: GlobalVariables.blackFiftyFourColor,
                ),
                contentPadding: EdgeInsets.only(top: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GlobalVariables.blackTwelveColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GlobalVariables.blackThirtyEightColor,
                  ),
                ),
              ),
            ),
          ),
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
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width, 10),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
            child: SizedBox(
              height: 10,
              width: MediaQuery.sizeOf(context).width,
            ),
          ),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// #address box
              const AddressBox(),
              const SizedBox(height: 10),

              /// #categories
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: GlobalVariables.categoryImages.length,
                  itemBuilder: (context, index) {
                    return CategoryItem(
                      index: index,
                      onTap: () => navigateToCategoryDealsScreen(
                        GlobalVariables.categoryImages[index]['title']!,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 30),
                ),
              ),
              const SizedBox(height: 20),

              /// #carousel image
              const CarouselImage(),
              const SizedBox(height: 20),

              /// #deal of the day text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Deal of the day',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// #deal of the day
              const DealOfDayItem(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
