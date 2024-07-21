import 'package:flutter/material.dart';
import 'package:todoapp/ui/view/add_product_view.dart';
import 'package:todoapp/ui/view/home_view.dart';

//  void main() async {
//    WidgetsFlutterBinding.ensureInitialized();
//    await Firebase.initializeApp();
//    runApp(MyApp());
//  }
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: "/",
      routes: {"/": (context) => HomeView()},
    );
  }
}


















// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, //sonradan
//       theme: ThemeData(primarySwatch: Colors.orange),
//       home: HomeView(),
//     );
//   }
// }
