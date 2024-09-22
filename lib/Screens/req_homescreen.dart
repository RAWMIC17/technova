import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? latitude;
  double? longitude;
  String? address;

    // Function to get the address from latitude and longitude
  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0]; // Taking the first result
    setState(() {
      address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    });
  }

  // Function to get the current location
  void getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  // Loop to keep requesting permissions until granted or permanently denied
  do {
    // Check for location permissions
    permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
    }

    // If permission is permanently denied, break the loop
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    
  } while (permission == LocationPermission.denied); // Keep requesting if still denied

  // Get the current position if permissions are granted
  Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
      forceAndroidLocationManager: true);

  // Update latitude and longitude state
  setState(() {
    latitude = position.latitude;
    longitude = position.longitude;
  });

  // Fetch the address from the coordinates
  await GetAddressFromLatLong(position); // Pass the position object here
}

void callPolice ()async{
  print(" called Police!!");
}

void callAmbulance ()async{
  print(" called Ambulance!!");
}

void callHospital ()async{
  print(" called Hospital!!");
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "SOS".text.color(Vx.white).make().centered(),backgroundColor: Vx.gray600,),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //CircularProgressIndicator(color: Vx.red500,),
          ElevatedButton(onPressed: (){
            getLocation();
            "Sending messages!!!".text.make();
          }, child: "SOS".text.make()),
          Center(
            child: Container(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){callPolice();}, child: "Call Police".text.make()),
                   ElevatedButton(onPressed: (){callAmbulance();}, child: "Call Ambulance".text.make()),
                    ElevatedButton(onPressed: (){callHospital();}, child: "Call Hospital".text.make()),
                  Text(
                    latitude != null
                        ? "Latitude: $latitude"
                        : "Latitude: Not available",
                  ),
                  Text(
                    longitude != null
                        ? "Longitude: $longitude"
                        : "Longitude: Not available",
                  ),
                  Text(
                    address != null
                        ? "Address: $address"
                        : "Address: Not available",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}