class data4 {
  String tittle;

  data4({
    required this.tittle,
  });
  factory data4.fromJson(Map<String, dynamic> json) => data4(
        tittle: json["tittle"],
      );

  Map<String, dynamic> toJson() => {
        "tittle": tittle,
      };
}
