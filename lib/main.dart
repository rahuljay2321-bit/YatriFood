
import 'package:flutter/material.dart';

void main() => runApp(const YatriFoodApp());

class YatriFoodApp extends StatelessWidget {
  const YatriFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YatriFood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE85D24)),
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFBF7),
          foregroundColor: Color(0xFF242424),
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class FoodItem {
  final String name, description, emoji;
  final int price;
  const FoodItem(this.name, this.description, this.price, this.emoji);
}

class Restaurant {
  final String name, station, cuisine, time, rating, emoji;
  final List<FoodItem> menu;
  const Restaurant({
    required this.name, required this.station, required this.cuisine,
    required this.time, required this.rating, required this.emoji,
    required this.menu,
  });
}

const restaurants = <Restaurant>[
  Restaurant(
    name: 'Swaad Junction', station: 'Danapur', cuisine: 'North Indian • Thali',
    time: '25–35 min', rating: '4.6', emoji: '🍱',
    menu: [
      FoodItem('Veg Thali', 'Roti, rice, dal, sabzi, salad', 149, '🍱'),
      FoodItem('Paneer Thali', 'Paneer curry, dal, rice, 3 roti', 189, '🥘'),
      FoodItem('Jeera Rice & Dal', 'Comfort food combo', 119, '🍚'),
    ],
  ),
  Restaurant(
    name: 'Biryani Express', station: 'Patna Junction', cuisine: 'Biryani • Mughlai',
    time: '20–30 min', rating: '4.5', emoji: '🍛',
    menu: [
      FoodItem('Veg Biryani', 'Aromatic rice with vegetables', 139, '🍛'),
      FoodItem('Chicken Biryani', 'Chicken biryani with raita', 219, '🍗'),
      FoodItem('Paneer Roll', 'Spicy paneer in a soft roll', 99, '🌯'),
    ],
  ),
  Restaurant(
    name: 'Fresh Tiffin House', station: 'Gaya Junction', cuisine: 'Homestyle • Snacks',
    time: '25–40 min', rating: '4.4', emoji: '🥗',
    menu: [
      FoodItem('Mini Meal', 'Dal, rice, seasonal sabzi', 109, '🥗'),
      FoodItem('Aloo Paratha', '2 parathas with curd', 89, '🫓'),
      FoodItem('Veg Sandwich', 'Freshly prepared sandwich', 79, '🥪'),
    ],
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final trainController = TextEditingController();
  final stationController = TextEditingController(text: 'Patna Junction');
  final coachController = TextEditingController();
  final seatController = TextEditingController();
  final Map<FoodItem, int> cart = {};
  String search = '';

  int get itemCount => cart.values.fold(0, (a, b) => a + b);
  int get total => cart.entries.fold(0, (a, e) => a + e.key.price * e.value);

  @override
  void dispose() {
    trainController.dispose(); stationController.dispose();
    coachController.dispose(); seatController.dispose();
    super.dispose();
  }

  void add(FoodItem item) => setState(() => cart[item] = (cart[item] ?? 0) + 1);
  void remove(FoodItem item) => setState(() {
    final n = (cart[item] ?? 0) - 1;
    if (n <= 0) { cart.remove(item); } else { cart[item] = n; }
  });

  @override
  Widget build(BuildContext context) {
    final visible = restaurants.where((r) =>
      r.name.toLowerCase().contains(search.toLowerCase()) ||
      r.station.toLowerCase().contains(search.toLowerCase()) ||
      r.cuisine.toLowerCase().contains(search.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(width: 38, height: 38,
            decoration: BoxDecoration(color: const Color(0xFFE85D24), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.restaurant, color: Colors.white)),
          const SizedBox(width: 10),
          const Text('YatriFood', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: openCart,
            icon: Badge(label: Text('$itemCount'), isLabelVisible: itemCount > 0,
              child: const Icon(Icons.shopping_bag_outlined)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFE85D24), Color(0xFFFF945C)]),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('खाना अब आपकी सीट तक!', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('ट्रेन सफर में अपने पसंदीदा स्वाद का आनंद लें।', style: TextStyle(color: Colors.white, fontSize: 14)),
              SizedBox(height: 12),
              Row(children: [
                Icon(Icons.train, color: Colors.white), SizedBox(width: 6),
                Text('Order • Relax • Enjoy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('अपनी यात्रा की जानकारी', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _field(trainController, 'ट्रेन नंबर / नाम', Icons.train, keyboard: TextInputType.text),
          const SizedBox(height: 9),
          _field(stationController, 'डिलीवरी स्टेशन', Icons.location_on_outlined),
          const SizedBox(height: 9),
          Row(children: [
            Expanded(child: _field(coachController, 'कोच (जैसे B2)', Icons.airline_seat_recline_extra)),
            const SizedBox(width: 9),
            Expanded(child: _field(seatController, 'सीट नंबर', Icons.event_seat, keyboard: TextInputType.number)),
          ]),
          const SizedBox(height: 8),
          const Text('डेमो: यात्रा विवरण अभी मैन्युअल रूप से भरें। ट्रेन/PNR सत्यापन उपलब्ध नहीं है.',
            style: TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 22),
          const Text('लोकप्रिय रेस्टोरेंट', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            onChanged: (v) => setState(() => search = v),
            decoration: InputDecoration(
              hintText: 'रेस्टोरेंट या स्टेशन खोजें',
              prefixIcon: const Icon(Icons.search),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          ...visible.map(_restaurantCard),
          if (visible.isEmpty)
            const Padding(padding: EdgeInsets.all(24), child: Text('कोई रेस्टोरेंट नहीं मिला।')),
        ],
      ),
      bottomNavigationBar: itemCount == 0 ? null : SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton(
            onPressed: openCart,
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE85D24), padding: const EdgeInsets.all(15)),
            child: Text('कार्ट देखें • $itemCount आइटम • ₹$total'),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: c, keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint, prefixIcon: Icon(icon, size: 20),
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _restaurantCard(Restaurant r) => Card(
    color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFF0E7E0))),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        Container(width: 66, height: 66, alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFFFFF0E8), borderRadius: BorderRadius.circular(15)),
          child: Text(r.emoji, style: const TextStyle(fontSize: 34))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('${r.cuisine} • ${r.station}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 5),
          Text('★ ${r.rating}   •   ${r.time}', style: const TextStyle(fontSize: 12, color: Color(0xFF4C7A43))),
        ])),
        IconButton(onPressed: () => showMenu(r), icon: const Icon(Icons.arrow_forward_ios, size: 18)),
      ]),
    ),
  );

  void showMenu(Restaurant r) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: .72, maxChildSize: .92, minChildSize: .5,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(color: Color(0xFFFFFBF7), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: ListView(controller: controller, children: [
            Text(r.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            Text('${r.station} • ${r.cuisine}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ...r.menu.map((f) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(f.emoji, style: const TextStyle(fontSize: 29)),
              title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(f.description),
              trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('₹${f.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextButton(onPressed: () { add(f); Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${f.name} कार्ट में जोड़ा गया'))); },
                  child: const Text('ADD')),
              ]),
            )),
          ]),
        ),
      ),
    );
  }

  void openCart() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(
      cart: cart, train: trainController.text, station: stationController.text,
      coach: coachController.text, seat: seatController.text,
      onAdd: add, onRemove: remove,
    )));
  }
}

class CartPage extends StatefulWidget {
  final Map<FoodItem, int> cart;
  final String train, station, coach, seat;
  final void Function(FoodItem) onAdd, onRemove;
  const CartPage({super.key, required this.cart, required this.train, required this.station,
    required this.coach, required this.seat, required this.onAdd, required this.onRemove});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get total => widget.cart.entries.fold(0, (a, e) => a + e.key.price * e.value);

  @override
  Widget build(BuildContext context) {
    final entries = widget.cart.entries.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('आपका कार्ट')),
      body: entries.isEmpty
        ? const Center(child: Text('कार्ट खाली है'))
        : ListView(padding: const EdgeInsets.all(16), children: [
            ...entries.map((e) => Card(
              color: Colors.white, elevation: 0,
              child: ListTile(
                leading: Text(e.key.emoji, style: const TextStyle(fontSize: 28)),
                title: Text(e.key.name),
                subtitle: Text('₹${e.key.price} × ${e.value}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(onPressed: () { widget.onRemove(e.key); setState(() {}); }, icon: const Icon(Icons.remove_circle_outline)),
                  Text('${e.value}'),
                  IconButton(onPressed: () { widget.onAdd(e.key); setState(() {}); }, icon: const Icon(Icons.add_circle_outline)),
                ]),
              ),
            )),
            const SizedBox(height: 12),
            _summary('खाने का कुल', '₹$total'),
            _summary('डिलीवरी शुल्क', 'अभी तय नहीं'),
            const Divider(),
            _summary('कुल (डेमो)', '₹$total', bold: true),
            const SizedBox(height: 18),
            const Text('डिलीवरी विवरण', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('ट्रेन: ${widget.train.isEmpty ? "नहीं भरी" : widget.train}'),
            Text('स्टेशन: ${widget.station}'),
            Text('कोच: ${widget.coach.isEmpty ? "नहीं भरा" : widget.coach}  |  सीट: ${widget.seat.isEmpty ? "नहीं भरी" : widget.seat}'),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () {
                if (widget.train.trim().isEmpty || widget.station.trim().isEmpty ||
                    widget.coach.trim().isEmpty || widget.seat.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कृपया ट्रेन, स्टेशन, कोच और सीट की जानकारी भरें।')));
                  return;
                }
                final orderId = 'YF${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderSuccessPage(orderId: orderId, total: total)));
              },
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE85D24), padding: const EdgeInsets.all(16)),
              child: const Text('डेमो ऑर्डर कन्फर्म करें'),
            ),
            const SizedBox(height: 8),
            const Text('यह केवल टेस्ट ऑर्डर है। रेस्टोरेंट को वास्तविक ऑर्डर नहीं भेजा जाएगा।',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black54)),
          ]),
    );
  }

  Widget _summary(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: bold ? const Color(0xFFE85D24) : null)),
    ]),
  );
}

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final int total;
  const OrderSuccessPage({super.key, required this.orderId, required this.total});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('ऑर्डर स्टेटस')),
    body: Center(child: Padding(
      padding: const EdgeInsets.all(26),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 82),
        const SizedBox(height: 16),
        const Text('डेमो ऑर्डर सफल!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('ऑर्डर ID: $orderId', style: const TextStyle(color: Colors.black54)),
        Text('कुल राशि: ₹$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        const Text('यह ऑर्डर केवल ऐप का फ्लो जाँचने के लिए है। अभी किसी होटल या डिलीवरी पार्टनर को नहीं भेजा गया।',
          textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE85D24)),
          child: const Text('होम पर जाएँ')),
      ]),
    )),
  );
}
