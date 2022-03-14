import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/screens/common/components/app_bar.dart';
import 'package:smart_parking/utils/SizeConfig.dart';
import 'package:smart_parking/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true, pageMounted = false;
  late DatabaseReference _deviceRef,_userref;
  late StreamSubscription<DatabaseEvent> _deviceSubscription,_userSubscription;

  bool status = false;
  String text = "";

  bool car1=false,car2=false,car3=false,car4=false;
  bool car1noti=false,car2noti=false,car3noti=false,car4noti=false;


  Future<void> initSync() async {
    _deviceRef = FirebaseDatabase.instance.ref('parking');
    _userref = FirebaseDatabase.instance.ref('notification');

    _deviceSubscription = _deviceRef.onValue.listen((DatabaseEvent event) {
      print("Value:${event.snapshot.value}");
      try {
        Map<String, dynamic> map = Map.castFrom(event.snapshot.value as Map);
        text = map.toString();

        car1=map["car1"].toString()=="on"?true:false;
        car2=map["car2"].toString()=="on"?true:false;
        car3=map["car3"].toString()=="on"?true:false;
        car4=map["car4"].toString()=="on"?true:false;


        if(pageMounted) {setState(() {});}
        else {
          Future.delayed(Duration(milliseconds: 100), () {
            setState(() {
            });
          });
        }
      }
      catch(e) {

      }
    });

    _userSubscription = _userref.onValue.listen((DatabaseEvent event) {
      print("Value:${event.snapshot.value}");
      try {
        Map<String, dynamic> map = Map.castFrom(event.snapshot.value as Map);
        text = map.toString();

        car1noti=map["car1"].toString()=="on"?true:false;
        car2noti=map["car2"].toString()=="on"?true:false;
        car3noti=map["car3"].toString()=="on"?true:false;
        car4noti=map["car4"].toString()=="on"?true:false;


        if(pageMounted) { setState(() {}); }
        else {
          Future.delayed(Duration(milliseconds: 100), () {
            setState(() {
            });
          });
        }
      }
      catch(e) {

      }
    });
  }

  @override
  void initState() {
    initSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageMounted = false;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      pageMounted = true;
    });

    if(isFirst) {
      isFirst = false;
    }

    return Container(
      color: Styles.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Styles.background,
          body: Column(
            children: [
              MyAppBar(title: "Smart Parking", backbtnVisible: false, color: Colors.white,),
              Expanded(
                child: getMainBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget getMainBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MySize.size10!, vertical: MySize.size5!),
      child: Column(
         mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              parking("car1", true, car1,car1noti),
              Spacer(),
              parking("car2", false, car2,car2noti),
            ],
          ),
          SizedBox(height: 100,),
          Row(
            children: [
              parking("car3", true, car3,car3noti),
              Spacer(),
              parking("car4", false, car4,car4noti),
            ],
          ),

        ],
      ),
    );
  }

  Widget parking(String car,bool left,bool visible,bool status)
  {
    return Container(
      width: 150,
      height: 150,
      child: Column(
        children: [

          Text(car,style: TextStyle(
            fontSize: 25,
          ),),
          visible?Container(
              color: Colors.grey,
              child: Image.asset("assets/${left?"carleft.png":"carright.png"}" ,height: 70,)):Container(height: 70,color: Colors.grey,),
          //getOnOffSwitch(car,status)
        ],
      ),
    );
  }



  Widget getOnOffSwitch(String car,bool status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(value: status, onChanged: (bool? newValue) {
          print("On Changed Called:${newValue}");
          status=!status;
          setState(() {
          });
          _userref.update({car : (newValue ?? false) ? "on" : "off"});
        }),
      ],
    );
  }
}
