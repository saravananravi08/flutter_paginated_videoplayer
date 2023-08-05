import 'dart:convert';

import 'package:get/get.dart';

class Result {
  final int id;
  final String video;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RxInt likes;
  final RxInt dislikes;
  RxInt comments;
  final RxBool liked;
  final RxBool disliked;
  final RxBool saved;
  final String? thumbnail;
  final double aspect;
  RxBool isFollowing;
  RxBool isFavourited;
  List? hashtags;

  Result(
      {required this.id,
      required this.video,
      required this.createdAt,
      required this.updatedAt,
      required this.likes,
      required this.dislikes,
      required this.comments,
      required this.liked,
      required this.disliked,
      required this.saved,
      this.thumbnail,
      this.hashtags,
      required this.isFollowing,
      required this.aspect,
      required this.isFavourited});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      id: json["id"],
      video: json["video"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      hashtags: jsonDecode(json['hashtags'] ?? '[]'),
      likes: ((json["likes"] ?? 0) as int).obs,
      dislikes: ((json["dislikes"] ?? 0) as int).obs,
      comments: ((json["comments"] ?? 0) as int).obs,
      liked: ((json["liked"] ?? false) ? true : false).obs,
      disliked: ((json["disliked"] ?? false) ? true : false).obs,
      saved: ((json["saved"] ?? false) ? true : false).obs,
      thumbnail: json["thumbnail"],
      isFavourited: ((json['favourited'] ?? false) ? true : false).obs,
      isFollowing: ((json['following'] ?? false) ? true : false).obs,
      aspect: json['aspect_ratio'] ?? 0.56);

  Map<String, dynamic> toJson() => {
        "id": id,
        "video": video,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "likes": likes,
        "dislikes": dislikes,
        "comments": comments,
        "liked": liked,
        "disliked": disliked,
        "saved": saved,
        "thumbnail": thumbnail,
        'aspect_ratio': aspect
      };
}

class ReelModel {
  final int count;
  final String? next;
  final String? previous;
  final RxList<Result> results;

  ReelModel({
    required this.count,
    required this.next,
    this.previous,
    required this.results,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) => ReelModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
                .obs,
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
