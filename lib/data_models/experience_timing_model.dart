class ExperienceTiming {
  int? id;
  String? date;
  String? startTime;

  ExperienceTiming({this.id, this.date, this.startTime});

  ExperienceTiming.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['start_time'] = startTime;
    return data;
  }
}