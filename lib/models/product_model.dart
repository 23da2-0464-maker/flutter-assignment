class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final bool isFeatured;
  final double rating;
  final int reviewCount;
  final bool isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.images = const [],
    this.sizes = const [],
    this.colors = const [],
    this.isFeatured = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isWishlisted = false, 
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      sizes: List<String>.from(data['sizes'] ?? []),
      colors: List<String>.from(data['colors'] ?? []),
      isFeatured: data['isFeatured'] ?? false,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      isWishlisted: data['isWishlisted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'images': images,
      'sizes': sizes,
      'colors': colors,
      'isFeatured': isFeatured,
      'rating': rating,
      'reviewCount': reviewCount,
      'isWishlisted': isWishlisted,
    };
  }
}