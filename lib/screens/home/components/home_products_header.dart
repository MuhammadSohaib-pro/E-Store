import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class HomeProductsHeader extends StatelessWidget {
  const HomeProductsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Feature Products',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              AutoRouter.of(context).pushPath('/products');
            },
            child: Text("Show All", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
