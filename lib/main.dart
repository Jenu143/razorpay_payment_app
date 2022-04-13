import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payment_razorpay/payment_gateway.dart';
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(
    const Home(),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Razorpay razorpay;
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFocusController = FocusNode();
  var msg;

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () => textFocusController.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Razor Pay"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    focusNode: textFocusController,
                    cursorRadius: Radius.zero,
                    textAlign: TextAlign.center,
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: "Amount",
                    ),
                    style: const TextStyle(fontSize: 35.0),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: RaisedButton(
                    color: Colors.deepPurple,
                    child: const Text(
                      "Pay",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    onPressed: () {
                      openCheckout();
                    },
                  ),
                ),
                // SizedBox(
                //   height: 40,
                //   child: GetBuilder<PaymentGetway>(
                //     init: PaymentGetway(),
                //     builder: (v) {
                //       return GestureDetector(
                //         onTap: () {
                //           v.paymentOptions(
                //             10,
                //             "Jenis",
                //             9574028300,
                //             "radadiyajenis2001@gmail.com",
                //             "GooglePay",
                //           );
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             color: Colors.red,
                //           ),
                //           width: 130,
                //           child: const Center(
                //             child: Text(
                //               "Payment Now",
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 16,
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_ghelYUSPZFfp14",
      "amount": num.parse(textEditingController.text) *
          100, // Convert Paisa to Rupees
      "name": "Test Payment By Radadiya",
      "description": "This is a Test Payment",
      "timeout": "180",
      "theme.color": "#03be03",
      "currency": "INR",
      "prefill": {
        "contact": "9574028300",
        "email": "radadiyajenis2001@gmail.com"
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("Pament success");
    msg = "SUCCESS: " + response.paymentId!;
    showToast(msg);
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    msg = "ERROR: " +
        response.code.toString() +
        " - " +
        jsonDecode(response.message!)['error']['description'];
    showToast(msg);
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    msg = "EXTERNAL_WALLET: " + response.walletName!;
    showToast(msg);
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.withOpacity(0.1),
      textColor: Colors.black54,
    );
  }
}
