import 'package:goasbar/data_models/image_set_model.dart';

class ExperienceResults {
  int? id;
  String? title;
  String? description;
  List<dynamic>? categories;
  String? price;
  dynamic latitude;
  dynamic longitude;
  int? minAge;
  String? locationNotes;
  String? city;
  String? slug;
  String? profileImage;
  String? providedGoods;
  String? events;
  String? requirements;
  String? rate;
  String? duration;
  int? providerId;
  String? gender;
  dynamic youtubeVideo;
  String? creationDate;
  String? status;
  List<ImageSet>? imageSet;

  ExperienceResults(
      {this.id,
        this.title,
        this.description,
        this.categories,
        this.price,
        this.latitude,
        this.longitude,
        this.minAge,
        this.locationNotes,
        this.city,
        this.slug,
        this.profileImage,
        this.providedGoods,
        this.events,
        this.requirements,
        this.rate,
        this.duration,
        this.providerId,
        this.gender,
        this.youtubeVideo,
        this.creationDate,
        this.status,
        this.imageSet});

  ExperienceResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    categories = json['categories'];
    price = json['price'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    minAge = json['min_age'];
    locationNotes = json['location_notes'];
    city = json['city'];
    slug = json['slug'];
    profileImage = json['profile_image'];
    providedGoods = json['provided_goods'];
    events = json['events'];
    requirements = json['requirements'];
    rate = json['rate'];
    duration = json['duration'];
    providerId = json['provider_id'];
    gender = json['gender'];
    youtubeVideo = json['youtube_video'];
    creationDate = json['creation_date'];
    if (json.keys.contains("status")) {
      status = json['status'];
    }
    if (json['image_set'] != null) {
      imageSet = <ImageSet>[];
      json['image_set'].forEach((v) {
        imageSet!.add(ImageSet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['categories'] = categories;
    data['price'] = price;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['min_age'] = minAge;
    data['location_notes'] = locationNotes;
    data['city'] = city;
    data['slug'] = slug;
    data['profile_image'] = profileImage;
    data['provided_goods'] = providedGoods;
    data['events'] = events;
    data['requirements'] = requirements;
    data['rate'] = rate;
    data['duration'] = duration;
    data['provider_id'] = providerId;
    data['gender'] = gender;
    data['youtube_video'] = youtubeVideo;
    data['creation_date'] = creationDate;
    if (data.keys.contains("status")) {
      data['status'] = status;
    }
    if (imageSet != null) {
      data['image_set'] = imageSet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}