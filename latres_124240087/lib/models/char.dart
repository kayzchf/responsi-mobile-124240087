class Char {
  final String fullname;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final List<dynamic> children;
  final String image;
  final String birthdate;
  final int index;

  Char({
    required this.fullname,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.children,
    required this.image,
    required this.birthdate,
    required this.index
  });

  factory Char.fromJson(Map<String, dynamic> jsonData) {
    return Char(
      fullname: jsonData['fullName'] ?? jsonData['fullname'] ?? '', 
      nickname: jsonData['nickname'] ?? '', 
      hogwartsHouse: jsonData['hogwartsHouse'] ?? '', 
      interpretedBy: jsonData['interpretedBy'] ?? '', 
      children: jsonData['children'] ?? [], 
      image: jsonData['image'] ?? '', 
      birthdate: jsonData['birthdate']?.toString() ?? '', 
      index: jsonData['index'] ?? 0
    );
  }
}