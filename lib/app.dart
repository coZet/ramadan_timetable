import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
class MyApp extends StatelessWidget{
 const MyApp({super.key});
 @override Widget build(BuildContext c){
  return MaterialApp(debugShowCheckedModeBanner:false,title:'Ramadan Timetable',home:const HomeScreen());
 }}