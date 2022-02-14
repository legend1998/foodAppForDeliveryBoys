class AppUser {
  AppUser(
      {required this.id,
      this.name = "",
      this.email = "",
      this.phone = "",
      this.address = "",
      this.imageUrl = "",
      this.token = "",
      this.coverImage = "",
      required this.joinDate,
      this.gender = "not specified",
      required this.favorite});

  String? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? coverImage;
  String? imageUrl;
  DateTime? joinDate;
  int? followers = 0;
  int? following = 0;
  String? token;
  List<MyFav> favorite;
  Object? address;

  Map<String, dynamic> userAsMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'email': email,
      'joinDate': joinDate.toString(),
      'phone': phone,
      'token': token,
      'imageUrl': imageUrl,
      'coerImage': coverImage,
      'favorite': favorite.map((e) => e.myFavasMap()),
      'followers': followers,
      'following': following,
      'address': address,
    };
  }

  static AppUser userFromMap(Map<String, dynamic> data) {
    return AppUser(
        joinDate: DateTime.parse(data['joinDate']),
        name: data['name'],
        id: data['id'],
        email: data['email'],
        phone: data['phone'],
        token: data['token'],
        coverImage: data["coverImage"],
        favorite: data["favorite"] != null
            ? List<MyFav>.from(
                data["favorite"].map((x) => MyFav.myfavfromMap(x)))
            : [],
        gender: data["gender"],
        imageUrl: data['imageUrl'],
        address: data['address']);
  }
}

class MyFav {
  String id;
  String imageUrl;
  String name;

  MyFav({required this.id, required this.imageUrl, required this.name});

  Map<String, dynamic> myFavasMap() {
    return {'id': id, 'name': name, "imageUrl": imageUrl};
  }

  static MyFav myfavfromMap(Map<String, dynamic> data) {
    return MyFav(
        name: data['name'], id: data['id'], imageUrl: data['imageUrl']);
  }
}
