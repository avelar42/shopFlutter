import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocus);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Preco'),
              textInputAction: TextInputAction.next,
              focusNode: _priceFocus,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
