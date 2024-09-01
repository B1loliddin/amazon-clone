import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages.map((image) {
        return Builder(
          builder: (context) => Image(
            height: 200,
            fit: BoxFit.cover,
            image: NetworkImage(image),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1,
        autoPlay: true,
      ),
    );
  }
}
