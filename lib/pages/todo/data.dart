class data {
  String tittle;
  String content;
  String priority;
  String duedate;
  bool check;
  String remeninderdate;
  String remenindertime;
  String total;
  data({
    required this.tittle,
    required this.content,
    required this.priority,
    required this.duedate,
    required this.check,
    required this.remeninderdate,
    required this.remenindertime,  required this.total,
  });
  factory data.fromJson(Map<String, dynamic> json) => data(
        tittle: json["tittle"],
        content: json["content"],
        priority: json["priority"],
        duedate: json["duedate"],
        check: json["check"],
        remeninderdate: json["reminderdate"],
        remenindertime: json["remindertime"], total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "tittle": tittle,
        "content": content,
        "priority": priority,
        "duedate": duedate,
        "check": check,
        "reminderdate": remeninderdate,
        "remindertime": remenindertime,
        "total":total
      };
}
