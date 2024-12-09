import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
    String model;
    String pk;
    Fields fields;

    Wishlist({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        model: json["model"],
        pk: json["pk"].toString(),
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
    String namaResto;
    String rating;
    int rangeHarga;
    String alamat;

    Fields({
        required this.user,
        required this.restaurant,
        this.datePlan,
        required this.additionalNote,
        required this.namaResto,
        required this.rating,
        required this.rangeHarga,
        required this.alamat,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        restaurant: json["restaurant"],
        datePlan: json["date_plan"] == null ? null : DateTime.parse(json["date_plan"]),
        additionalNote: json["additional_note"] ?? "",
        namaResto: json["nama_resto"],
        rating: json["rating"],
        rangeHarga: json["range_harga"],
        alamat: json["alamat"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "restaurant": restaurant,
        "date_plan": datePlan?.toIso8601String(),
        "additional_note": additionalNote,
        "nama_resto": namaResto,
        "rating": rating,
        "range_harga": rangeHarga,
        "alamat": alamat,
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
