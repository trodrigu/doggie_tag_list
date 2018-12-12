import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:doggie_tag_list/tag_info/tag_info.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'package:doggie_tag_list/rest_ds.dart';

class TagInfoBloc extends Bloc<TagInfoEvent, TagInfoState> {
  TagInfoState get initialState => TagInfoState.initial();

  Order order;

  void onLogout() {
    dispatch(LoggedOut());
  }

  void onSubmitPressed({Order order}) {
    dispatch(
      TagInfoButtonPressed(order: order)
    );
  }

  @override
  Stream<TagInfoState> mapEventToState(
    TagInfoState state,
    TagInfoEvent event
  ) async* {
    if (event is TagInfoButtonPressed) {
      yield TagInfoState.loading();
      _createOrder(event.order);
      yield TagInfoState.success(event.order);

      /// maybe do something with snack?
      try {
      } catch (error) {
        yield TagInfoState.failure(error.toString());
      }
    }

    if (event is TagSubmitted) {
      yield TagInfoState.initial();
    }

    if (event is LoggedOut) {
      yield TagInfoState.unauthenticated();
    }
  }

  _createOrder(Order order) {
    RestDatasource api = new RestDatasource();
    api.createOrder(order.dogName, order.phoneNumber, order.shippingAddress, order.contactNumber, order.wood, order.design, order.size);//.then((Order order) {
    // onOrderSuccess();
    // }).catchError((Exception error) => onOrderError(error.toString(), context));
  }

  void onSnackBarShown() {
    dispatch(TagSubmitted());
  }

}