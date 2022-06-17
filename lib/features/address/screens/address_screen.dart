import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, required this.totalAmount});

  static const routeName = '/address';
  final String totalAmount;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final buildingController = TextEditingController();
  final areaController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();

  final addressFormKey = GlobalKey<FormState>();

  final paymentItems = <PaymentItem>[];

  void onApplyPayResult(Map<String, dynamic> res) {}

  void onGooglePayResult(Map<String, dynamic> res) {}

  @override
  void initState() {
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    buildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var address = context.watch<UserProvider>().user.address;
    const address = '10231';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          // ignore: use_decorated_box
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    // ignore: use_decorated_box
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 18,
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
              Form(
                key: addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      textEditingController: buildingController,
                      hintText: 'Flat, House No, Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textEditingController: areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textEditingController: pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textEditingController: cityController,
                      hintText: 'Town or City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              ApplePayButton(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(top: 50),
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                paymentConfigurationAsset: 'applepay.json',
                onPaymentResult: onApplyPayResult,
                paymentItems: paymentItems,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(height: 10),
              GooglePayButton(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(top: 15),
                type: GooglePayButtonType.buy,
                paymentConfigurationAsset: 'gpay.json',
                onPaymentResult: onGooglePayResult,
                paymentItems: paymentItems,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
