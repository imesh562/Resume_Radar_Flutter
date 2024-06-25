import 'dart:convert';

DropDownEntity dropDownEntityFromJson(String str) =>
    DropDownEntity.fromJson(json.decode(str));

String dropDownEntityToJson(DropDownEntity data) => json.encode(data.toJson());

class DropDownEntity {
  final String? value;
  final String? label;

  DropDownEntity({
    this.value,
    this.label,
  });

  factory DropDownEntity.fromJson(Map<String, dynamic> json) => DropDownEntity(
        value: json["value"].toString(),
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
      };
}
