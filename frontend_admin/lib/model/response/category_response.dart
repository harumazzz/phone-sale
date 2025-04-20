import 'package:equatable/equatable.dart';

class CategoryResponse extends Equatable {
  const CategoryResponse({this.id, this.name});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(id: json['id'], name: json['name']);
  }
  final int? id;
  final String? name;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}
