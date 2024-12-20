// To parse this JSON data, do
//
//     final orderTakeAwayEntry = orderTakeAwayEntryFromJson(jsonString);

import 'dart:convert';

List<OrderTakeAwayEntry> orderTakeAwayEntryFromJson(String str) => List<OrderTakeAwayEntry>.from(json.decode(str).map((x) => OrderTakeAwayEntry.fromJson(x)));

String orderTakeAwayEntryToJson(List<OrderTakeAwayEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderTakeAwayEntry {
    String model;
    String pk;
    Fields fields;

    OrderTakeAwayEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory OrderTakeAwayEntry.fromJson(Map<String, dynamic> json) => OrderTakeAwayEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String restaurant;
    int totalPrice;
    String pickupTime;
    DateTime orderTime;

    Fields({
        required this.user,
        required this.restaurant,
        required this.totalPrice,
        required this.pickupTime,
        required this.orderTime,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        restaurant: json["restaurant"],
        totalPrice: json["total_price"],
        pickupTime: json["pickup_time"],
        orderTime: DateTime.parse(json["order_time"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "restaurant": restaurant,
        "total_price": totalPrice,
        "pickup_time": pickupTime,
        "order_time": orderTime.toIso8601String(),
    };
}
