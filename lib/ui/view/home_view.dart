import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp/core/api_service.dart';
import 'package:todoapp/core/model/product.dart';
import 'package:todoapp/ui/shared/widgets/custom_card.dart';
import 'package:todoapp/ui/view/add_product_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ApiService service = ApiService.getInstance();
  List<Products> productList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMC TODOLIST"),
      ), // BAŞLIK
      floatingActionButton: _fabButton,
      body: FutureBuilder<List<Products>?>(
        future: service.getProducts(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                productList = snapshot.data!;
                return _listView;
              }
              return Center(
                child: Text("Error"),
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget get _listView => Column(
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('REFRESH')),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => dismiss(
                  CustomCard(
                    title: productList[index].productName!,
                    subtitle: productList[index].day!,
                    imageURL: productList[index].imageURL!,
                  ),
                  productList[index].key!,
                  productList[index]),
              itemCount: productList.length,
            ),
          ),
        ],
      );

  Widget dismiss(Widget child, String key, Products product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.edit, color: Colors.white),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Delete", style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.delete_forever, color: Colors.white),
          ],
        ),
      ),
      child: child,
      confirmDismiss: (DismissDirection direction) async {
        bool confirmAction = false;
        if (direction == DismissDirection.endToStart) {
          confirmAction = await _showDeleteConfirmationDialog(context);
          if (confirmAction) {
            // Delete action
            service.removeProducts(key);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task deleted'),
              ),
            );
          }
        } else if (direction == DismissDirection.startToEnd) {
          confirmAction = await _showEditConfirmationDialog(context);
          if (confirmAction) {
            // Edit action
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => AddProductView(
                  id: key,
                  productToEdit: product,
                ),
              ),
            )
                .then((updatedProduct) {
              if (updatedProduct != null) {
                setState(() {
                  int index =
                      productList.indexWhere((product) => product.key == key);
                  productList[index] = updatedProduct;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task edited successfully!'),
                  ),
                );
              }
            });
          }
        }
        return confirmAction;
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you really want to delete this task?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _showEditConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you really want to edit this task?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).push<Products>(MaterialPageRoute(
                    //   builder: (context) =>
                    //       const AddProductView(), // buraya bilgiler dolu mu gelmeli??
                    // ));
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget get _fabButton => FloatingActionButton(
        onPressed: fabPressed,
        child: Icon(Icons.add),
      );

  void fabPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => AddProductView(),
    ))
        .then(
      (value) {
        print(value);
        final result = value as Products?;
        if (result != null) {
          productList.add(result);
          setState(() {});
        }
      },
    );
  }

  Widget get bottomSheet => Column(
        children: <Widget>[
          Divider(
            thickness: 2,
            indent: 100,
            endIndent: 100,
            color: Colors.grey,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddProductView(),
                ));
              },
              child: Text("Add Task"))
        ],
      );
}
