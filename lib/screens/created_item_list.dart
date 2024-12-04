import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_logicflow/state/change_notifier.dart';
import 'package:pos_logicflow/state/model.dart';

class CreatedItemList extends ConsumerStatefulWidget {
  const CreatedItemList({super.key});

  @override
  ConsumerState<CreatedItemList> createState() => _CreatedItemListState();
}

class _CreatedItemListState extends ConsumerState<CreatedItemList> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 300).floor();
    // Riverpod state management
    final notifier = ref.read(provider.notifier);
    final productProvider = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: productProvider.product.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: crossAxisCount,
          ),
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Price Label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 40),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 241, 5, 115),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                        ),
                      ),
                      child: Text(
                        '${productProvider.product[index].price.toString()} Ks',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Product Name
                    Text(
                      productProvider.product[index].product,
                      style: const TextStyle(color: Colors.green, fontSize: 20),
                    ),
                    // Edit and Delete Buttons
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Edit Button
                          MaterialButton(
                            minWidth: screenWidth / 100,
                            color: const Color(0xFF6C63FF),
                            onPressed: () {
                              // Open Edit Dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  TextEditingController
                                      updatedProductController =
                                      TextEditingController(
                                          text: productProvider
                                              .product[index].product);
                                  TextEditingController updatedPriceController =
                                      TextEditingController(
                                          text: productProvider
                                              .product[index].price
                                              .toString());

                                  return AlertDialog(
                                    title: const Text('Edit Item Details'),
                                    content: Column(
                                      children: [
                                        // Product Input
                                        TextField(
                                          controller: updatedProductController,
                                          decoration: InputDecoration(
                                            hintText: "Product",
                                            labelText: "Product",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Price Input
                                        TextField(
                                          controller: updatedPriceController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(),
                                          decoration: InputDecoration(
                                            hintText: "Price",
                                            labelText: "Price",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Update Button
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MaterialButton(
                                              color: Colors.green,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            MaterialButton(
                                              color: Colors.blue,
                                              onPressed: () {
                                                final updatedProduct =
                                                    updatedProductController
                                                        .text;
                                                final updatedPrice =
                                                    double.tryParse(
                                                            updatedPriceController
                                                                .text) ??
                                                        0.0;

                                                if (updatedProduct.isNotEmpty &&
                                                    updatedPrice > 0) {
                                                  notifier.update(
                                                      index,
                                                      Model(updatedProduct,
                                                          updatedPrice));
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Update',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Edit Item',
                                style: TextStyle(color: Colors.white)),
                          ),
                          // Remove Button
                          MaterialButton(
                            minWidth: screenWidth / 20,
                            color: const Color.fromARGB(255, 240, 4, 16),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Rounded corners
                                    ),
                                    backgroundColor: Colors
                                        .white, // Set background color of the dialog
                                    title: const Text(
                                      'Are you sure you want to delete this item?',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'This action cannot be undone.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Cancel button
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close the dialog
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor: Colors
                                                    .grey[300], // Text color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                              ),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // Delete button
                                            ElevatedButton(
                                              onPressed: () {
                                                notifier.delete(index);
                                                Navigator.pop(
                                                    context); // Close the dialog
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Item Deleted',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors
                                                        .red, // Red background for Snackbar
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Colors.red, // Text color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                              ),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Remove Item',
                                style: TextStyle(color: Colors.white)),
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
    );
  }
}
