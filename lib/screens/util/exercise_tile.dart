import 'dart:ffi';

import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final icon;
  final String exerciseName;
  final int numberOfExercises;
  final Color warna;

  const ExerciseTile(
      {Key? key,
      required this.icon,
      required this.exerciseName,
      required this.numberOfExercises,
      required this.warna})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: warna, // Warna latar belakang untuk ikon favorit
              borderRadius: BorderRadius.circular(8), // Sudut melengkung
            ),
            padding: EdgeInsets.all(12), // Jarak di dalam kontainer
            child: Icon(
              icon,
              color: Colors.white, // Warna ikon favorit
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                exerciseName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                numberOfExercises.toString() + ' exercises',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.blue),
            onPressed: () {
              // Aksi saat ikon ditekan
            },
          ),
        ),
      ),
    );
  }
}
