import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  void _updateImage() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  void _saveForm() {
    _form.currentState?.save();

    final newProduct = new Product(
      id: Random().nextDouble().toString(),
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    print('Product - id: ${newProduct.id}');
    print('Product - title: ${newProduct.title}');
    print('Product - price: ${newProduct.price}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário Produto'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text('Título')),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Preço')),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Descrição')),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formData['description'] = value,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      decoration:
                          const InputDecoration(labelText: 'URL da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) => _formData['imageUrl'] = value,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Informe a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
