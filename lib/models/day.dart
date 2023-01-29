import "package:fosdem/models/event.dart";
import 'package:fosdem/models/room.dart';
import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

@JsonSerializable(explicitToJson: true)
class Day {
  Day(this.index, this.date, this.Room);

  @JsonKey(name: 'index')
  String? index;
  @JsonKey(name: 'date')
  String? date;
  @JsonKey(name: 'room')
  List? Room;

  factory Day.fromJson(Map<String, dynamic> json) =>
      _$DayFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `$UserToJson`.
  Map<String, dynamic> toJson() => _$DayToJson(this);
// as the original XML data supplies (eg) int 1  as "1", we have to convert the int for storage in the Object and the database
//static int fromJson(String String) => int.parse(String);
//static String toJson(int anInt) => anInt.toString();

  Day.fromMapToObject(dynamic obj) {
  }

}


