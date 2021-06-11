import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../function/utils/my_iap.dart';
import '../bloc.dart';

class IapBloc extends Bloc<IapEvent, IapState> {
  Function(bool, String) purchaseResultCallback;

  @override
  IapState get initialState => InitialIapState();

  @override
  Stream<IapState> mapEventToState(
    IapEvent event,
  ) async* {
    if (event is LoadIAPEvent) {
      yield LoadingIAPState();
      if (MyIAP.iap.productDetails == null ||
          MyIAP.iap.productDetails.length <= 0) {
        await MyIAP.iap.initStoreInfo();
      }
      MyIAP.iap.purchaseResultCallback = purchaseResultCallback;
      if (MyIAP.iap.isAvailable && MyIAP.iap.productDetails.length > 0) {
        yield AvailbleIAPState(
            MyIAP.iap.productDetails, MyIAP.iap.percentagePrice);
      } else {
        yield UnavaibleIAPState();
      }
    }
    if (event is BuysIAPEvent) {
      yield BuyingIAPState();
      MyIAP.iap.buyProduct(event.productDetails);
    }

    if (event is PurchaseResultEvent) {
      if (event.isSuccessed) {
        yield BuySuccessIAPState();
      } else {
        if (MyIAP.iap.isAvailable && MyIAP.iap.productDetails.length > 0) {
          yield AvailbleIAPState(
              MyIAP.iap.productDetails, MyIAP.iap.percentagePrice);
        } else {
          yield UnavaibleIAPState();
        }
      }
    }

    if (event is RestorePurchaseEvent) {
      yield BuyingIAPState();
      bool isAvalible = await MyIAP.iap.isMySubscriptionAvalible();
      if (isAvalible) {
        yield BuySuccessIAPState();
      } else {
        yield UnavaibleIAPState();
      }
    }
  }
}
