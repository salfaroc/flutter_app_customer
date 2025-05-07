// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';
import 'dart:developer';

class MongoDatabase {
  // Declaramos la base de datos y todas las colecciones
  // late indica que la variable se inicializará cuando se conecte).
  // DbCollection -> clase de mongo_dart para interactuar con las colecciones
  static late Db db; 
  static late DbCollection collectionAddresses;
  static late DbCollection collectionPermissions;
  static late DbCollection collectionProducts;
  static late DbCollection collectionAdmins;
  static late DbCollection collectionCustomers;
  static late DbCollection collectionCustomersBackup;
  static late DbCollection collectionOffers;
  static late DbCollection collectionOrders;
  static late DbCollection collectionPayments;
  static late DbCollection collectionReviews;
  static late DbCollection collectionShoppingCart;
  static late DbCollection collectionChats;

// Método estático para conectar con la base de datos
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
     // Imprimir el estado del servidor de MongoDB
    var status = await db.serverStatus();
    print(status);


   // Inicializar las colecciones
    collectionAddresses = db.collection(COLLECTION_ADDRESSES);
    collectionPermissions = db.collection(COLLECTION_PERMISSIONS);
    collectionProducts = db.collection(COLLECTION_PRODUCTS);
    collectionAdmins = db.collection(COLLECTION_ADMINS);
    collectionCustomers = db.collection(COLLECTION_CUSTOMERS);
    collectionCustomersBackup = db.collection(COLLECTION_CUSTOMERSBACKUP);
    collectionOffers = db.collection(COLLECTION_OFFERS);
    collectionOrders = db.collection(COLLECTION_ORDERS);
    collectionPayments = db.collection(COLLECTION_PAYMENTS);
    collectionReviews = db.collection(COLLECTION_REVIEWS);
    collectionShoppingCart = db.collection(COLLECTION_SHOPPINGCART);
    collectionChats = db.collection(COLLECTION_CHATS);

    print("Conectados a MongoDB e inicializadas todas las colecciones.");


  // ---------- DATOS INICIALES DE CADA COLECCION ----------------------------
  // Insertamos las direcciones 
 var address1Id =  ObjectId();
 var address2Id =  ObjectId();
 
  await collectionAddresses.insertMany([
  { "_id": address1Id,
    "street_type": "Calle",
    "street_name": "Gran Vía",
    "number": "23",
    "portal": "5B",
    "city": "Madrid",
    "province": "Madrid",
    "postal_code": "28007",
    "country": "España"
  },
  { "_id": address2Id,
    "street_type": "Avenida",
    "street_name": "Avenida de la Paz",
    "number": "12",
    "portal": "3A",
    "city": "Madrid",
    "province": "Madrid",
    "postal_code": "28002",
    "country": "España"
  }
]);

print("Direcciones insertadas:");
print(await collectionAddresses.find().toList());

// Insertamos los permisos y guardamos el resultado
var customerPermissionId = ObjectId();
var adminPermissionId = ObjectId();

await collectionPermissions.insertMany([
  {
    "_id": customerPermissionId,
    "name": "customer_permissions",
    "permissions": ["create_orders", "modify_order_address", "cancel_orders"]
  },
  {
    "_id": adminPermissionId,
    "name": "admin_permissions",
    "permissions": ["create_orders", "modify_order_address", "cancel_orders", "manage_products", "manage_orders", "manage_payments"]
  }
]);

// Insertamos los productos y guardamos el resultado
var canvaMilCaras = ObjectId();
var canvaTusMiedos = ObjectId();

await collectionProducts.insertMany([
  {
    "_id": canvaMilCaras,
    "name": "Mil Caras",
    "category": "lienzo",
    "price": 100,
    "stock_quantity": 1,
    "description": "Acrílico sobre lienzo.",
    "year": 2020,
    "size": {"width": 50.0, "height": 70.0}
  },
  {
    "_id": canvaTusMiedos,
    "name": "Tus Miedos",
    "category": "print",
    "price": 10,
    "stock_quantity": 10,
    "description": "Print realizado en digital. Soporte: papel gramaje 350gr.",
    "year": 2023,
    "size": {"width": 29.7, "height": 42.0}
  }
]);
print("Productos insertados:");
print(await collectionProducts.find().toList());

// Insertamos las ofertas
await collectionOffers.insertMany([
  {
    "product_id": canvaMilCaras,
    "new_price": {canvaMilCaras.oid: 70},
    "offer_start_date": DateTime.parse("2025-06-01T00:00:00Z"),
    "offer_end_date": DateTime.parse("2025-06-10T23:59:59Z"),
    "discount_percentage": 30,
    "offer_description": "Disfruta de un 30% de descuento en este cuadro",
    "is_active": true
  },
  {
    "product_id": canvaTusMiedos,
    "new_price": {canvaTusMiedos.oid: 8},
    "offer_start_date": DateTime.parse("2025-06-01T00:00:00Z"),
    "offer_end_date": DateTime.parse("2025-06-30T23:59:59Z"),
    "discount_percentage": 20,
    "offer_description": "Disfruta de un 20% de descuento en este cuadro",
    "is_active": true
  }
]);

print("Ofertas insertadas:");
print(await collectionOffers.find().toList());

// Insertar clientes
var customerId1 = ObjectId();
var customerId2 = ObjectId();

await collectionCustomers.insertMany([
  {
    "_id": customerId1,
    "first_name": "Juan",
    "last_name": "Pérez",
    "email": "juan.perez@email.com",
    "password": "hashed_password",
    "registration_date": DateTime.parse("2025-04-02T00:00:00Z"),
    "permissions_id": customerPermissionId,
    "address_ids": [address1Id],
    "phone": "+34 600123456",
    "is_active": true
  },
  {
    "_id": customerId2,
    "first_name": "Maria",
    "last_name": "García",
    "email": "maria.garcia@email.com",
    "password": "hashed_password",
    "registration_date": DateTime.parse("2025-04-02T00:00:00Z"),
    "permissions_id": customerPermissionId,
    "address_ids": [address2Id],
    "phone": "+34 600987654",
    "is_active": true
  }
]);

// Insertar clientes borrados y guardados en backup
await collectionCustomersBackup.insertMany([
  {
    "first_name": "Juana",
    "last_name": "DeArco",
    "email": "jjuanaDearco@email.com",
    "password": "123",
    "registration_date": DateTime.parse("2024-04-02T00:00:00Z"),
    "permissions_id": customerPermissionId,
    "address_ids": [address1Id],
    "phone": "+34 600123457",
    "is_active": false,
    "backup_date": DateTime.parse("2025-04-06T12:00:00Z"),
    "reason_for_backup": "No hay productos nuevos"
  }
]);

print("Clientes de respaldo insertados:");
print(await collectionCustomersBackup.find().toList());

// Insertar Admins
var adminId = ObjectId();

await collectionAdmins.insertMany([
  {
    "_id": adminId,
    "first_name": "Sara",
    "last_name": "Lopez",
    "email": "sara.lopez@email.com",
    "password": "123",
    "registration_date": DateTime.parse("2025-04-02T00:00:00Z"),
    "permissions_id": adminPermissionId,
    "is_active": true
  },
  {
    "first_name": "Gu",
    "last_name": "Garcia",
    "email": "gu.garcia@email.com",
    "password": "123",
    "registration_date": DateTime.parse("2025-04-02T00:00:00Z"),
    "permissions_id": adminPermissionId,
    "is_active": true
  }
]);

// Insertar reseñas 
var customerId1Review = customerId1;
var customerId2Review = customerId2;

await collectionReviews.insertMany([
  {
    "product_id": canvaMilCaras,
    "customer_id": customerId1Review,
    "rating": 10,
    "comment": "Me encanta este cuadro, es aún más impresionante en persona.",
    "review_date": DateTime.parse("2025-04-02T15:30:00Z")
  },
  {
    "product_id": canvaTusMiedos,
    "customer_id": customerId2Review,
    "rating": 9,
    "comment": "El print es bonito, la calidad del material es increíble.",
    "review_date": DateTime.parse("2025-04-02T16:00:00Z")
  }
]);


// Insertar chat
var chatId1 = ObjectId.parse('643a4f1d8f4b5a0c8c300001');
var chatId2 = ObjectId.parse('643a4f1d8f4b5a0c8c300002');

var orderId1 = ObjectId();
var orderId2 = ObjectId();

await collectionChats.insertMany([
  {
    "_id": chatId1,
    "order_id": orderId1,
    "customer_id": customerId1,
    "admin_id": adminId,
    "messages": [
      {
        "sender": "customer",
        "message": "¿Cuándo llega mi pedido?",
        "timestamp": DateTime.parse("2025-04-02T10:30:00Z")
      },
      {
        "sender": "admin",
        "message": "Tu pedido llegará mañana.",
        "timestamp": DateTime.parse("2025-04-02T10:35:00Z")
      }
    ],
    "status": "active",
    "created_at": DateTime.parse("2025-04-02T10:00:00Z")
  },
  {
    "_id": chatId2,
    "order_id": orderId2,
    "customer_id": customerId2,
    "admin_id": adminId,
    "messages": [
      {
        "sender": "customer",
        "message": "Mi pedido ha llegado dañado, ¿qué hago?",
        "timestamp": DateTime.parse("2025-04-02T15:00:00Z")
      },
      {
        "sender": "admin",
        "message": "Lo sentimos, iniciaremos el proceso de devolución.",
        "timestamp": DateTime.parse("2025-04-02T15:05:00Z")
      }
    ],
    "status": "active",
    "created_at": DateTime.parse("2025-04-02T12:00:00Z")
  }
]);

print("Chats insertados:");
print(await collectionChats.find().toList());

// Insertar pedidos
await collectionOrders.insertMany([
  {
    "_id": orderId1,
    "customer_id": customerId1,
    "status": "pending",
    "products": [canvaMilCaras],
    "address_id": address1Id,
    "total_amount": 78,
    "payment_status": "pending",
    "order_date": DateTime.parse("2025-04-02T10:00:00Z"),
    "chat_id": chatId1
  },
  {
    "_id": orderId2,
    "customer_id": customerId2,
    "status": "shipped",
    "products": [canvaTusMiedos],
    "address_id": address2Id,
    "total_amount": 8,
    "payment_status": "completed",
    "order_date": DateTime.parse("2025-04-02T12:00:00Z"),
    "chat_id": chatId2
  }
]);
print("Órdenes insertadas:");
print(await collectionOrders.find().toList());

// Insertar en el carro de compra
var cartId1 = ObjectId();
var cartId2 = ObjectId();

await collectionShoppingCart.insertMany([
  {
    "_id": cartId1,
    "customer_id": customerId1,
    "products": [
      {"product_id": canvaMilCaras, "quantity": 1, "initial_price": 100.0, "final_price": 70.0},
      {"product_id": canvaTusMiedos, "quantity": 1, "initial_price": 10.0, "final_price": 8.0}
    ],
    "total_price": 78
  },
  {
    "_id": cartId2,
    "customer_id": customerId2,
    "products": [
      {"product_id": canvaTusMiedos, "quantity": 1, "initial_price": 10.0, "final_price": 8.0}
    ],
    "total_price": 8.0
  }
]);

print("Carritos de compra insertados:");
print(await collectionShoppingCart.find().toList());


// Insertar Pagos
var pay1Id = ObjectId();
var pay2Id = ObjectId();

await collectionPayments.insertMany([
  {
    "_id": pay1Id,
    "cart_id": cartId1,
    "payment_method": "Credit Card",
    "payment_status": "pending",
    "payment_date": DateTime.parse("2025-04-02T11:00:00Z"),
    "handling_fee": 5.0,
    "amount": 83.0,
    "shipping_address_id": address1Id
  },
  {
    "_id": pay2Id,
    "cart_id": cartId2,
    "payment_method": "PayPal",
    "payment_status": "completed",
    "payment_date": DateTime.parse("2025-04-02T16:00:00Z"),
    "handling_fee": 5.0,
    "amount": 13.0,
    "shipping_address_id": address2Id
  }
]);

print("Pagos insertados:");
print(await collectionPayments.find().toList());
  }

  // Método estático para cerrar la conexión cuando no se necesite más
  static Future<void> close() async {
    await db.close();
    print("Conexion MongoDB cerrada.");
  }
}

