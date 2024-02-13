class data {
  String tittle;
  String content;
  String priority;
  String duedate;
  bool check;
  String reminder;
  //  String category;
  int id;

  data({
    required this.tittle,
    required this.content,
    required this.priority,
    required this.duedate,
    required this.check,
    required this.id,  required this.reminder
    // required this.category
  });
  factory data.fromJson(Map<String, dynamic> json) => data(
        tittle: json["tittle"],
        content: json["content"],
        priority: json["priority"],
        duedate: json["duedate"],
        check: json["check"],
        id: json["id"], reminder:json["reminder"] ,
      );

  Map<String, dynamic> toJson() => {
        "tittle": tittle,
        "content": content,
        "priority": priority,
        "duedate": duedate,
        "check": check,
        "id": id,
        "reminder":reminder
      };
}
