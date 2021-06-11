import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IapState extends Equatable {
  const IapState();
}

class InitialIapState extends IapState {
  @override
  List<Object> get props => [];
}

class LoadingIAPState extends IapState {
  @override
  List<Object> get props => null;
}

class BuyingIAPState extends IapState {
  @override
  List<Object> get props => null;
}

class AvailbleIAPState extends IapState {
  final List<ProductDetails> productDetails;
  final String percentagePrice;

  AvailbleIAPState(this.productDetails, this.percentagePrice);
  @override
  List<Object> get props => [productDetails, percentagePrice];
}

class UnavaibleIAPState extends IapState {
  @override
  List<Object> get props => null;
}

class BuySuccessIAPState extends IapState {
  @override
  List<Object> get props => null;
}
