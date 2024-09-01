import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/common/widgets/custom_button.dart';
import 'package:amazon_clone/core/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/features/address/configurations/pay_configurations.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final String totalAmount;

  const AddressScreen({super.key, required this.totalAmount});

  static const String routeName = '/address-screen';

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // keys
  final _formKey = GlobalKey<FormState>();

  // controllers
  late final TextEditingController _flatBuildingController;
  late final TextEditingController _areaController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _cityController;

  // payment
  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = '';

  @override
  void initState() {
    super.initState();
    _initAllControllers();
    _setUpPaymentItems();
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  // functions
  void _initAllControllers() {
    _flatBuildingController = TextEditingController();
    _areaController = TextEditingController();
    _pincodeController = TextEditingController();
    _cityController = TextEditingController();
  }

  void _disposeAllControllers() {
    _flatBuildingController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
  }

  void _setUpPaymentItems() {
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  void _onApplePayResult(Map<String, dynamic> result) async {
    final userAddress = context.read<UserProvider>().user.address;

    if (userAddress.isEmpty) {
      await context.read<UserProvider>().saveUserAddress(
            context: context,
            address: addressToBeUsed,
          );
    }

    if (mounted) {
      context.read<UserProvider>().placeOrder(
            context: context,
            address: addressToBeUsed,
            totalSum: widget.totalAmount,
          );
    }
  }

  void _onGooglePayResult(Map<String, dynamic> result) async {
    final userAddress = context.read<UserProvider>().user.address;

    if (userAddress.isEmpty) {
      await context.read<UserProvider>().saveUserAddress(
            context: context,
            address: addressToBeUsed,
          );
      debugPrint('Save Complete');
    }

    if (mounted) {
      context.read<UserProvider>().placeOrder(
            context: context,
            address: addressToBeUsed,
            totalSum: widget.totalAmount,
          );
      debugPrint('Order Placed');
    }
  }

  void _onPayPressed(String address) {
    addressToBeUsed = '';

    bool isForm = _flatBuildingController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;

    if (isForm) {
      if (_formKey.currentState!.validate()) {
        addressToBeUsed =
            '${_flatBuildingController.text}, ${_areaController.text}, ${_cityController.text} - ${_pincodeController.text}';
      } else {
        showSnackBar(context, 'Fill out all the fields');
      }
    } else if (address.isNotEmpty) {
      addressToBeUsed = address;
    } else {
      showSnackBar(context, 'Error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;
    final address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
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
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),

              /// #address
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              address.isNotEmpty ? address : 'No Address',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

              /// #text fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// #flat building text field
                      CustomTextField(
                        controller: _flatBuildingController,
                        hintText: 'Flat, House no. Building',
                      ),
                      const SizedBox(height: 10),

                      /// #area text field
                      CustomTextField(
                        controller: _areaController,
                        hintText: 'Area, Street',
                      ),
                      const SizedBox(height: 10),

                      /// #pincode text field
                      CustomTextField(
                        controller: _pincodeController,
                        hintText: 'Pincode',
                      ),
                      const SizedBox(height: 20),

                      /// #city text field
                      CustomTextField(
                        controller: _cityController,
                        hintText: 'Town/City',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              /// #apply, google pay button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ApplePayButton(
                  height: 40,
                  width: MediaQuery.sizeOf(context).width,
                  paymentItems: paymentItems,
                  onPaymentResult: _onApplePayResult,
                  onPressed: () => _onPayPressed(address),
                  paymentConfiguration: PaymentConfiguration.fromJsonString(
                    PayConfigurations.defaultApplePay,
                  ),
                  loadingIndicator: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GooglePayButton(
                  height: RawGooglePayButton.defaultButtonHeight,
                  width: MediaQuery.sizeOf(context).width,
                  paymentItems: paymentItems,
                  onPaymentResult: _onGooglePayResult,
                  onPressed: () => _onPayPressed(address),
                  paymentConfiguration: PaymentConfiguration.fromJsonString(
                    PayConfigurations.defaultGooglePay,
                  ),
                  loadingIndicator: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
              SizedBox(height: 20),

              /// #
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomButton(
                  text: 'Place Order',
                  onPressed: () => _onApplePayResult({}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
