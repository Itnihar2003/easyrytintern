class data1{
  String tittle1;
  String content1;
 

  data1({
    required this.tittle1,
    required this.content1,
   
   
  });
  factory data1.fromJson(Map<String, dynamic> json) => data1(
        tittle1: json["tittle1"],
        content1: json["content1"],
      
       
      );

  Map<String, dynamic> toJson() => {
        "tittle1": tittle1,
        "content1": content1,
        
      };
}
