import 'package:flutter/material.dart';
import 'package:mzn_news/services/global_methods.dart';

class NewsModel with ChangeNotifier {
  String newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      content,
      publishedAt,
      publishedDate,
      readingTimeText;

  NewsModel(
      {required this.newsId,
      required this.sourceName,
      required this.authorName,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.content,
      required this.publishedAt,
      required this.publishedDate,
      required this.readingTimeText});

  factory NewsModel.fromJson(dynamic json) {
    String title = json["title"] ?? "";
    String content = json["content"] ?? "";
    String description = json["description"] ?? "";

    String publishedDate = "";
    if (json["publishedAt"] != null) {
      publishedDate = GlobalMethods.formattedDateText(json["publishedAt"]);
    }

    return NewsModel(
      newsId: json["source"]["id"] ?? "",
      sourceName: json["source"]["name"] ?? "",
      authorName: json["author"] ?? "",
      title: title,
      description: description,
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"] ??
          "https://semantic-ui.com/images/wireframe/image.png",
      content: content,
      publishedAt: json["publishedAt"] ?? "",
      publishedDate: publishedDate,
      readingTimeText: "readingTimeText",
    );
  }

  static List<NewsModel> newsFromSnapshot(List newSnapshot) {
    return newSnapshot.map((json) {
      return NewsModel.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["newsId"] = newsId;
    data["sourceName"] = sourceName;
    data["authorName"] = authorName;
    data["title"] = title;
    data["description"] = description;
    data["url"] = url;
    data["urlToImage"] = urlToImage;
    data["content"] = content;
    data["publishedAt"] = publishedAt;
    data["publishedDate"] = publishedDate;
    data["readingTimeText"] = readingTimeText;
    return data;
  }
}
