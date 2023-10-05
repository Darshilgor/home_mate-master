class PaymentReceiptModel {
  String orderID;
  String orderStatus;
  String serviceId;
  int quantity;
  double amount;
  double discount;
  double tax;
  String userID;
  DateTime paymentDate;
  String paymentMethod;

  PaymentReceiptModel({
    required this.orderID,
    required this.orderStatus,
    required this.serviceId,
    required this.discount,
    required this.quantity,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.tax,
    required this.userID,
  });

  factory PaymentReceiptModel.fromMap(Map<String, dynamic> map) =>
      PaymentReceiptModel(
        orderID: map['orderID'],
        orderStatus: map['orderStatus'],
        serviceId: map['serviceId'],
        discount: map['discount'],
        quantity: map['quantity'],
        amount: map['amount'],
        paymentDate: DateTime.tryParse(map['paymentDate'])!,
        paymentMethod: map['paymentMethod'],
        tax: map['tax'],
        userID: map['userID'],
      );

  Map<String, dynamic> toMap() => {
        "orderID": orderID,
        "orderStatus": orderStatus,
        "serviceId": serviceId,
        "discount": discount,
        "quantity": quantity,
        "amount": amount,
        "paymentDate": paymentDate.toIso8601String(),
        "paymentMethod": paymentMethod,
        "tax": tax,
        "userID": userID,
      };
}
