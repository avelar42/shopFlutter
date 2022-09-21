import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
    this.product, {
    Key? key,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Excluir Produto'),
                            content: Text('Tem certeza?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text('Nao')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                  child: Text('Sim')),
                            ],
                          )).then((value) async {
                    if (value ?? false) {
                      try {
                        await Provider.of<ProductList>(context, listen: false)
                            .removeProduct(product);
                      } on HttpException catch (error) {
                        msg.showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    }
                  });
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor)
          ],
        ),
      ),
    );
  }
}
