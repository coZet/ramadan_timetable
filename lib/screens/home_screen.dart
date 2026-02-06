import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget{
 const HomeScreen({super.key});
 @override Widget build(BuildContext c){
  return Scaffold(
   appBar:AppBar(title:const Text('Ramadan Kareem')),
   body:const Center(child:Text('Ramadan Timetable App Ready'))
  );
 }}