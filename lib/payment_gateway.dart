import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGetway extends GetxController {
  late Razorpay _razorpay;

  @override
  void onInit() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handleError);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.onInit();
  }

  //! error
  void handleError(PaymentFailureResponse paymentFailureResponse) {
    Get.snackbar(
      "Error",
      paymentFailureResponse.message.toString(),
    );
  }

  //! success
  void handleSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    Get.snackbar(
      "Payment Syccess",
      paymentSuccessResponse.orderId.toString(),
    );
  }

  //! external wallet
  void handleExternalWallet(ExternalWalletResponse externalWalletResponse) {
    Get.snackbar(
      "Error",
      externalWalletResponse.walletName.toString(),
    );
  }

  void paymentOptions(
      int amount, String name, int contact, String email, String wallet) {
    var options = {
      'key': '',
      'amount': amount,
      'name': name,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        [wallet]
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }
}
