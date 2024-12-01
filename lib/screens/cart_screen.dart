import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_logicflow/state/change_notifier.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Expanded(
          flex: 2,
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8E44AD), // Bold purple for cart header
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                                      fontSize: 14, color: Colors.green),
                                ),
                              ),
                            );
                          }),
                    )),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: const BoxDecoration(
                      color: Color(
                          0xFF8E44AD), // Warm golden yellow for 'Total Price'
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          'Total Price      ${ref.watch(provider).totalPrice.toStringAsFixed(2)} Ks',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
