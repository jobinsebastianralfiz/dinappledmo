import 'package:dineapple/features/filter/services/api_service.dart';
import 'package:dineapple/features/home/widget/restaurant_card.dart';
import 'package:dineapple/state/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/apptext.dart';
import '../../filter/model/response_model.dart';
import '../../location/location_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var city;
  @override
  void initState() {

    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final apiProvider = Provider.of<APIService>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
      city = locationProvider.currentLocationName!.locality;
        apiProvider.loadCuisines();
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Scaffold(

      appBar: AppBar(
        title: Text("Dinapple"),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                  onPressed: () {
                    themeProvider.toggleTheme(
                      themeProvider.themeMode == ThemeMode.dark
                          ? ThemeOptions.light
                          : ThemeOptions.dark,
                    );
                  },
                  icon: Icon(Icons.brightness_6));
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                    var locationCity;
                    if (locationProvider.currentLocationName != null) {
                      locationCity = locationProvider.currentLocationName!.locality;
                    } else {
                      locationCity = "Unknown Location";
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              AppText(
                                data: locationCity,
                                color: Colors.black,
                                fw: FontWeight.w700,
                                size: 18,
                              ),

                            ],
                          ),
                        ),
                        Icon(Icons.qr_code_scanner)
                      ],
                    );
                  }),
            ),
            const SizedBox(height: 20,),
            RichText(
              text:TextSpan(
                  style: theme.textTheme.titleLarge,
                text: "Touch free\n",
                children: [

                  TextSpan(text: "Experience with Dianpple")
                ]
              )
            ),
            const  SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(data: "Near You",size: 18,color: Colors.black,fw: FontWeight.bold,),
                 IconButton(onPressed: (){
                   Navigator.pushNamed(context, '/filter');
                 }, icon: Icon(Icons.tune,))
              
              ],
            )
            ,const  SizedBox(height: 20,),
            Container(
              height: 200,
              child: Consumer<APIService>(
                builder: (context, apiProvider, child) {
                  if (apiProvider.cuisineData == null) {
                    return Center(child: Text("Not available at your location"));
                  } else {
                    // Filter the data based on the slug
                    // var neighbourhood = <Taxonomies>[];
                    // for (var data in apiProvider.cuisineData!.data!) {
                    //   if (data.slug == "location" && data.taxonomies != null && data.taxonomies![0].city=="Dubai") {
                    //     neighbourhood.addAll(data.taxonomies!);
                    //   }
                    // }
                    // print(neighbourhood[0].locations!);
var locations;
                    apiProvider.neighbourHoodData("Dubai");
                    if(apiProvider.locationData!=null){
                      var locations=apiProvider.locationData;
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: locations!.length,
                        itemExtent: 350,
                        itemBuilder: (context, index) {
                          // Access neighbourhood data using neighbourhood[index]
                          return Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: RestaurantCard(
                              city:" ",
                              name: "${ locations![index]!.name}" ,), // Pass neighbourhood[index] to RestaurantCard

                          );
                        },
                      );
                    }

                    return CircularProgressIndicator();

                    print("location Data: ${locations}");



                  }
                },
              ),
            )


          ],
        ),
      ),
    );
  }
}
