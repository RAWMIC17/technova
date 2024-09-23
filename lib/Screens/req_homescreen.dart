import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String message = "This is a test message!";
  List<String> recipents = ["9708372026", "8271008337"];

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

void callPolice (){
  print(" called Police!!");
}

void callAmbulance (){
  print(" called Ambulance!!");
}

void callHospital (){
  print(" called Hospital!!");
}

Future<void> _launchUrl(String phoneNumber) async {
  final Uri uri = Uri(scheme: "tel", path: phoneNumber);

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print("Cannot launch Uri");
    }
  } catch (e) {
    print(e.toString());
  }
}

void _sendSMS(String message, List<String> recipents) async {
 String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
print(_result);
}




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: "SOS".text.color(Vx.white).make().centered(),backgroundColor: Vx.gray600,),
        body: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //CircularProgressIndicator(color: Vx.red500,),
            ElevatedButton(
              onPressed: () async {
                // Check if location services are enabled
                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                
                if (serviceEnabled) {
                  // If location services are enabled, call getLocation
                  getLocation();
                  sendSMS(message: message, recipients: recipents);
                } else {
                  // If location services are disabled, show an alert dialog
                  showDialog(
                    barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                        //backgroundColor: Vx.,
                        scrollable: true,
                        icon: Icon(Icons.location_off_outlined,size: 45,),
                        iconColor: Vx.red700,
                        content: Center(
                          child: Text(
                              "Turn on location services!!"),
                        ),
                        contentTextStyle: TextStyle(
                          color: Vx.black,
                          fontSize: 15,
                          letterSpacing: 1,
                          fontFamily: "Poppins",
                        ),
                        actions: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Vx.purple500)
                            ),
                            onPressed: () async {
                              //AuthService authService = AuthService();
                              // try {
                              //   await authService.deleteAccount();
                                 Navigator.pop(context); // Close the dialog
                              // } catch (e) {
                              //   print("Error deleting account: $e");
                              //   // Handle error if needed
                              // }
                            },
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Vx.white,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                        actionsAlignment: MainAxisAlignment.center,
                        //titlePadding: EdgeInsets.symmetric(horizontal: 20),
                        //contentPadding: EdgeInsets.symmetric(horizontal: -20),
                      ));
                }
              },
              child: "SOS".text.make(),
            ),
            Center(
              child: Container(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: ()  { 
                      _launchUrl("100");
                    }, child:  "Call Police".text.make()),
                     ElevatedButton(onPressed: (){ _launchUrl("112");}, child: "Call Ambulance".text.make()),
                      ElevatedButton(onPressed: (){ _launchUrl("101");}, child: "Call Fire Services".text.make()),
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
      ),
    );
  }
}