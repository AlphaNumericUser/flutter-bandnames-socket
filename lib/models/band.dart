class Band {

  String id;
  String name;
  int? votes;
  
  Band({
    required this.id,
    required this.name,
    this.votes,
  });

  // * El factory constructor tiene como objetivo regresar una instancia de nuestra clase
  factory Band.fromMap( Map<String, dynamic> obj ) => Band(
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes'],
  );

}
