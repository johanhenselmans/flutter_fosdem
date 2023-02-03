import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';


@JsonSerializable(explicitToJson: true)
class Room {
  Room(this.name, this.event,
      );
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'event')
  List? event;

  factory Room.fromJson(Map<String, dynamic> json) =>
      _$RoomFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `$UserToJson`.
  Map<String, dynamic> toJson() => _$RoomToJson(this);
// as the original XML data supplies (eg) int 1  as "1", we have to convert the int for storage in the Object and the database
//static int fromJson(String String) => int.parse(String);
//static String toJson(int anInt) => anInt.toString();
  Room.fromMapToObject(dynamic obj);


}