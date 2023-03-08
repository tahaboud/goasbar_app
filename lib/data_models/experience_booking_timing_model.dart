class ExperienceBookingTiming {
  int? id;
  String? experienceName;
  String? date;
  String? startTime;

  ExperienceBookingTiming({this.id, this.experienceName, this.date, this.startTime});

  ExperienceBookingTiming.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experienceName = json['experience_name'];
    date = json['date'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['experience_name'] = experienceName;
    data['date'] = date;
    data['start_time'] = startTime;
    return data;
  }
}