import 'package:bwys/config/application.dart';
import 'package:bwys/shared/bloc/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Add Product", style: Theme.of(context).textTheme.headline6),
      ),
      body: Container(padding: EdgeInsets.all(20.0), child: AddProductFrom()),
    );
  }
}

class AddProductFrom extends StatefulWidget {
  const AddProductFrom({Key? key}) : super(key: key);

  @override
  _AddProductFromState createState() => _AddProductFromState();
}

class _AddProductFromState extends State<AddProductFrom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Map<String, dynamic>? _imageResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is AddProductMessage) {
          if (state.productAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Product Successfully Addedd")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${state.errorMessage}")),
            );
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Product Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Product Name';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(),
                helperMaxLines: 2,
              ),
              onChanged: (value) {},
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Decription';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                hintText: "Price",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        _imageResponse = await Application.nativeAPIService
                            ?.pickImage(ImageSource.camera);
                        if (_imageResponse!.containsKey('error')) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(_imageResponse!['error'])));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Image Added Successfully")),
                          );
                        }
                      },
                      child: Icon(Icons.add_a_photo, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text("Add Product"),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<ProductBloc>(context)
                            .add(AddProductData(
                          productData: {
                            "name": _nameController.text,
                            "description": _descriptionController.text,
                            "price": num.parse(_priceController.text),
                            "image": _imageResponse?["image"],
                          },
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
