import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_logicflow/screens/created_item_list.dart';
import 'package:pos_logicflow/state/change_notifier.dart';
import 'package:pos_logicflow/state/model.dart';

class CreateItem extends ConsumerStatefulWidget {
  const CreateItem({super.key});

  @override
  ConsumerState<CreateItem> createState() => _HomeState();
}

class _HomeState extends ConsumerState<CreateItem> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 300).floor();

    // Controllers for product name and price
    TextEditingController productController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    // Riverpod state management
    final notifier = ref.read(provider.notifier);
    final productProvider = ref.watch(provider);

    return Scaffold(
        appBar: AppBar(
          elevation: 50,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(
                255, 248, 247, 247), // Change the color of the back arrow
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          backgroundColor: const Color.fromARGB(255, 27, 27, 26),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(color: Color.fromARGB(255, 135, 250, 21)),
          ),
        ),
        body: LayoutBuilder(builder: (context, constrants) {
          if (constrants.maxWidth > 1000) {
            return Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            child: Text(
                              'SquareSpace',
                              style: GoogleFonts.podkova(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          // Product Input
                          TextField(
                            controller: productController,
                            decoration: InputDecoration(
                              hintText: "Product",
                              labelText: "Product",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Price Input
                          TextField(
                            controller: priceController,
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              hintText: "Price",
                              labelText: "Price",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Create Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              final product = productController.text;
                              final price =
                                  double.tryParse(priceController.text) ?? 0.0;

                              // Only save if valid product and price
                              if (product.isNotEmpty && price > 0) {
                                notifier.save(Model(product, price));
                              }
                            },
                            child: const Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Product Display Section
                Expanded(
                  flex: 3,
                  child: Padding(
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
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                                // Edit and Delete Buttons
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                                          .product[index]
                                                          .product);
                                              TextEditingController
                                                  updatedPriceController =
                                                  TextEditingController(
                                                      text: productProvider
                                                          .product[index].price
                                                          .toString());

                                              return AlertDialog(
                                                title: const Text(
                                                    'Edit Item Details'),
                                                content: Column(
                                                  children: [
                                                    // Product Input
                                                    TextField(
                                                      controller:
                                                          updatedProductController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Product",
                                                        labelText: "Product",
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    // Price Input
                                                    TextField(
                                                      controller:
                                                          updatedPriceController,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Price",
                                                        labelText: "Price",
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    // Update Button
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        MaterialButton(
                                                          color: Colors.green,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'Cancel'),
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

                                                            if (updatedProduct
                                                                    .isNotEmpty &&
                                                                updatedPrice >
                                                                    0) {
                                                              notifier.update(
                                                                  index,
                                                                  Model(
                                                                      updatedProduct,
                                                                      updatedPrice));
                                                            }
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Update',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      // Remove Button
                                      MaterialButton(
                                        minWidth: screenWidth / 20,
                                        color: const Color.fromARGB(
                                            255, 240, 4, 16),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      'This action cannot be undone.',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        // Cancel button
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.black,
                                                            backgroundColor: Colors
                                                                    .grey[
                                                                300], // Text color
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                          ),
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        // Delete button
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            notifier
                                                                .delete(index);
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Item Deleted',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .red, // Red background for Snackbar
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor: Colors
                                                                .red, // Text color
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                          ),
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                            style:
                                                TextStyle(color: Colors.white)),
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
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CreatedItemList()));
                            },
                            child: const Text(
                              'Show Product List',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 80,
                    child: Text(
                      'SquareSpace',
                      style: GoogleFonts.podkova(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Product Input
                  TextField(
                    controller: productController,
                    decoration: InputDecoration(
                      hintText: "Product",
                      labelText: "Product",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Price Input
                  TextField(
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      hintText: "Price",
                      labelText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Create Button

                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      final product = productController.text;
                      final price =
                          double.tryParse(priceController.text) ?? 0.0;

                      // Only save if valid product and price
                      if (product.isNotEmpty && price > 0) {
                        notifier.save(Model(product, price));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CreatedItemList()));
                      }
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }
}
