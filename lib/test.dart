import 'package:flutter/material.dart';
import 'package:gd8_library_xxxx/model/product.dart';

class Coba extends StatefulWidget {
  const Coba({super.key});

  @override
  State<Coba> createState() => _CobaState();
}

class _CobaState extends State<Coba> {
  List<Product> products = [
    Product("Membership", 9.99, 19),
    Product("Nails", 0.30, 19),
    Product("Hammer", 26.43, 19),
    Product("Hamburger", 5.99, 7),
  ];
  int number = 0;
  getTotal() => products
      .fold(0.0,
          (double prev, element) => prev + (element.price * element.amount))
      .toStringAsFixed(2);

  getVat() => products
      .fold(
          0.0,
          (double prev, element) =>
              prev +
              (element.price / 100 * element.vatInPercent * element.amount))
      .toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final currentProduct = products[index];
                    return Row(
                      children: [
                        Expanded(child: Text(currentProduct.name)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "Price: ${currentProduct.price.toStringAsFixed(2)} €"),
                              Text(
                                  "VAT ${currentProduct.vatInPercent.toStringAsFixed(0)} %")
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() => currentProduct.amount++);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  currentProduct.amount.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() => currentProduct.amount--);
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: products.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text("VAT"), Text("${getVat()} €")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text("Total"), Text("${getTotal()} €")],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
