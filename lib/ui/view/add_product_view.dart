import 'package:flutter/material.dart';
import 'package:todoapp/core/api_service.dart';
import 'package:todoapp/core/model/product.dart';

class AddProductView extends StatefulWidget {
  final String? id;
  final Products? productToEdit;

  const AddProductView({Key? key, this.id, this.productToEdit})
      : super(key: key);

  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDay = TextEditingController();
  final TextEditingController controllerImage = TextEditingController();

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      controllerName.text = widget.productToEdit!.productName ?? '';
      controllerDay.text = widget.productToEdit!.day ?? '';
      controllerImage.text = widget.productToEdit!.imageURL ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: controllerName,
                validator: validator,
                decoration: InputDecoration(
                  labelText: "Task Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: controllerDay,
                validator: validator,
                decoration: InputDecoration(
                  labelText: "Day",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: controllerImage,
                validator: validator,
                decoration: InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed with adding or editing
                    var model = Products(
                      productName: controllerName.text,
                      day: controllerDay.text,
                      imageURL: controllerImage.text,
                    );

                    if (widget.id == null) {
                      // Add new product
                      final id =
                          await ApiService.getInstance().addProducts(model);
                      if (id == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add task'),
                          ),
                        );
                      } else {
                        model.key = id;
                        Navigator.pop(context, model);
                      }
                    } else {
                      // Edit existing product
                      model.key = widget.id;
                      final isSuccess = await ApiService.getInstance()
                          .editProducts(model.key!, model);
                      if (!isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to edit task'),
                          ),
                        );
                      } else {
                        Navigator.pop(
                            context, model); //navigator.pop(context,model)
                      }
                    }
                  }
                },
                icon: Icon(Icons.send),
                label: Text(widget.id == null ? "Add Task" : "Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
