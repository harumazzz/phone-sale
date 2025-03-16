import 'package:equatable/equatable.dart';

import '../api/cart_api.dart';

class CartRepository extends Equatable {
  const CartRepository(this._api);

  final CartApi _api;

  @override
  List<Object?> get props => [_api];
}
