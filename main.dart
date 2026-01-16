import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatalogModel()),
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => OrdersModel()),
      ],
      child: const ShopApp(),
    ),
  );
}

/// -------------------------
/// APP ROOT
/// -------------------------
class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'West Coast Tour Partners',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ShopHome(),
    );
  }
}

/// -------------------------
/// DATA MODELS
/// -------------------------
class Item {
  final String id;
  final String name;
  final String description;
  final int priceCents;
  final String imageAsset;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCents,
    required this.imageAsset,
  });

  String get priceText => _formatCents(priceCents);
}

String _formatCents(int cents) {
  final dollars = cents / 100.0;
  return '\$${dollars.toStringAsFixed(2)}';
}

class CatalogModel extends ChangeNotifier {
  // In a real app, this list would come from an API.
  final List<Item> _items = const [
    Item(
      id: '1',
      name: 'Cocktails And Stories From Pike Place Market',
      description: 'Discover Seattle’s Pike Place Market through its flavors, then a hands-on cocktail class with founder Bryan Jarr or one of his staff. You’ll shop the Market for fresh ingredients, learn mixology techniques, and craft signature Northwest cocktails',
      priceCents: 13500,
      imageAsset: 'assets/images/Friends.JPG'
    ),
    Item(
      id: '2',
      name: 'Elite - Luxury Shuttle & Best Day in Seattle',
      description: 'Elite VIP - Shuttle & All-inclusive Ultimate City Experience Pass',
      priceCents: 27900,
      imageAsset: 'assets/images/GreatWheel.JPG',
    ),
    Item(
      id: '3',
      name: 'Friends Pass: ScooTours Adventure, Pike Place - The Market Experience, Seattle Great Wheel, Beneath The Streets underground tour',
      description: 'Friends Pass - Shuttle & All-inclusive Ultimate City Experience Pass',
      priceCents: 18500,
      imageAsset: 'assets/images/m2g.JPG',
    ),
    Item(
      id: '4',
      name: 'Great Wheel - add on admission',
      description: 'Seattles Great Wheel - add on admission',
      imageAsset: 'assets/images/pikeplace.JPG',
      priceCents: 2500,
    ),
        Item(
      id: '5',
      name: 'New Years Eve Sunset on the Sound Cocktail Cruise',
      description: 'New Year’s Eve Sunset on the Sound. Celebrate the year’s end with a scenic cruise on Puget Sound! Enjoy festive music, city lights, and stunning views as the sun sets behind the Olympics and Seattle comes alive for New Year’s Eve.',
      priceCents: 25900,
      imageAsset: 'assets/images/private.JPG',
    ),
        Item(
      id: '6',
      name: 'Pike Place The Market Experience Tour',
      description: 'The Market Experience is a one-hour guided walking tour through the heart of Seattle’s iconic Pike Place Market. Led by a local storyteller, you’ll explore hidden corners, meet market makers, and learn the surprising history behind the Market’s shops.',
      priceCents: 4200,
      imageAsset: 'assets/images/Scootours.JPG',
    ),
        Item(
      id: '7',
      name: 'Private Seattle Waterfront ScooTour',
      description: 'Private ScooTour along the Waterfront - See Seattle Differently.',
      priceCents: 4900,
      imageAsset: 'assets/images/private.JPG',
    ),
        Item(
      id: '8',
      name: 'Seattle Sightseeing ScooTour',
      description: 'Guided Electric Scooter Ride along the Waterfront - See Seattle Differently.',
      priceCents: 3900,
      imageAsset: 'assets/images/Scootours.JPG',
    ),
        Item(
      id: '9',
      name: 'White Heron Cellars Tasting',
      description: 'Seattles Great Wheel - add on admission',
      priceCents: 3800,
      imageAsset: 'assets/images/wine.JPG',
    ),
  ];

  List<Item> get items => List.unmodifiable(_items);

  Item? findById(String id) {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }
}

class CartLine {
  final Item item;
  int quantity;

  CartLine({required this.item, required this.quantity});

  int get lineTotalCents => item.priceCents * quantity;
}

class CartModel extends ChangeNotifier {
  // key = itemId
  final Map<String, CartLine> _lines = {};

  List<CartLine> get lines => _lines.values.toList()
    ..sort((a, b) => a.item.name.compareTo(b.item.name));

  int get totalCents =>
      _lines.values.fold(0, (sum, line) => sum + line.lineTotalCents);

  String get totalText => _formatCents(totalCents);

  bool contains(String itemId) => _lines.containsKey(itemId);

  int quantityFor(String itemId) => _lines[itemId]?.quantity ?? 0;

  void add(Item item) {
    final existing = _lines[item.id];
    if (existing == null) {
      _lines[item.id] = CartLine(item: item, quantity: 1);
    } else {
      existing.quantity += 1;
    }
    notifyListeners();
  }

  void removeOne(Item item) {
    final existing = _lines[item.id];
    if (existing == null) return;

    existing.quantity -= 1;
    if (existing.quantity <= 0) {
      _lines.remove(item.id);
    }
    notifyListeners();
  }

  void removeAll(Item item) {
    _lines.remove(item.id);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}

class Order {
  final String id;
  final DateTime createdAt;
  final List<CartLine> purchasedLines;
  final int totalCents;

  Order({
    required this.id,
    required this.createdAt,
    required this.purchasedLines,
    required this.totalCents,
  });

  String get totalText => _formatCents(totalCents);
}

class OrdersModel extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrderFromCart(CartModel cart) {
    final copiedLines = cart.lines
        .map((l) => CartLine(item: l.item, quantity: l.quantity))
        .toList();

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      purchasedLines: copiedLines,
      totalCents: cart.totalCents,
    );

    _orders.insert(0, order);
    notifyListeners();
  }

  void clear() {
    _orders.clear();
    notifyListeners();
  }
}

/// -------------------------
/// UI
/// -------------------------
class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    final pages = [
      const CatalogScreen(),
      const CartScreen(),
      const OrdersScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('West Coast Tour Partners'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                'Cart: ${cart.totalText}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: pages[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('${cart.lines.length}'),
              isLabelVisible: cart.lines.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
        ],
        onDestinationSelected: (idx) => setState(() => _tabIndex = idx),
      ),
    );
  }
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogModel>();
    final cart = context.watch<CartModel>();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: catalog.items.length,
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,      // 👈 number of columns
      //   mainAxisSpacing: 12,    // vertical space
      //   crossAxisSpacing: 12,   // horizontal space
      //   childAspectRatio: 0.7,  // 👈 card shape (important!)
      // ),

      //edit grid size here
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 220,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.55,
      ),
  // 👆 END GRID DELEGATE
      itemBuilder: (context, index) {
        final item = catalog.items[index];
        final qty = cart.quantityFor(item.id);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(
                  item.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(item.priceText),

                      const Spacer(), // 👈 pushes button row to the bottom

                      if (qty == 0)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => cart.add(item),
                            child: const Text('Add'),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => cart.removeOne(item),
                              icon: const Icon(Icons.remove),
                            ),
                            Text('$qty'),
                            IconButton(
                              onPressed: () => cart.add(item),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}


// class CatalogScreen extends StatelessWidget {
//   const CatalogScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final catalog = context.watch<CatalogModel>();
//     final cart = context.watch<CartModel>();

//     return ListView.separated(
//       padding: const EdgeInsets.all(12),
//       itemCount: catalog.items.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (context, index) {
//         final item = catalog.items[index];
//         final qty = cart.quantityFor(item.id);

//         return Card(
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // AspectRatio(
//               //   aspectRatio: 16 / 9,
//               //   child: Image.asset(
//               //     item.imageAsset,
//               //     fit: BoxFit.cover,
//               //     errorBuilder: (context, error, stack) {
//               //       return const Center(child: Text('Image not found'));
//               //     },
//               //   ),
//               // ),
//               SizedBox(
//                 height: 180,
//                 width: 180,
//                 // width: double.infinity,
//                 child: Image.asset(
//                 item.imageAsset,
//                 fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(14),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.name,
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(item.description),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Text(
//                           item.priceText,
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                         const Spacer(),
//                         if (qty == 0)
//                         FilledButton.icon(
//                         onPressed: () => cart.add(item),
//                         icon: const Icon(Icons.add_shopping_cart),
//                         label: const Text('Add'),
//                         )
//                         else
//                           Row(
//                             children: [
//                               IconButton(
//                                 onPressed: () => cart.removeOne(item),
//                                 icon: const Icon(Icons.remove_circle_outline),
//                               ),
//                               Text('$qty', style: const TextStyle(fontSize: 16)),
//                               IconButton(
//                                 onPressed: () => cart.add(item),
//                                 icon: const Icon(Icons.add_circle_outline),
//                               ),
//                             ],
//                           ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ], 
//           ),
//         );
//       },
//     );
//   }
// }

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    if (cart.lines.isEmpty) {
      return const Center(
        child: Text('Your cart is empty. Add something from the Shop tab.'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: cart.lines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final line = cart.lines[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${line.item.priceText} x ${line.quantity} = ${_formatCents(line.lineTotalCents)}',
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => cart.removeOne(line.item),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      IconButton(
                        onPressed: () => cart.add(line.item),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      IconButton(
                        onPressed: () => cart.removeAll(line.item),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _CheckoutBar(),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final orders = context.read<OrdersModel>();

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total: ${cart.totalText}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton(
              onPressed: () async {
                // MOCK checkout flow:
                // In a real app, you would call a payment provider (Stripe, etc.).
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Purchase'),
                    content: Text('Purchase these items for ${cart.totalText}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Buy'),
                      ),
                    ],
                  ),
                );

                if (confirmed != true) return;

                orders.addOrderFromCart(cart);
                cart.clear();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Purchase complete (mock)!')),
                  );
                }
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersModel>();

    if (orders.orders.isEmpty) {
      return const Center(child: Text('No orders yet. Checkout from the cart.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: orders.orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = orders.orders[index];
        final date = order.createdAt;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text('Date: ${date.toLocal()}'),
                const SizedBox(height: 6),
                Text('Total: ${order.totalText}'),
                const Divider(height: 18),
                ...order.purchasedLines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• ${line.item.name} x ${line.quantity}'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
