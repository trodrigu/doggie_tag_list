class Order {
  String _dogName;
  String _phoneNumber;
  String _shippingAddress;
  String _contactNumber;
  String _wood;
  String _design;
  String _size;

  Order(this._dogName, this._phoneNumber, this._shippingAddress, this._contactNumber, this._wood, this._design, this._size);

  Order.map(dynamic obj) {
    this._dogName = obj["dog_name"];
    this._phoneNumber = obj["phone_number"];
    this._shippingAddress = obj["shipping_address"];
    this._contactNumber = obj["contact_number"];
    this._wood = obj["wood"];
    this._design = obj["design"];
    this._size = obj["size"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["dogName"] = _dogName;
    map["phoneNumber"] = _phoneNumber;
    map["shippingAddress"] = _shippingAddress;
    map["contactNumber"] = _contactNumber;
    map["wood"] = _wood;
    map["design"] = _design;
    map["size"] = _size;

    return map;
  }
}