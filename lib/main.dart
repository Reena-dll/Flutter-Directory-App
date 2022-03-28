import 'package:flutter/material.dart';
import 'package:rehberapp/Directory.dart';
// Diğer sayfaya ulaşmak için import edilen dart dosyası.
void main() {
  runApp(MyApp()); // RUN MY APP --- Aşağıda ki class'ı çalıştıran komut.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Etiket gizleme
      title: 'Flutter Demo', // Başlık
      theme: ThemeData( // Tema ayarı
        primarySwatch: Colors.pink // Birincil renk
      ),
      home: RemoteJson(), // Home tarafına Directory dart dosyasında ki RemoteJson classını basan kod.
    );
  }
}

