import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({required this.wishlistRepository})
    : super(const WishlistInitial()) {
    on<WishlistEvent>(_onLoad);
  }

  final WishlistRepository wishlistRepository;

  Future<void> _onLoad(WishlistEvent event, Emitter<WishlistState> emit) async {
    // TODO: implement event handler
  }
}
