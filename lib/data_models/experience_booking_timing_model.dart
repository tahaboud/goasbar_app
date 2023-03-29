class ExperienceBookingTiming {
  int? id;
  String? title;
  String? duration;
  String? place;
  String? date;
  String? startTime;

  ExperienceBookingTiming(
      {this.id,
        this.title,
        this.duration,
        this.place,
        this.date,
        this.startTime});

  ExperienceBookingTiming.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    place = json['place'];
    date = json['date'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['duration'] = duration;
    data['place'] = place;
    data['date'] = date;
    data['start_time'] = startTime;
    return data;
  }
}