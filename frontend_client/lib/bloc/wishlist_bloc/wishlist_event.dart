part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

final class WishlistFetch extends WishlistEvent {
  const WishlistFetch({required this.customerId});

  final String customerId;

  @override
  List<Object?> get props => [customerId];
}

final class WishlistAdd extends WishlistEvent {
  const WishlistAdd({required this.customerId, required this.productId});

  final String customerId;
  final int productId;

  @override
  List<Object?> get props => [customerId, productId];
}

final class WishlistRemove extends WishlistEvent {
  const WishlistRemove({required this.wishlistId});

  final int wishlistId;

  @override
  List<Object?> get props => [wishlistId];
}

final class WishlistClear extends WishlistEvent {
  const WishlistClear();
}
