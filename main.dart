import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/product_detail_screen.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';






void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatalogModel()),
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => OrdersModel()),
        ChangeNotifierProvider(create: (_) => TicketsModel()),
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
        scaffoldBackgroundColor: Colors.yellow,
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

  // NEW: short text for the card + full text for the detail page
  final String shortDescription;
  final String description;

  final int priceCents;

  // Keep assets, but also allow URL images for items you add in Store
  final String? imageAsset;
  final String? imageUrl;

  // NEW: ratings
  final double rating; // e.g. 4.7
  final int ratingCount;

  const Item({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.priceCents,
    this.imageAsset,
    this.imageUrl,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  String get priceText => _formatCents(priceCents);
}

Widget productImage(Item item) {
  if (item.imageUrl != null && item.imageUrl!.trim().isNotEmpty) {
    return Image.network(
      item.imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) =>
          const Center(child: Text('Image failed')),
    );
  }

  if (item.imageAsset != null && item.imageAsset!.trim().isNotEmpty) {
    return Image.asset(
      item.imageAsset!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) =>
          const Center(child: Text('Image not found')),
    );
  }

  return const Center(child: Text('No image'));
}

String _formatCents(int cents) {
  final dollars = cents / 100.0;
  return '\$${dollars.toStringAsFixed(2)}';
}

class CatalogModel extends ChangeNotifier {
  // In a real app, this list would come from an API.
  final List<Item> _items = [
    Item(
      id: '1',
      name: 'Cocktails And Stories From Pike Place Market',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'Discover Seattle’s Pike Place Market through its flavors, then a hands-on cocktail class with founder Bryan Jarr or one of his staff. You’ll shop the Market for fresh ingredients, learn mixology techniques, and craft signature Northwest cocktails',
      priceCents: 13500,
      imageAsset: 'assets/images/m2g.JPG',
      rating: 4.8,
      ratingCount: 214,
    ),
    Item(
      id: '2',
      name: 'Elite - Luxury Shuttle & Best Day in Seattle',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'Elite is our premium, all-inclusive way to experience the very best of Seattle in total comfort and style. Guests enjoy private luxury transportation paired with expertly curated sightseeing and experiences, creating a seamless “best day in Seattle” without stress, crowds, or logistics. From iconic landmarks to hidden gems, Elite delivers a personalized, first-class Seattle adventure from start to finish.',
      priceCents: 27900,
      imageAsset: 'assets/images/vip.JPG',
      rating: 4.8,
      ratingCount: 214,
    ),
    Item(
      id: '3',
      name: 'Friends Pass: ScooTours Adventure, Pike Place - The Market Experience, Seattle Great Wheel, Beneath The Streets underground tour',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'Friends Pass - Shuttle & All-inclusive Ultimate City Experience Pass',
      priceCents: 18500,
      imageAsset: 'assets/images/m2g.JPG',
      rating: 4.8,
      ratingCount: 214,
    ),
    Item(
      id: '4',
      name: 'Great Wheel - add on admission',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'Enhance any of our tours with an optional ride on the Seattle Great Wheel. This easy add-on gives guests breathtaking views of Elliott Bay, the skyline, and Mount Rainier—without the hassle of separate tickets or lines. It’s the perfect way to elevate your Seattle experience and capture unforgettable photos.',
      imageAsset: 'assets/images/GreatWheel.JPG',
      priceCents: 2500,
      rating: 4.8,
      ratingCount: 214,
    ),
        Item(
      id: '5',
      name: 'New Years Eve Sunset on the Sound Cocktail Cruise',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'New Year’s Eve Sunset on the Sound. Celebrate the year’s end with a scenic cruise on Puget Sound! Enjoy festive music, city lights, and stunning views as the sun sets behind the Olympics and Seattle comes alive for New Year’s Eve.',
      priceCents: 25900,
      imageAsset: 'assets/images/sunset.JPG',
      rating: 4.8,
      ratingCount: 214,
    ),
        Item(
      id: '6',
      name: 'Pike Place The Market Experience Tour',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'Our Pike Place Market Experience Tour is a 90-minute guided walk through the sights, smells, and hidden secrets of Seattle’s most famous landmark. Guests go beyond the obvious to discover tucked-away corners, legendary vendors, and stories most visitors never hear. It’s an insider’s look at Pike Place that transforms a busy market into a rich, memorable experience.',
      priceCents: 4200,
      imageAsset: 'assets/images/pikeplace.JPG',
      rating: 4.8,
      ratingCount: 214,
    ),
        Item(
      id: '7',
      name: 'Private Seattle Waterfront ScooTour',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'This private ScooTour offers an exclusive way to explore Seattle’s iconic waterfront at your own pace. Guests ride comfortably through scenic paths, piers, and viewpoints while a knowledgeable guide shares stories of Seattle’s maritime history, culture, and modern transformation. Perfect for couples, families, and special occasions, this tour blends privacy, fun, and unforgettable views.',
      priceCents: 4900,
      imageAsset: 'assets/images/private.JPG',
      rating: 4.8,
      ratingCount: 214,
    ),
        Item(
      id: '8',
      name: 'Seattle Sightseeing ScooTour',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'Our 90-minute Seattle Sightseeing ScooTour packs the city’s most popular downtown sights and sounds into one effortless adventure. Guests cover far more ground than a walking tour while avoiding fatigue, all while guided by local experts who bring Seattle’s vibe to life. It’s the perfect introduction to the city and an ideal way to identify favorite spots to explore further—great for both small and large groups.',
      priceCents: 3900,
      imageAsset: 'assets/images/Scootours.JPG',
      rating: 4.8,
      ratingCount: 214,
    ),
        Item(
      id: '9',
      name: 'White Heron Cellars Tasting',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'White Heron Cellars is located in the middle of our vineyard property in the ghost town of Trinidad, between Quincy and Wenatchee, above the Columbia River in Washington State.The winery started making wine in 1986 with a Washington State Pinot Noir. In the spring of 1988, White Heron released the 1986 Pinot Noir and the 1987 Dry Riesling. Subsequent vintages of these wines have been released and in 1990 White Heron added the 1988 Chantepierre - a meritage type blend of Cabernet Savignon, Cabernet Franc, and Merlot. Current vintages are made with grapes from our own vineyards and from selected Columbia Valley growers. Each wine is unique in style and creates its own niche in the wine world.',
      priceCents: 3800,
      imageAsset: 'assets/images/wines.png',
      rating: 4.8,
      ratingCount: 214,
    ),
        Item(
      id: '10',
      name: 'Beneath the Streets Underground Tour',
      shortDescription: 'Market ingredients + hands-on cocktail class.',
      description: 'Beneath the Streets offers boutique underground tours that provide authentic,one-of-a-kind, explorations of Seattles historic underground passageways in Pioneer Square, the city’s original neighborhood. Our one hour walking tours are led by experienced  and engaging guides who are passionate about Seattles rich history. Each tour is unscripted, making every experience unique. Our guides also share insider tips and local favorites to enhance your visit!',
      priceCents: 3800,
      imageAsset: 'assets/images/street.png',
      rating: 4.8,
      ratingCount: 214,
    ),
  ];

  final List<Item> _storeItems = [
    Item(
      id: 's1',
      name: 'Captain Mikes List',
      shortDescription: 'Send your loved ones the best gift captain mike could wrandgle up',
      description:
          'Mike has selected the following from the market just for you',
      priceCents: 49900,
      imageAsset: 'assets/images/shopping.webp',
      rating: 4.9,
      ratingCount: 322,
    ),
    Item(
      id: 's2',
      name: 'Jackies Box',
      shortDescription: 'Send your loved ones the best gifts from our celebrity shopper',
      description:
          'Jackies gift box includes',
      priceCents: 79900,
      imageAsset: 'assets/images/gift.webp',
      rating: 4.7,
      ratingCount: 180,
    ),
    // Add as many Store items as you want here
  ];

  List<Item> get items => List.unmodifiable(_items);
  List<Item> get storeItems => List.unmodifiable(_storeItems);

  Item? findById(String id) {
    // optional: search BOTH lists
    final all = [..._items, ..._storeItems];
    try {
      return all.firstWhere((i) => i.id == id);
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

class Ticket {
  final String id; // unique
  final String title;
  final String description;
  final String imageAsset;
  final String barcodeNumber; // what the barcode encodes
  final String qrData;        // what the QR encodes (could be same as barcodeNumber)

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.barcodeNumber,
    required this.qrData,
  });
}

class TicketsModel extends ChangeNotifier {
  final List<Ticket> _tickets = const [
    Ticket(
      id: 't1',
      title: 'Pike Place Cocktail Experience',
      description: 'Show this ticket at check-in. Valid for 1 entry.',
      imageAsset: 'assets/images/WCTPlogo.png',
      barcodeNumber: '123456789012',
      qrData: 'WCTP-TICKET-t1-123456789012',
    ),
    Ticket(
      id: 't2',
      title: 'Seattle Great Wheel Add-on',
      description: 'Present this ticket at the gate. Valid for 1 ride.',
      imageAsset: 'assets/images/WCTPlogo.png',
      barcodeNumber: '987654321098',
      qrData: 'WCTP-TICKET-t2-987654321098',
    ),
  ];

  List<Ticket> get tickets => List.unmodifiable(_tickets);
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
      const CatalogScreen(),  // Shop
      const StoreScreen(),    // Store
      const CartScreen(),     // Cart
      const OrdersScreen(),   // Orders
      const TicketsScreen(),  // Tickets
    ];



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
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
          const NavigationDestination(
            icon: Icon(Icons.add_business),
            label: 'Store',
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
          const NavigationDestination(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
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
      childAspectRatio: 0.45,
      ),
      // 👆 END GRID DELEGATE
      itemBuilder: (context, index) {
        final item = catalog.items[index];
        final qty = cart.quantityFor(item.id);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(item: item),
              ),
            );
          },
          child: Card(
            color: Colors.orange,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: productImage(item),
                ),

                // ✅ this part scrolls/shrinks safely inside the grid tile
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

                        const SizedBox(height: 6),
                        Text(
                          item.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16),
                            const SizedBox(width: 4),
                            Text(item.rating.toStringAsFixed(1)),
                            const SizedBox(width: 6),
                            Text('(${item.ratingCount})'),
                          ],
                        ),

                        const Spacer(), // ✅ pushes buttons to bottom safely

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

          ),
        );
      },

    );
  }
}
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogModel>();
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        backgroundColor: Colors.orange,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: catalog.storeItems.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.45,
        ),
        itemBuilder: (context, index) {
          final item = catalog.storeItems[index];
          final qty = cart.quantityFor(item.id);

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(item: item),
                ),
              );
            },
            child: Card(
              color: Colors.orange,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: productImage(item),
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
                          const SizedBox(height: 6),
                          Text(
                            item.shortDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16),
                              const SizedBox(width: 4),
                              Text(item.rating.toStringAsFixed(1)),
                              const SizedBox(width: 6),
                              Text('(${item.ratingCount})'),
                            ],
                          ),
                          const Spacer(),
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
            ),
          );
        },
      ),
    );
  }
}



class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketsModel = context.watch<TicketsModel>();
    final tickets = ticketsModel.tickets;

    if (tickets.isEmpty) {
      return const Center(child: Text('No tickets yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final t = tickets[index];

        return Card(
          color: Colors.orange, // matches your card styling
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image on top
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    t.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return const Center(child: Text('Ticket image not found'));
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  t.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(t.description),

                const SizedBox(height: 14),

                // Barcode number + barcode
                Text(
                  'Barcode: ${t.barcodeNumber}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 90,
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: t.barcodeNumber,
                    drawText: false,
                  ),
                ),

                const SizedBox(height: 14),

                // QR code
                const Text(
                  'QR Code',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Center(
                  child: QrImageView(
                    data: t.qrData,
                    size: 180,
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
