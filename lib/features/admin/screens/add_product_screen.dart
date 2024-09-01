import 'dart:io';

import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/common/widgets/custom_button.dart';
import 'package:amazon_clone/core/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/core/common/widgets/loader.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/providers/product_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  static const String routeName = '/add-product-screen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // keys
  final _formKey = GlobalKey<FormState>();

  // controllers
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  /// loader
  bool _isSelling = false;

  String _currentCategory = 'Mobiles';
  final _productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _initAllControllers();
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  // functions
  void _initAllControllers() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
  }

  void _disposeAllControllers() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
  }

  void _pickImages() async {
    final images = await pickImages();
    setState(() => _images = images);
  }

  void _sellProduct() async {
    setState(() => _isSelling = true);

    final price = !_priceController.text.contains('.')
        ? (int.parse(_priceController.text.trim())).toDouble()
        : double.parse(_priceController.text.trim());

    await context.read<ProductProvider>().sellProduct(
      context: context,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      quantity: int.parse(_quantityController.text.trim()),
      category: _currentCategory,
      images: _images,
      ratings: [],
    );

    setState(() => _isSelling = false);
  }

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.w500),
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
      body: Stack(
        children: [
          /// #main content
          Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// #product image selection
                  _images.isNotEmpty
                      ? CarouselSlider(
                          items: _images.map((image) {
                            return Builder(
                              builder: (context) => Image(
                                height: 200,
                                fit: BoxFit.cover,
                                image: FileImage(image),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 200,
                            viewportFraction: 1,
                            autoPlay: true,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: _pickImages,
                            child: DottedBorder(
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: SizedBox(
                                  height: 150,
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.folder_open, size: 40),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Select Product Images',
                                        style: TextStyle(
                                          color:
                                              GlobalVariables.greyShade400Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 30),

                  /// #name, description, price, quantity text fields
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Name',
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _descriptionController,
                            hintText: 'Description',
                            maxLines: 5,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _priceController,
                            hintText: 'Price',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _quantityController,
                            hintText: 'Quantity',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// #category selection
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: DropdownButton(
                        value: _currentCategory,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _productCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _currentCategory = value!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// #sell button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomButton(
                      text: 'Sell',
                      onPressed: _sellProduct,
                    ),
                  ),

                  /// #bottom space
                  SizedBox(height: phonePadding.bottom + 30)
                ],
              ),
            ),
          ),

          /// #loader
          if (_isSelling)
            const Center(
              child: Loader(),
            ),
        ],
      ),
    );
  }
}
