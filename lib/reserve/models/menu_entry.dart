// To parse this JSON data, do
//
//     final menuEntry = menuEntryFromJson(jsonString);

import 'dart:convert';

List<MenuEntry> menuEntryFromJson(String str) => List<MenuEntry>.from(json.decode(str).map((x) => MenuEntry.fromJson(x)));

String menuEntryToJson(List<MenuEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuEntry {
    Model model;
    String pk;
    Fields fields;

    MenuEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MenuEntry.fromJson(Map<String, dynamic> json) => MenuEntry(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String namaMenu;
    String deskripsi;
    String imageUrl;
    List<String> restaurants;

    Fields({
        required this.namaMenu,
        required this.deskripsi,
        required this.imageUrl,
        required this.restaurants,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaMenu: json["nama_menu"],
        deskripsi: json["deskripsi"],
        imageUrl: json["image_url"],
        restaurants: List<String>.from(json["restaurants"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "nama_menu": namaMenu,
        "deskripsi": deskripsi,
        "image_url": imageUrl,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x)),
    };
}

enum Model {
    ADMIN_DASHBOARD_MENUENTRY
}

final modelValues = EnumValues({
    "admin_dashboard.menuentry": Model.ADMIN_DASHBOARD_MENUENTRY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}

