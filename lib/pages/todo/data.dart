class data {
  String tittle;
  String content;
  String priority;
  String duedate;
  bool check;

  data({
    required this.tittle,
    required this.content,
    required this.priority,
    required this.duedate,
    required this.check,
   
  });
  factory data.fromJson(Map<String, dynamic> json) => data(
        tittle: json["tittle"],
        content: json["content"],
        priority: json["priority"],
        duedate: json["duedate"],
        check: json["check"],
       
      );

  Map<String, dynamic> toJson() => {
        "tittle": tittle,
        "content": content,
        "priority": priority,
        "duedate": duedate,
        "check": check,
       
      };
}
