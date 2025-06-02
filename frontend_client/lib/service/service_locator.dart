import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../api/auth_api.dart';
import '../api/cart_api.dart';
import '../api/category_api.dart';
import '../api/customer_api.dart';
import '../api/discount_api.dart';
import '../api/order_api.dart';
import '../api/order_item_api.dart';
import '../api/payment_api.dart';
import '../api/product_api.dart';
import '../api/shipment_api.dart';
import '../api/wishlist_api.dart';
import '../interceptors/dio_interceptor.dart';
import '../repository/auth_repository.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/customer_repository.dart';
import '../repository/discount_repository.dart';
import '../repository/order_item_repository.dart';
import '../repository/order_repository.dart';
import '../repository/payment_repository.dart';
import '../repository/product_repository.dart';
import '../repository/shipment_repository.dart';
import '../repository/wishlist_repository.dart';

class ServiceLocator {
  const ServiceLocator._();
  static final GetIt _instance = GetIt.asNewInstance();

  static void register<T extends Object>(T value) {
    if (!_instance.isRegistered<T>()) {
      _instance.registerSingleton(value);
    }
  }

  static void registerService() {
    // Create Dio with base URL and interceptors
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:5133/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add global error interceptor
    dio.interceptors.add(DioErrorInterceptor());
    register<Dio>(dio);
    register<AuthRepository>(const AuthRepository(AuthApi()));
    register<CartRepository>(const CartRepository(CartApi()));
    register<DiscountRepository>(const DiscountRepository(DiscountApi()));
    register<CategoryRepository>(const CategoryRepository(CategoryApi()));
    register<CustomerRepository>(const CustomerRepository(CustomerApi()));
    register<OrderRepository>(const OrderRepository(OrderApi(), OrderItemApi(), ProductApi()));
    register<OrderItemRepository>(const OrderItemRepository(OrderItemApi()));
    register<PaymentRepository>(const PaymentRepository(PaymentApi()));
    register<ShipmentRepository>(const ShipmentRepository(ShipmentApi()));
    register<WishlistRepository>(const WishlistRepository(WishlistApi()));
    register<ProductRepository>(const ProductRepository(ProductApi()));
  }

  static T get<T extends Object>() {
    assert(_instance.isRegistered<T>(), '$T is not registered');
    return _instance.get<T>();
  }
}
