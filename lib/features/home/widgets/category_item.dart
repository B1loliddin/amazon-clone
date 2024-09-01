import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Column(
          children: [
            /// #image
            ClipOval(
              child: Image(
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                image: AssetImage(
                  GlobalVariables.categoryImages[index]['image']!,
                ),
              ),
            ),

            /// #title
            Text(
              GlobalVariables.categoryImages[index]['title']!,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
