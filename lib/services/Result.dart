// To parse this JSON data, do
//
//     final result = resultFromJson(jsonString);

import 'dart:convert';

ResultScan resultFromJson(String str) => ResultScan.fromJson(json.decode(str));

String resultToJson(ResultScan data) => json.encode(data.toJson());

class ResultScan {
  ResultScan({
    required this.query,
    required this.language,
    required this.preferedReferential,
    required this.bestMatch,
    required this.results,
  });

  Query query;
  String language;
  String preferedReferential;
  String bestMatch;
  List<ResultElement> results;

  factory ResultScan.fromJson(Map<String, dynamic> json) => ResultScan(
        query: Query.fromJson(json["query"]),
        language: json["language"],
        preferedReferential: json["preferedReferential"],
        bestMatch: json["bestMatch"],
        results: List<ResultElement>.from(
            json["results"].map((x) => ResultElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "query": query.toJson(),
        "language": language,
        "preferedReferential": preferedReferential,
        "bestMatch": bestMatch,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Query {
  Query({
    required this.project,
    required this.images,
    required this.organs,
    required this.includeRelatedImages,
  });

  String project;
  List<String> images;
  List<String> organs;
  bool includeRelatedImages;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
        project: json["project"],
        images: List<String>.from(json["images"].map((x) => x)),
        organs: List<String>.from(json["organs"].map((x) => x)),
        includeRelatedImages: json["includeRelatedImages"],
      );

  Map<String, dynamic> toJson() => {
        "project": project,
        "images": List<dynamic>.from(images.map((x) => x)),
        "organs": List<dynamic>.from(organs.map((x) => x)),
        "includeRelatedImages": includeRelatedImages,
      };
}

class ResultElement {
  ResultElement({
    required this.score,
    required this.species,
    required this.images,
    required this.gbif,
  });

  double score;
  Species species;
  List<Image> images;
  Gbif gbif;

  factory ResultElement.fromJson(Map<String, dynamic> json) => ResultElement(
        score: json["score"].toDouble(),
        species: Species.fromJson(json["species"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        gbif: Gbif.fromJson(json["gbif"]),
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "species": species.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "gbif": gbif.toJson(),
      };
}

class Gbif {
  Gbif({
    required this.id,
  });

  String id;

  factory Gbif.fromJson(Map<String, dynamic> json) => Gbif(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class Image {
  Image({
    required this.organ,
    required this.author,
    required this.license,
    required this.date,
    required this.url,
    required this.citation,
  });

  String organ;
  String author;
  String license;
  Date date;
  Url url;
  String citation;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        organ: json["organ"],
        author: json["author"],
        license: json["license"],
        date: Date.fromJson(json["date"]),
        url: Url.fromJson(json["url"]),
        citation: json["citation"],
      );

  Map<String, dynamic> toJson() => {
        "organ": organ,
        "author": author,
        "license": license,
        "date": date.toJson(),
        "url": url.toJson(),
        "citation": citation,
      };
}

class Date {
  Date({
    required this.timestamp,
    required this.string,
  });

  int timestamp;
  String string;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        timestamp: json["timestamp"],
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "string": string,
      };
}

class Url {
  Url({
    required this.o,
    required this.m,
    required this.s,
  });

  String o;
  String m;
  String s;

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        o: json["o"],
        m: json["m"],
        s: json["s"],
      );

  Map<String, dynamic> toJson() => {
        "o": o,
        "m": m,
        "s": s,
      };
}

class Species {
  Species({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
    required this.genus,
    required this.family,
    required this.commonNames,
    required this.scientificName,
  });

  String scientificNameWithoutAuthor;
  String scientificNameAuthorship;
  Family genus;
  Family family;
  List<String> commonNames;
  String scientificName;

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        scientificNameWithoutAuthor: json["scientificNameWithoutAuthor"],
        scientificNameAuthorship: json["scientificNameAuthorship"],
        genus: Family.fromJson(json["genus"]),
        family: Family.fromJson(json["family"]),
        commonNames: List<String>.from(json["commonNames"].map((x) => x)),
        scientificName: json["scientificName"],
      );

  Map<String, dynamic> toJson() => {
        "scientificNameWithoutAuthor": scientificNameWithoutAuthor,
        "scientificNameAuthorship": scientificNameAuthorship,
        "genus": genus.toJson(),
        "family": family.toJson(),
        "commonNames": List<dynamic>.from(commonNames.map((x) => x)),
        "scientificName": scientificName,
      };
}

class Family {
  Family({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
    required this.scientificName,
  });

  String scientificNameWithoutAuthor;
  String scientificNameAuthorship;
  String scientificName;

  factory Family.fromJson(Map<String, dynamic> json) => Family(
        scientificNameWithoutAuthor: json["scientificNameWithoutAuthor"],
        scientificNameAuthorship: json["scientificNameAuthorship"],
        scientificName: json["scientificName"],
      );

  Map<String, dynamic> toJson() => {
        "scientificNameWithoutAuthor": scientificNameWithoutAuthor,
        "scientificNameAuthorship": scientificNameAuthorship,
        "scientificName": scientificName,
      };
}
