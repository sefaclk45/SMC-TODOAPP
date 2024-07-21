import 'package:flutter/material.dart';
import 'package:todoapp/ui/shared/styles/text_styles.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageURL;

  const CustomCard({super.key, required this.title, required this.subtitle, required this.imageURL});
 
  

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: ListTile(
        title: Text(this.title,style: titleStyle,),
        subtitle: Text(this.subtitle),
        trailing: imagePlace,
      ),
    );
  }
  Widget get imagePlace{
    return imageURL.isEmpty ? Container(height: 100,child: Placeholder(),width: 100,):  Image.network(imageURL);
  }
}
