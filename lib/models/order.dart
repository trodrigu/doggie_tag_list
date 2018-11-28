class Order {
  String dogName;
  String phoneNumber;
  String shippingAddress;
  String contactNumber;
  String wood;
  String design;
  String size;

  Order(this.dogName, this.phoneNumber, this.shippingAddress, this.contactNumber, this.wood, this.design, this.size);

  Order.map(dynamic obj) {
    this.dogName = obj["dog_name"];
    this.phoneNumber = obj["phone_number"];
    this.shippingAddress = obj["shipping_address"];
    this.contactNumber = obj["contact_number"];
    this.wood = obj["wood"];
    this.design = obj["design"];
    this.size = obj["size"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["dogName"] = dogName;
    map["phoneNumber"] = phoneNumber;
    map["shippingAddress"] = shippingAddress;
    map["contactNumber"] = contactNumber;
    map["wood"] = wood;
    map["design"] = design;
    map["size"] = size;

    return map;
  }
}