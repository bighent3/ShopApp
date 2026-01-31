import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart'; // gives access to Item, CartModel, and productImage()

class ProductDetailScreen extends StatelessWidget {
  final Item item;

  const ProductDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              // ✅ supports imageAsset OR imageUrl and avoids String? error
              child: productImage(item),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ✅ rating + rating count
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18),
                      const SizedBox(width: 6),
                      Text(item.rating.toStringAsFixed(1)),
                      const SizedBox(width: 8),
                      Text('(${item.ratingCount} ratings)'),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    item.priceText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        context.read<CartModel>().add(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
