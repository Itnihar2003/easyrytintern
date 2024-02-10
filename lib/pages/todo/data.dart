class data {
  String tittle;
  String content;
  String priority;
  String duedate;
  bool check;
  int id;

  data({
    required this.tittle,
    required this.content,
    required this.priority,
    required this.duedate,
    required this.check,required this.id,
  });
  factory data.fromJson(Map<String, dynamic> json) => data(
        tittle: json["tittle"],
        content: json["content"],
        priority: json["priority"],
        duedate: json["duedate"],
        check: json["check"], id: json["id"] ,
      );

  Map<String, dynamic> toJson() => {
        "tittle": tittle,
        "content": content,
        "priority": priority,
        "duedate": duedate,
        "check": check,"id":id
      };
}
