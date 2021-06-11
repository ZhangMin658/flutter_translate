import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IapEvent extends Equatable {
  const IapEvent();
}

class LoadIAPEvent extends IapEvent {
  @override
  List<Object> get props => null;
}

class BuysIAPEvent extends IapEvent {
  final ProductDetails productDetails;
  BuysIAPEvent(this.productDetails);
  @override
  List<Object> get props => [productDetails];
}

class PurchaseResultEvent extends IapEvent {
  final bool isSuccessed;
  PurchaseResultEvent(this.isSuccessed);
  @override
  List<Object> get props => [isSuccessed];
}

class RestorePurchaseEvent extends IapEvent {
  @override
  List<Object> get props => null;
}
