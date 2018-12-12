import 'package:meta/meta.dart';
import 'package:doggie_tag_list/models/order.dart';

class OrdersState {
  final bool isLoading;
  final String error;
  final String token;
  final Order order;

  const OrdersState({
    @required this.isLoading,
    @required this.error,
    @required this.token,
    @required this.order,
  });

  factory OrdersState.initial() {
    return OrdersState(
      isLoading: false,
      error: '',
      token: '',
      order: null
    );
  }

  factory OrdersState.loading() {
    return OrdersState(
      isLoading: true,
      error: '',
      token: '',
      order: null
    );
  }

  factory OrdersState.showSnack(Order order) {
    return OrdersState(
      isLoading: true,
      error: '',
      token: '',
      order: order
    );
  }

  factory OrdersState.failure(String error) {
    return OrdersState(
      isLoading: false,
      error: error,
      token: '',
      order: null
    );
  }

  factory OrdersState.success(Order order) {
    return OrdersState(
      isLoading: false,
      error: '',
      token: '',
      order: order
    );
  }

  @override
  bool operator ==(
    Object other,
  ) =>
      identical(
        this,
        other,
      ) ||
      other is OrdersState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          token == other.token;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      error.hashCode ^
      token.hashCode;

  @override
  String toString() =>
      'OrdersState { isLoading: $isLoading, error: $error, token: $token }';
}
