import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//singkatan stateless widget pakai stl
class EmoticonFace extends StatelessWidget {
  final String emoticonFace;
  const EmoticonFace({Key? key, required String this.emoticonFace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(12), // Sudut melengkung
      ),
      padding: EdgeInsets.all(15),
      child: Center(
          child: Text(
        emoticonFace, //terima jenis emoticon yang dimau pake variabel final
        style: TextStyle(fontSize: 28),
      )),
    );
  }
}
