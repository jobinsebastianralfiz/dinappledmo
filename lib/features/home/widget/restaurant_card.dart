import 'package:dineapple/utils/apptext.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String?name;
  final String?city;
  const RestaurantCard({super.key,this.name,this.city});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        decoration: BoxDecoration(
            color: theme.cardColor,
          borderRadius: BorderRadius.circular(10)
        ),


        child: Stack(

          children: [
            Container(

             height: 200,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                  ),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/img/img1.jpg'))
              ),


            ),
            Positioned(
              bottom: 10,
                left: 20,
                child: Container(
                  padding: EdgeInsets.only(left: 20,top: 10,bottom: 10),
                  width: 300,
                    color: theme.cardColor.withOpacity(0.5),
                    child: AppText(data: "${name}",size: 20,fw: FontWeight.bold,))),
            AppText(data:"${city}")
          ],
        ),

      ),
    );
  }
}
