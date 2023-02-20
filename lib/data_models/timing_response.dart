class TimingResponse {
  int? id;
  int? experience;
  String? date;
  String? startTime;
  int? capacity;
  String? status;

  TimingResponse(
      {this.id,
        this.experience,
        this.date,
        this.startTime,
        this.capacity,
        this.status});

  TimingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json.keys.contains("experience")) {
      experience = json['experience'];
    }
    date = json['date'];
    startTime = json['start_time'];
    capacity = json['capacity'];
    if (json.keys.contains("status")) {
      status = json['status'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (data.keys.contains("experience")) {
      data['experience'] = experience;
    }
    data['date'] = date;
    data['start_time'] = startTime;
    data['capacity'] = capacity;
    if (data.keys.contains("status")) {
      data['status'] = status;
    }
    return data;
  }
}