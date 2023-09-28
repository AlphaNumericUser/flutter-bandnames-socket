class Band {

  String id;
  String name;
  int votes;
  
  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  // * El factory constructor tiene como objetivo regresar una instancia de nuestra clase
  factory Band.fromMap( Map<String, dynamic> obj ) => Band(
    id    : obj.containsKey('id')    ? obj['id']    : 'No ID',
    name  : obj.containsKey('name') ? obj['name'] : 'No name',
    votes : obj.containsKey('votes') ? obj['votes'] : 'No votes',
  );

}
