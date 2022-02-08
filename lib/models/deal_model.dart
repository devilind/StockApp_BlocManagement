import 'dart:convert';

DealModel dealModelFromJson(String str) => DealModel.fromJson(json.decode(str));

String dealModelToJson(DealModel data) => json.encode(data.toJson());

class DealModel {
  DealModel({
    required this.data,
  });

  List<Data> data;

  factory DealModel.fromJson(Map<String, dynamic> json) => DealModel(
        data: List<Data>.from(json["Data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Data {
  Data({
    required this.finCode,
    required this.clientName,
    required this.dealType,
    required this.quantity,
    required this.value,
    required this.tradePrice,
    required this.dealDate,
    required this.exchange,
  });

  String finCode;
  String clientName;
  String dealType;
  String quantity;
  String value;
  String tradePrice;
  DateTime dealDate;
  String exchange;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        finCode: json["FinCode"],
        clientName: json["ClientName"],
        dealType: json["DealType"],
        quantity: json["Quantity"],
        value: json["Value"],
        tradePrice: json["TradePrice"],
        dealDate: DateTime.parse(json["DealDate"]),
        exchange: json["Exchange"],
      );

  Map<String, dynamic> toJson() => {
        "FinCode": finCode,
        "ClientName": clientName,
        "DealType": dealType,
        "Quantity": quantity,
        "Value": value,
        "TradePrice": tradePrice,
        "DealDate": dealDate.toIso8601String(),
        "Exchange": exchange,
      };
}
