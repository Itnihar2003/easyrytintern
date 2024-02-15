class data4 {
  String tittle;
  String content;

  String priority;
  String duedate;
  bool check;
  String reminder;
  //  String category;
  int id;

  data4(
      {required this.tittle,
      required this.content,
      required this.priority,
      required this.duedate,
      required this.check,
      required this.id,
      required this.reminder});
  factory data4.fromJson(Map<String, dynamic> json) => data4(
        tittle: json["tittle"],
        content: json["content"],
        priority: json["priority"],
        duedate: json["duedate"],
        check: json["check"],
        id: json["id"],
        reminder: json["reminder"],
      );

  Map<String, dynamic> toJson() => {
        "tittle": tittle,
        "content": content,
        "priority": priority,
        "duedate": duedate,
        "check": check,
        "id": id,
        "reminder": reminder
      };
}
