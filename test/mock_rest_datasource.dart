import 'package:doggie_tag_list/rest_ds.dart';
import 'package:doggie_tag_list/models/order.dart';

class MockRestDatasource implements RestDatasource {

  Future<String> login(String email, String password) async {
    return 'token';
  }

  Future<Order> createOrder(String _dogName, String _phoneNumber, String _shippingAddress, String _contactNumber, String _wood, String _design, String _size) async {
    return new Order('','','','','','','',);
  }

  Future<List<Order>> getOrders() async {
    return [new Order('','','','','','','',)];
  }
}