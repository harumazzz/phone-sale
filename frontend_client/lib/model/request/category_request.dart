import 'package:equatable/equatable.dart';

class CategoryRequest extends Equatable {
  const CategoryRequest({this.name});

  factory CategoryRequest.fromJson(Map<String, dynamic> json) {
    return CategoryRequest(name: json['name']);
  }
  final String? name;

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  List<Object?> get props => [name];
}
