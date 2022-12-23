class Game{
  int? id;
  String title;
  String developer;
  double price;
  double rating;
  String genre;
  String pegi18;

  Game(this.id, this.title, this.developer, this.price, this.rating, this.genre,
      this.pegi18);

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'title': title,
      'developer': developer,
      'price' : price,
      'rating' : rating,
      'genre' : genre,
      'pegi18' : pegi18
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return "$title $developer $price $rating  $genre $pegi18";
  }
}