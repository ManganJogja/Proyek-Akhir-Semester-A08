// To parse this JSON data, do
//
//     final restoEntry = restoEntryFromJson(jsonString);

import 'dart:convert';

List<RestoEntry> restoEntryFromJson(String str) => List<RestoEntry>.from(json.decode(str).map((x) => RestoEntry.fromJson(x)));

String restoEntryToJson(List<RestoEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestoEntry {
    Model model;
    String pk;
    Fields fields;

    RestoEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory RestoEntry.fromJson(Map<String, dynamic> json) => RestoEntry(
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
    String namaResto;
    String alamat;
    JenisKuliner jenisKuliner;
    String lokasiResto;
    int rangeHarga;
    String rating;
    Suasana suasana;
    int keramaianResto;

    Fields({
        required this.namaResto,
        required this.alamat,
        required this.jenisKuliner,
        required this.lokasiResto,
        required this.rangeHarga,
        required this.rating,
        required this.suasana,
        required this.keramaianResto,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaResto: json["nama_resto"],
        alamat: json["alamat"],
        jenisKuliner: jenisKulinerValues.map[json["jenis_kuliner"]]!,
        lokasiResto: json["lokasi_resto"],
        rangeHarga: json["range_harga"],
        rating: json["rating"],
        suasana: suasanaValues.map[json["suasana"]]!,
        keramaianResto: json["keramaian_resto"],
    );

    Map<String, dynamic> toJson() => {
        "nama_resto": namaResto,
        "alamat": alamat,
        "jenis_kuliner": jenisKulinerValues.reverse[jenisKuliner],
        "lokasi_resto": lokasiResto,
        "range_harga": rangeHarga,
        "rating": rating,
        "suasana": suasanaValues.reverse[suasana],
        "keramaian_resto": keramaianResto,
    };
}

enum JenisKuliner {
    CHINESE,
    INDONESIA,
    JAPANESE,
    MIDDLE_EASTERN,
    WESTERN
}

final jenisKulinerValues = EnumValues({
    "Chinese": JenisKuliner.CHINESE,
    "Indonesia": JenisKuliner.INDONESIA,
    "Japanese": JenisKuliner.JAPANESE,
    "Middle Eastern": JenisKuliner.MIDDLE_EASTERN,
    "Western": JenisKuliner.WESTERN
});

enum Suasana {
    FORMAL,
    SANTAI,
    SUASANA_FORMAL
}

final suasanaValues = EnumValues({
    "Formal": Suasana.FORMAL,
    "Santai": Suasana.SANTAI,
    "Formal ": Suasana.SUASANA_FORMAL
});

enum Model {
    ADMIN_DASHBOARD_RESTAURANTENTRY
}

final modelValues = EnumValues({
    "admin_dashboard.restaurantentry": Model.ADMIN_DASHBOARD_RESTAURANTENTRY
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