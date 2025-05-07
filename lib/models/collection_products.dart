import 'package:mongo_dart/mongo_dart.dart';

class Product {
  ObjectId? id;
  String name; // Nombre del producto
  String description; // Descripción del producto
  double price; // Precio del producto
  String category; // Categoría a la que pertenece el producto
  int stockQuantity; // Cantidad disponible en stock
  DateTime createdAt; // Fecha en que se creó el producto

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toUtc(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      category: map['category'],
      stockQuantity: map['stock_quantity'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
