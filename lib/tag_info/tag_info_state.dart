import 'package:meta/meta.dart';
import 'package:doggie_tag_list/models/order.dart';

class TagInfoState {
  final bool isLoading;
  final String error;
  final Order order;
  final bool authenticated;

  const TagInfoState({
    @required this.isLoading,
    @required this.error,
    @required this.order,
    @required this.authenticated
  });

  factory TagInfoState.initial() {
    return TagInfoState(
      isLoading: false,
      error: '',
      order: null,
      authenticated: true
    );
  }


  factory TagInfoState.loading() {
    return TagInfoState(
      isLoading: true,
      error: '',
      order: null,
      authenticated: true
    );
  }

  factory TagInfoState.failure(String error) {
    return TagInfoState(
      isLoading: false,
      error: '',
      order: null,
      authenticated: true
    );
  }

  factory TagInfoState.success(Order order) {
    return TagInfoState(
      isLoading: false,
      error: '',
      order: order,
      authenticated: true
    );
  }

  factory TagInfoState.unauthenticated() {
    return TagInfoState(
      isLoading: false,
      error: '',
      order: null,
      authenticated: false
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
      other is TagInfoState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          order == other.order;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      error.hashCode ^
      order.hashCode;

  @override
  String toString() =>
      'TagInfoState { isLoading: $isLoading, error: $error, order: $order }';
}