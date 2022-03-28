import 'package:flutter/material.dart';
import 'package:rehberapp/MailSend.dart';
import 'package:rehberapp/Model/config.dart';

// Directory dart tarafından gelen veriler ile kişinin hakkında bölümünü oluşturduk.

class DetailPage extends StatelessWidget {

  final String kisiAd; // Diğer taraftan veri çekmek için oluşturduğum değişkenler.
  final String kisiDepartman; // Kişinin adı departmanı foto linki ulaşım bilgisi ve hakkında yazısı.
  final String kisiFoto;  // Bu verileri zaten diğer sayfada JSON'dan çekmiştik.
  final String kisiUlasim; // DetailPage hazırlarken de o verilerden yararlanacağız.
  final String kisiHakkinda;


  DetailPage(this.kisiAd,this.kisiDepartman,this.kisiFoto,this.kisiUlasim,this.kisiHakkinda);// Burada ise sayfa çağırıldığında bu değişkenlerin zorunlu verilmesini sağladık.

  Text textControl(String text, Color renk, double boyut) // Text Kontrol classım.
  {
    return  Text('$text',style: TextStyle( // Textim yazı fontları stilleri boyutu
        fontSize: boyut,
        fontWeight: FontWeight.bold,
        color: renk,
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Arka plan renk ayarı
      appBar: AppBar(
        title: Text(kisiAd), // Diğer sayfadan gelen veriyi AppBar'ın title'na verdim. Kişilerin adı yazıyor.
      ),
      body: Container(
        padding: EdgeInsets.all(25.0), // Container kısmı her bir köşeden 25 piksel uzaklıkta
        child: Center(
          child: Column(// Kolon açtım
            mainAxisAlignment: MainAxisAlignment.center, // Ortaladım
            children: <Widget>[ // Kolonun çocukları. Widgetları bu sayede kullanabiliyoruz.
               Container(
                  child: new CircleAvatar( // Container içine açılan circle avatar, Bunun sebebi kenarlık yapılmak için kullanıldı
                      backgroundImage: NetworkImage(kisiFoto), // Circle avatarın arka plan resmini NetworkImage sayesinde, Json veri de yazan linki çekiyoruz. Yani kişinin fotosu
                      foregroundColor: Colors.white, // Yazı arka plan rengi
                      backgroundColor:  Colors.blue // Arka plan rengi
                  ),
                  width: 240.0, // Container genişlik
                  height: 240.0, // // Yükseklik
                  padding: const EdgeInsets.all(2.0), // Bizim kenarlığın 2 piksel olacağını belirledik
                  decoration: new BoxDecoration( // Dekarasyon olarak containerın yapısını circle avatar ile aynı yapıyoruz yani dairesel. Kİ Çerçeve verebilelim.
                    color: const Color(0xFFFFFFFF), // border color
                    shape: BoxShape.circle,
                  )
              ),
              Padding( // Yukarıda ki circle avatar ile arasına mesafe atılması için padding kullanıldı.
                padding: EdgeInsets.only(top: 15.0),
              ),
              textControl(kisiAd,Colors.white,25.0), // Kişinin adını text classım ile yazdırdım. Paramatreler boyut renk ve text yazısı
              textControl(kisiDepartman,Colors.white,25.0), // Burada da departmanını yazdırdım.
              SizedBox( // Küçük bir çizgi atmak için burayı kullandım
                height: 50.0,
                width: 250.0,
                child: Divider(color: Colors.black,), // Çizgimizin rengi
              ),
              Card(  // Çizginin altına bir kart açtım ve mail bilgilerini girdim.
                margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0), // Margin kullandım simetrik için vertical ve horizontal ayarlarını kullandım.
                child: ListTile( //
                  leading: Icon(Icons.mail,color: Colors.teal), // List tile'nın içine İcon'u koydum ve ulaşım bilgisini yazdırdım.
                  title: textControl(kisiUlasim, Colors.black,15.0), // Burada yine text class'ından yararlandım.
                  onTap: (){ // BURASI ÖNEMLİ
                    // LİST TİLE'a tıklandığında MailSend class'ına yönlendirme yapıyorum. O sayfada ise mail gönderme işlemi oluyor
                    Navigator.push(context,
                       new MaterialPageRoute(builder: (context) => MailSend(kisiUlasim)) // Farkındaysanız mail gönderme sayfasına mail bilgisini taşıyorum. Yine final değişkeninden yardım alarak yapıyorum bunu.
                    );
                  },
                ),
              ),
              Card( // Bir kart daha açarak hakkında kısmını yazdırıyorum
               child: Padding(
                 padding: EdgeInsets.all(10.0), // Kart içinde her yerden 10 piksel uzaklıkta ayarı yapıyorum ki text atacağım yer çok kötü görünmesin.
                 child: textControl(kisiHakkinda, Colors.black, 15.0),
               ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}