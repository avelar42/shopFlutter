import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

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

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocus.addListener(UpdateImage);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
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

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithfile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithfile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro'),
                content: Text(
                    'Ocorreu um erro ao salvar o produto. Favor entrar em contato com o suporte'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Ok!'))
                ],
              ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name']?.toString(),
                        decoration: InputDecoration(labelText: 'Nome'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (name) => _formData['name'] = name ?? '',
                        validator: (_name) {
                          final name = _name ?? '';
                          if (name.trim().isEmpty) {
                            return 'Nome e obrigatorio';
                          }
                          if (name.trim().length < 3) {
                            return 'Min 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price']?.toString(),
                        decoration: InputDecoration(labelText: 'Preco'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        onSaved: (price) =>
                            _formData['price'] = double.parse(price ?? '0'),
                        validator: (_price) {
                          final priceString = _price ?? '';
                          final price = double.tryParse(priceString) ?? -1;
                          if (price <= 0) {
                            return 'Informe um valor valido!';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      TextFormField(
                        initialValue: _formData['description']?.toString(),
                        decoration: InputDecoration(labelText: 'Descricao'),
                        focusNode: _descriptionFocus,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (description) =>
                            _formData['description'] = description ?? '',
                        validator: (_description) {
                          final description = _description ?? '';
                          if (description.trim().isEmpty) {
                            return 'Descricao e obrigatorio';
                          }
                          if (description.trim().length < 10) {
                            return 'Min 10 caracteres';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Url da Imagem'),
                              focusNode: _imageUrlFocus,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) => _submitForm(),
                              onSaved: (imageUrl) =>
                                  _formData['imageUrl'] = imageUrl ?? '',
                              validator: (_imageUrl) {
                                final imageUrl = _imageUrl ?? '';
                                if (!isValidImageUrl(imageUrl)) {
                                  return 'Informe uma Url valida!';
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? Text('Informe a url')
                                : Image.network(_imageUrlController.text),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
