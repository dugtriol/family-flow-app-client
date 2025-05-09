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
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'reserved_by')
  final Map<String, dynamic> reservedBy;
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String? photo;

  const WishlistItem({
    required this.id,
    required this.name,
    required this.description,
    required this.link,
    required this.status,
    required this.createdBy,
    required this.reservedBy,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.photo,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      link: json['link'] as String,
      status: json['status'] as String,
      createdBy: json['created_by'] as String,
      reservedBy: json['reserved_by'] as Map<String, dynamic>,
      isArchived: json['is_archived'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      photo:
          json['photo']['Valid']
                  as bool // Обработка поля photo
              ? json['photo']['String'] as String
              : null,
    );
  }

  Map<String, dynamic> toJson() => _$WishlistItemToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    link,
    status,
    createdBy,
    reservedBy,
    isArchived,
    createdAt,
    updatedAt,
    photo,
  ];
}
