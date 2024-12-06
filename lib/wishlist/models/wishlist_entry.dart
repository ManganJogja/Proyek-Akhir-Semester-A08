import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
    String model;
    int pk;
    Fields fields;

    Wishlist({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
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
    DateTime? datePlan;
    String additionalNote;

    Fields({
        required this.user,
        required this.restaurant,
        required this.datePlan,
        required this.additionalNote,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        restaurant: json["restaurant"],
        datePlan: json["date_plan"] == null ? null : DateTime.parse(json["date_plan"]),
        additionalNote: json["additional_note"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "restaurant": restaurant,
        "date_plan": "${datePlan!.year.toString().padLeft(4, '0')}-${datePlan!.month.toString().padLeft(2, '0')}-${datePlan!.day.toString().padLeft(2, '0')}",
        "additional_note": additionalNote,
    };
}

class WishlistEntry {
    String namaResto;
    String rating;
    int rangeHarga;

    WishlistEntry({
        required this.namaResto,
        required this.rating,
        required this.rangeHarga,
    });
}
