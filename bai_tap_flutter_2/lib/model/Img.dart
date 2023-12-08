
class Img {

   final String? key;
   final String? name;
   final String? link;

   Img({ required this.key, required this.name, this.link});

   Img copyWith({String? key, String? name, String? link}) {
     return Img(
       key: key ?? this.key,
       name: name ?? this.name,
       link: link ?? this.link,
     );
   }

   factory Img.fromJson(Map<String, dynamic> json) {
     return Img(
       key: json['key'],
       name: json['name'],
       link: json['link'],
     );
   }

   Map<String, dynamic> toJson() {
     return {
       'name': name,
     };
   }


}