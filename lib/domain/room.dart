class Room {
  int? id;
  String number;
  String type;
  int capacity;
  int availableBeds;

  Room({
    this.id,
    required this.number,
    required this.type,
    required this.capacity,
    required this.availableBeds,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'],
        number: json['number'],
        type: json['type'],
        capacity: json['capacity'],
        availableBeds: json['available_beds'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'type': type,
        'capacity': capacity,
        'available_beds': availableBeds,
      };
}
