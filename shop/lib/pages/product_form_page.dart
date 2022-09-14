import 'package:flutter/material.dart';

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
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocus);
              },
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descricao'),
              focusNode: _descriptionFocus,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
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
