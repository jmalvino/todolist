class Todo{

  Todo({required this.title, required this.dateTime, required this.check});

  Todo.fromJson(Map<String, dynamic> json)
  : title = json['title'],
    check = json['check'],
    dateTime = DateTime.parse(json['datetime'],
    );

  String title;
  DateTime dateTime;
  bool check;

  Map<String, dynamic> toJson(){
    return{
      "title": title,
      "datetime": dateTime.toIso8601String(),
      "check": check,
    };
  }
}