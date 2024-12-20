// To parse this JSON data, do
//
//     final ReviewEntry = itemEntryFromJson(jsonString);

import 'dart:convert';

List<ReviewEntry> reviewEntryFromJson(String str) =>
    List<ReviewEntry>.from(json.decode(str).map((x) => ReviewEntry.fromJson(x)));

String reviewEntryToJson(List<ReviewEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewEntry {
  int id;
  String userUsername;
  int rating;
  String comment;
  DateTime createdAt;

  ReviewEntry({
    required this.id,
    required this.userUsername,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewEntry.fromJson(Map<String, dynamic> json) => ReviewEntry(
        id: json["id"],
        userUsername: json["user__username"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user__username": userUsername,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
      };
}
