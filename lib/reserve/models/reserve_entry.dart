// To parse this JSON data, do
//
//     final reserveEntry = reserveEntryFromJson(jsonString);

import 'dart:convert';

List<ReserveEntry> reserveEntryFromJson(String str) => List<ReserveEntry>.from(json.decode(str).map((x) => ReserveEntry.fromJson(x)));

String reserveEntryToJson(List<ReserveEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReserveEntry {
    String model;
    String pk;
    Fields fields;

    ReserveEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ReserveEntry.fromJson(Map<String, dynamic> json) => ReserveEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };

  static map(Map<String, dynamic> Function(dynamic entry) param0) {}
}

class Fields {
    int user;
    String resto;
    String name;
    DateTime date;
    String time;
    int guestQuantity;
    String email;
    int phone;
    String? notes;

    Fields({
        required this.user,
        required this.resto,
        required this.name,
        required this.date,
        required this.time,
        required this.guestQuantity,
        required this.email,
        required this.phone,
        this.notes,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        resto: json["resto"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        guestQuantity: json["guest_quantity"],
        email: json["email"],
        phone: json["phone"],
        notes: json["notes"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "resto": resto,
        "name": name,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "guest_quantity": guestQuantity,
        "email": email,
        "phone": phone,
        "notes": notes,
    };
}
