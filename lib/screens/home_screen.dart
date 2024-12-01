import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_logicflow/screens/cart_screen.dart';
import 'package:pos_logicflow/screens/create_item.dart';
import 'package:pos_logicflow/state/change_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (MediaQuery.of(context).size.width / 300).floor();
    final notifier = ref.read(provider.notifier);
    final productProvider = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CreateItem())); // Could be renamed to ProductManagementScreen or AdminDashboard.
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Admin Dashboard",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 184, 255),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          )
        ],
        title: Text(
          'SquareSpace POS System',
          style: GoogleFonts.podkova(
            fontSize: 20,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor:
            Colors.deepPurpleAccent, // Modern purple tone for the app bar
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(builder: (context, constrants) {
            if (constrants.maxWidth > 1100) {
              return Row(
                children: [
                  // Product Section
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Color(
                                0xFF3B9A8C), // Fresh mint green for header
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Available Products',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: productProvider.product.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: crossAxisCount,
                            ),
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 40),
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(17),
                                              bottomRight: Radius.circular(17),
                                            )),
                                        child: Text(
                                          '${productProvider.product[index].price.toString()} Ks',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Text(
                                        productProvider.product[index].product,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 61, 61, 68),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MaterialButton(
                                              minWidth: screenWidth / 100,
                                              color: const Color(
                                                  0xFF6C63FF), // Bright periwinkle for 'Reduce' button
                                              onPressed: () {
                                                notifier.reduceQuantity(
                                                    productProvider
                                                        .product[index]);
                                              },
                                              child: const Text(
                                                'Reduce',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            MaterialButton(
                                              minWidth: screenWidth / 20,
                                              color: const Color(
                                                  0xFF0C7B93), // Muted teal for 'Add' button
                                              onPressed: () {
                                                notifier.addtoCart(
                                                    productProvider
                                                        .product[index]);
                                              },
                                              child: const Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Cart Section
                  SizedBox(
                    width: screenWidth / 70,
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                              decoration: const BoxDecoration(
                                color: Color(
                                    0xFF8E44AD), // Bold purple for cart header
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Your Cart',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 12,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListView.builder(
                                    itemCount: productProvider.cart.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          leading: Text(
                                            productProvider.cart[index].product,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          trailing: Text(
                                            'Price ${productProvider.cart[index].price.toString()} * ${productProvider.cart[index].qty.toString()} = ${productProvider.cart[index].qty * productProvider.cart[index].price} Ks',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green),
                                          ),
                                        ),
                                      );
                                    }),
                              )),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                              decoration: const BoxDecoration(
                                color: Color(
                                    0xFF8E44AD), // Warm golden yellow for 'Total Price'
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    'Total Price      ${ref.watch(provider).totalPrice.toStringAsFixed(2)} Ks',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Cart'),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen()));
                          },
                          icon: Icon(Icons.shopping_cart),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Color(
                                0xFF3B9A8C), // Fresh mint green for header
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Available Products',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: productProvider.product.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: crossAxisCount,
                            ),
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 40),
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(17),
                                              bottomRight: Radius.circular(17),
                                            )),
                                        child: Text(
                                          '${productProvider.product[index].price.toString()} Ks',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Text(
                                        productProvider.product[index].product,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 61, 61, 68),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MaterialButton(
                                              color: const Color(
                                                  0xFF6C63FF), // Bright periwinkle for 'Reduce' button
                                              onPressed: () {
                                                notifier.reduceQuantity(
                                                    productProvider
                                                        .product[index]);
                                              },
                                              child: const Text(
                                                'Reduce',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            MaterialButton(
                                              color: const Color(
                                                  0xFF0C7B93), // Muted teal for 'Add' button
                                              onPressed: () {
                                                notifier.addtoCart(
                                                    productProvider
                                                        .product[index]);
                                              },
                                              child: const Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          })),
    );
  }
}
