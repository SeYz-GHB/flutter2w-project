class Room {
  int? roomId;
  String roomNumber;
  String type;
  bool availability;

  Room({
    this.roomId,
    required this.roomNumber,
    required this.type,
    required this.availability,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomId: json['room_id'],
        roomNumber: json['room_number'],
        type: json['type'],
        availability: json['availability'] == 1 || json['availability'] == true,
      );

  Map<String, dynamic> toJson() => {
        'room_id': roomId,
        'room_number': roomNumber,
        'type': type,
        'availability': availability ? 1 : 0,
      };
}
