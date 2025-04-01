import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_item.g.dart';

@JsonSerializable()
class WishlistItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String link;
  final String status;
  @JsonKey(name: 'is_reserved')
  final bool isReserved;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const WishlistItem({
    required this.id,
    required this.name,
    required this.description,
    required this.link,
    required this.status,
    required this.isReserved,
    required this.createdBy,
    required this.createdAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistItemToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        link,
        status,
        isReserved,
        createdBy,
        createdAt,
      ];
}
