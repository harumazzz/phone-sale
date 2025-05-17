import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/request/wishlist_request.dart';
import '../../model/response/wishlist_response.dart';
import '../../repository/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({required this.wishlistRepository}) : super(const WishlistInitial()) {
    on<WishlistFetch>(_onFetch);
    on<WishlistAdd>(_onAdd);
    on<WishlistRemove>(_onRemove);
    on<WishlistClear>(_onClear);
  }

  final WishlistRepository wishlistRepository;

  Future<void> _onFetch(WishlistFetch event, Emitter<WishlistState> emit) async {
    try {
      emit(const WishlistLoading());

      final wishlists = await wishlistRepository.getWishlists(customerId: event.customerId);
      emit(WishlistLoaded(wishlists));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onAdd(WishlistAdd event, Emitter<WishlistState> emit) async {
    try {
      emit(const WishlistLoading());

      final request = WishlistRequest(customerId: event.customerId, productId: event.productId);

      await wishlistRepository.addWishlist(request: request);

      // Reload the wishlists
      final wishlists = await wishlistRepository.getWishlists(customerId: event.customerId);
      emit(WishlistLoaded(wishlists));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onRemove(WishlistRemove event, Emitter<WishlistState> emit) async {
    try {
      if (state is WishlistLoaded) {
        final currentState = state as WishlistLoaded;
        emit(const WishlistLoading());

        await wishlistRepository.deleteWishlist(id: event.wishlistId);

        // Filter out the removed wishlist
        final updatedWishlists =
            currentState.wishlists.where((wishlist) => wishlist.wishlistId != event.wishlistId).toList();

        emit(WishlistLoaded(updatedWishlists));
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> _onClear(WishlistClear event, Emitter<WishlistState> emit) async {
    emit(const WishlistInitial());
  }
}
