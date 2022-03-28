import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rehberapp/Model/Employee.dart';
import 'DetailPage.dart';

// Bu dart dosyamda, uygulamam açıldığında ekrana gelecek olan sayfa ayarları mevcuttur.

class RemoteJson extends StatefulWidget {
  @override
  _RemoteJsonState createState() => _RemoteJsonState();
}

class _RemoteJsonState extends State<RemoteJson> {




  Future<List<Employee>> _getEmployee() async{  // Future nesnesinden Liste oluşturdum. Bunu da class Employee den çektim.
    var empData=await http.get("https://api.jsonbin.io/b/6241c2717caf5d678373eb47"); // Burada JSON verimi değişkene atadım. Await fonksiyonu ile yaptım.
    var jsonData=json.decode(empData.body); // Json'un kodunu flutter koduna çevirdim. Yani programın anlayacağı dile çevirdım diyebilirim. empData'nın sadece body kısmı çevirildi.
    List<Employee> employees=[]; // Kod'a çevirilen bu veriler, listeye aktarıldı.
    for(var emp in jsonData) // Veri döndükçe, Listenin içerisinde veri oldukça yapılacak işlemler aşağıda ki gibi,
    {
      Employee employee=Employee(emp["kisiID"], emp["kisiAd"], emp["kisiDepartman"], emp["kisiFoto"],emp["kisiUlasim"], emp["kisiHakkinda"]);
      employees.add(employee);
      // Liste içerisinde dönerken, olan verileri tek tek employee listesine ekledik. Yani tam olarak yaptığımız şey,
      // Çözdüğümüz kodda ki başlıkları alarak bizim programımızda ki değişkenlere aktardık. Burada da liste kullandık.
    }
    return employees; // Listeyi geri döndürdüm
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Build'de geri dönen değer Scaffold
      appBar: AppBar( // AppBar
        title:Text("Firma Rehberi",style: TextStyle( // AppBar başlık ve yazı stilleri
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true, // AppBar yazı ortalama kodu
      ),
      body: Container( // Body' e container'den başladım
        child: FutureBuilder( // Json veriyi parse ettiğimiz bölüm. Gelen verileri işlediğimiz yer.
            future: _getEmployee(), // Future özelliğine bizim listemizi yazıyoruz.
            builder: (BuildContext context, AsyncSnapshot snapshot){ // Eş zamansız çalışacağımız için değişkeni ona göre alıyoruz. Değişkenimiz snapshot
              if(snapshot.data==null){ // Snapshot değerinde veri var mı yok mu kontrolü
                return Container(
                  child: Center(child: Text("Loading..."),), // Ekrana Loading yazısını return ediyoruz.
                  // Yani veri gelene kadar bu ekran loading de kalacak.
                );
              }else{ // Eğer veri geldiyse şunları yap;
                return ListView.builder( // Bir tane listview builder oluşturdum. Rehber görünümü sağlamak için çok ideal bir function.
                  itemCount: snapshot.data.length, // Bu listemizin sayısı, JSON'dan listemize gelen verilerin sayısı kadar olacak.
                  itemBuilder: (BuildContext context, int index){ // Yapıcımız int index
                    return ListTile( // List içeriği
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data[index].kisiFoto), // Circle avatara JSON dan gelen resim linkini yazdırıyoruz.
                      ),
                      title:Text(snapshot.data[index].kisiAd), // JSON'Dan gelen veriyi title olarak belirliyoruz. Burada ki veri İsim soy isim.
                      subtitle:Text(snapshot.data[index].kisiUlasim), // Alt  başlığına da kişinin ulaşım bilgisini yine JSON veriden yazdırdık.
                      onTap: (){ // On tap = BUTTON.
                        Navigator.push(context, // Navigator vasıtası ile hangi kullanıcıya basılır ise onun bilgilerini diğer sayfaya taşıdık.
                        new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index].kisiAd,snapshot.data[index].kisiDepartman,snapshot.data[index].kisiFoto,snapshot.data[index].kisiUlasim,snapshot.data[index].kisiHakkinda))
                        ); // Bunuda Final string değişkenleri ile yaptık. Diğer sayfa da açtığımız final değişkenlerine uzanan veriler.
                      },
                    );
                  },
                );
              }
            }
        ),

      ),

    );
  }
}


