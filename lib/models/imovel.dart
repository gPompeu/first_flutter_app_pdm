class Imovel {
  String title;
  bool available;

  Imovel({this.title, this.available});

  Imovel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['available'] = this.available;
    return data;
  }
}