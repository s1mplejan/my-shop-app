import 'package:flutter/material.dart';
import 'package:mening_dokonim/models/product.dart';
import 'package:mening_dokonim/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();
  var _product = Product(
    id: '',
    title: '',
    discription: '',
    price: 0,
    imageUrl: '',
    isFavorite: false,
  );

  var _hasImage = true;
  var _init = true;
  var _isLoading = false;
  // final priceFocus = FocusNode();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        final _editingProduct =
            Provider.of<Products>(context).findByID(productId.toString());
        _product = _editingProduct;
      }
      _init = false;
    }
  }

// @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     priceFocus.dispose();
//   }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Rasm URL ni kiriting!'),
          content: Form(
            key: _imageForm,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Rasm URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              onSaved: (newValue) {
                _product = Product(
                  id: _product.id,
                  title: _product.title,
                  discription: _product.discription,
                  price: _product.price,
                  imageUrl: newValue!,
                  isFavorite: _product.isFavorite,
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos rasm URL ni kiriting!";
                } else if (!value.startsWith('http')) {
                  return "To'g'ri rasm URL kiriting";
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: _saveImageForm,
              child: const Text('Saqlash'),
            )
          ],
        );
      },
    );
  }

  void _saveImageForm() {
    bool isValid = _imageForm.currentState!.validate();
    if (isValid) {
      _imageForm.currentState!.save();
      setState(() {
        _hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    bool isValid = _form.currentState!.validate();
    setState(() {
      _hasImage = _product.imageUrl.isNotEmpty;
    });
    if (isValid && _hasImage) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Xatolik!'),
                  content:
                      const Text('Mahsulot qo\'shishda xatolik sodir b\'ldi.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Okey'),
                    ),
                  ],
                );
              });
        }
        // finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }
      } else {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_product);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mahsulot qo\'shish'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _product.title,
                        decoration: const InputDecoration(
                          labelText: 'Nomi',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: newValue!,
                            discription: _product.discription,
                            price: _product.price,
                            imageUrl: _product.imageUrl,
                            isFavorite: _product.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos , mahsulot nomini kiriting!';
                          }
                        },
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(priceFocus);
                        // },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _product.price == 0
                            ? ''
                            : _product.price.toStringAsFixed(2),
                        decoration: const InputDecoration(
                          labelText: 'Narxi',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            discription: _product.discription,
                            price: double.parse(newValue!),
                            imageUrl: _product.imageUrl,
                            isFavorite: _product.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Iltimos, narxni kiriting!';
                          } else if (double.tryParse(value) == null) {
                            return 'Iltimos to\'g\'ri narx kiriting!';
                          } else if (double.parse(value) <= 0) {
                            return 'Mahsulot narxi 0 dan katta bo\'lishi kerak!';
                          }
                        },
                        // focusNode: priceFocus,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _product.discription,
                        decoration: const InputDecoration(
                          labelText: 'Qo\'shimcha malumot',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            discription: newValue!,
                            price: _product.price,
                            imageUrl: _product.imageUrl,
                            isFavorite: _product.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Iltimos mahsulot ta'rifini kiriting!";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: _hasImage
                                ? Colors.grey
                                : Theme.of(context).errorColor,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _showImageDialog(context),
                          splashColor:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5),
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: _product.imageUrl.isEmpty
                                ? Text(
                                    'Asosiy rasam URL ni kiriting',
                                    style: TextStyle(
                                      color: _hasImage
                                          ? Colors.black
                                          : Theme.of(context).errorColor,
                                    ),
                                  )
                                : Image.network(
                                    _product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
