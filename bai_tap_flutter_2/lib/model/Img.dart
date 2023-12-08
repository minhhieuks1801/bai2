
class Img {

   final String? key;
   final String? name;
   final String? link;

   Img({ this.key, this.name, this.link});

   Img copyWith({String? key, String? name, String? link}) {
     return Img(
       key: key,
       name: name,
       link: link,
     );
   }

   factory Img.fromJson(Map<String, dynamic> json) {
     return Img(
       name: json['name'],
     );
   }

   Map<String, dynamic> toJson() {
     return {
       'name': name,
     };
   }


}