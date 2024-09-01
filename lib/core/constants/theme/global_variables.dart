import 'package:flutter/material.dart';

abstract class GlobalVariables {
  static const appBarGradient = LinearGradient(
    stops: [0.5, 1.0],
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
  );

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const greyBackgroundColor = Color(0xffebecee);
  static final selectedNavBarColor = Colors.cyan.shade800;
  static const unselectedNavBarColor = Colors.black87;
  static const blackColor = Colors.black;
  static const blackTwelveColor = Colors.black12;
  static const blackThirtyEightColor = Colors.black38;
  static const blackFiftyFourColor = Colors.black54;
  static const whiteColor = Colors.white;
  static final greyColor = Colors.black12.withOpacity(0.03);
  static const blueColor = Color(0xFF03A9F4);
  static const redColor = Colors.red;
  static final greyShade400Color = Colors.grey.shade400;
  static final blackOpacity02Color = Colors.black.withOpacity(0.2);
  static const buttonYellowColor = Color.fromRGBO(254, 216, 9, 1);

  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Mobiles',
      'image': 'assets/images/mobiles.jpeg',
    },
    {
      'title': 'Essentials',
      'image': 'assets/images/essentials.jpeg',
    },
    {
      'title': 'Appliances',
      'image': 'assets/images/appliances.jpeg',
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.jpeg',
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.jpeg',
    },
  ];
}
