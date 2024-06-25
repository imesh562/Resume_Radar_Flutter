import 'dart:ui';

class DropDownItem {
  final String id;
  final String fieldText;
  final String? colorCode;
  final Color? iconColor;

  DropDownItem({
    required this.id,
    required this.fieldText,
    this.colorCode,
    this.iconColor,
  });

  factory DropDownItem.fromJson(Map<String, dynamic> json) => DropDownItem(
        id: json["id"],
        fieldText: json["fieldText"],
        colorCode: json["colorCode"],
        iconColor: json["iconColor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fieldText": fieldText,
        "colorCode": colorCode,
        "iconColor": iconColor,
      };
}
