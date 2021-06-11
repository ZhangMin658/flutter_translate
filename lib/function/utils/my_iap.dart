import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';

class MyIAP {
  static final MyIAP _myIAP = MyIAP();
  static MyIAP get iap => _myIAP;

  StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  List<String> _notFoundIds = [];
  List<ProductDetails> productDetails = [];
  List<PurchaseDetails> purchases = [];
  bool isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError = null;
  String percentagePrice = "";
  //for test premium
  bool isPremiumUserAvalible = true;

  Function(bool, String) purchaseResultCallback;

  MyIAP() {
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    //initStoreInfo();
  }

  ///IAP implement
  ///
  Future<void> initStoreInfo() async {
    final bool isAvai = await _connection.isAvailable();
    if (!isAvai) {
      //setState(() {
      isAvailable = isAvai;
      productDetails = [];
      purchases = [];
      _notFoundIds = [];
      _purchasePending = false;
      _loading = false;
      //});
      return;
    }

    ProductDetailsResponse productDetailResponse = await _connection
        .queryProductDetails(DefaultValue.IAP_PRODUCE_IDS.toSet());
    if (productDetailResponse.error != null) {
      //setState(() {
      _queryProductError = productDetailResponse.error.message;
      isAvailable = isAvai;
      productDetails = productDetailResponse.productDetails;
      purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
      //});
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      //setState(() {
      _queryProductError = null;
      isAvailable = isAvai;
      productDetails = productDetailResponse.productDetails;
      purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
      //});
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }

    //setState(() {
    isAvailable = isAvai;
    productDetails = productDetailResponse.productDetails;
    purchases = verifiedPurchases;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _purchasePending = false;
    _loading = false;
    percentagePrice = productDetails
        .firstWhere((pack) => pack.id == DefaultValue.PERCENTAGE_PRODUCE_IAP)
        .price;
    //});
  }

  void buyProduct(ProductDetails productDetails) {
    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
        sandboxTesting: false);
    _connection.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    if (DefaultValue.IAP_PRODUCE_IDS.contains(purchaseDetails.productID)) {
      //await ConsumableStore.save(purchaseDetails.purchaseID);
      //List<String> consumables = await ConsumableStore.load();
      //setState(() {
      _purchasePending = false;
      isPremiumUserAvalible = true;
      if (purchaseResultCallback != null) {
        purchaseResultCallback(true, "Purchase succesfull!");
      }
      //_consumables = consumables;
      //});
    } else {
      //setState(() {
      purchases.add(purchaseDetails);
      _purchasePending = false;
      if (purchaseResultCallback != null) {
        purchaseResultCallback(false, "Product id not found!");
      }
      // });
    }
  }

  void _handleError(IAPError error) {
    //setState(() {
    _purchasePending = false;
    if (purchaseResultCallback != null) {
      purchaseResultCallback(false, "Have some error in purchase!");
    }
    //});
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    if (purchaseResultCallback != null) {
      purchaseResultCallback(false, "Invalid purchase!");
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (Platform.isIOS) {
          InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
        } else if (Platform.isAndroid) {
          // if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          //  InAppPurchaseConnection.instance.consumePurchase(purchaseDetails);
          // }
        }
      }
    });
  }

  Future<bool> isSubscriptionStatusAvalible(String sku,
      [Duration duration = const Duration(days: 30),
      Duration grace = const Duration(days: 0)]) async {
    for (var purchase in purchases) {
      print(purchase.toString());
      DateTime transactionDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(purchase.transactionDate));
      Duration difference = DateTime.now().difference(transactionDate);
      if (difference.inMinutes <= (duration + grace).inMinutes &&
          purchase.productID == sku) return true;
    }
    return false;
  }

  Future<bool> isMySubscriptionAvalible() async {
    bool isAvalible = false;
    int idx = 0;
    DefaultValue.IAP_PRODUCE_IDS.forEach((produceID) async {
      isAvalible = await isSubscriptionStatusAvalible(
          produceID, DefaultValue.PACK_DURATION[idx]);
      if (isAvalible) {
        isPremiumUserAvalible = isAvalible;
        return isAvalible;
      }
    });
    return isAvalible;
  }
}
