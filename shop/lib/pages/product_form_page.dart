import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocus.addListener(UpdateImage);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(UpdateImage);
    _imageUrlFocus.dispose();
  }

  void UpdateImage() {
    setState(() {});
  }

  void _submitForm() {
    _formKey.currentState?.save();
    final newProduct = Product(
        id: Random().nextDouble().toString(),
        name: _formData['name'] as String,
        description: _formData['description'] as String,
        imageUrl: _formData['imageUrl'] as String,
        price: _formData['price'] as double);
    print(newProduct.id);
    print(newProduct.name);
    print(newProduct.price);
    print(newProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocus);
                  },
                  onSaved: (name) => _formData['name'] = name ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Preco'),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocus);
                  },
                  onSaved: (price) =>
                      _formData['price'] = double.parse(price ?? '0'),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descricao'),
                  focusNode: _descriptionFocus,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onSaved: (description) =>
                      _formData['description'] = description ?? '',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Url da Imagem'),
                        focusNode: _imageUrlFocus,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onFieldSubmitted: (_) => _submitForm(),
                        onSaved: (imageUrl) =>
                            _formData['imageUrl'] = imageUrl ?? '',
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1)),
                      alignment: Alignment.center,
                      child: _imageUrlController.text.isEmpty
                          ? Text('Informe a url')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
