part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

final class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

final class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

final class WishlistLoaded extends WishlistState {
  const WishlistLoaded(this.wishlists);

  final List<WishlistResponse> wishlists;

  int get size => wishlists.length;

  WishlistResponse operator [](int index) => wishlists[index];

  @override
  List<Object?> get props => [wishlists];
}

final class WishlistError extends WishlistState {
  const WishlistError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
