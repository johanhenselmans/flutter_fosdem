import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'person.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class Person extends ChangeNotifier {
  Person(id,
      name,);

  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: '\$t')
  String? name;

  /// A necessary factory constructor for creating a new Event instance
  /// from a map. Pass the map to the generated `_$EventFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Event.
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  // as the original XML data supplies (eg) int 1  as "1", we have to convert the int for storage in the Object and the database
  //static int _fromJson(String String) => int.parse(String);
  //static String _toJson(int anInt) => anInt.toString();

  Person.fromMapToObject(dynamic obj) {
    // mapping comes from the database: we fill year,
    // which is not contained in the info coming from the xml
    // information comes from xml transferred to json: somehow ints are not
    // understood as ints, so we do it manually.
    // also, this should not contain the column localavailable, which indicates localavailability
    // the groupcol is a database field, so we know that that comes out of the database
    // if an event has been downloaded;
    if (obj['id'].runtimeType.toString().contains('String')) {
      id = int.parse(obj["id"]);
      name = obj["\$t"];
    } else {
      id = obj['id'];
      name = obj["name"];
    }
  }
}