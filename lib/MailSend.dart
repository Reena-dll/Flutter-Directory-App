import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rehberapp/Model/config.dart';

class MailSend extends StatefulWidget {
  final String kisiUlasim; // DetailPage den gelen Ulasim verisini bu değişken ile çekiyorum.
  MailSend(this.kisiUlasim);



  @override
  _MailSendState createState() => _MailSendState();
}

class _MailSendState extends State<MailSend> {

  void initState() // Burada yapmış olduğum işlem, Statefulwidget de sayfalar arası veri taşırken, sayfam da o değişkeni kullanabilmem için yapmam gereken bir fonksiyon.
  {
    super.initState();
    email = widget.kisiUlasim; // Bu işlemi yapmaz isem aşağıda bu veriye ulaşamam.
  }

  final formKey = GlobalKey<FormState>(); // Form'un formkey'i

  String nameSurname, email, subject, message; // Bunlar mail atarken kullanacağım değişkenler.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // AppBar
        title: Text("Mail Gönder"), // AppBar başlık
      ),
      body: Container( //Body'e yine Container bastık.
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10), // Konumlandırma ayarlamaları.

        child: SingleChildScrollView( // Bu aşağı doktru ekrana kaydırma kodu. Yani aşağı doğru inebilyior ekran. Bunu kullanmamın sebebi şudur;
          // Mail kısmında klavye açılınca diğer öğeler otomatikmen yukarı kayıyor, piksel taşması olmaması için bu özellik kullanıldı.
          child: Form( // Flutter'in Form fonksiyonundan yararlandım mail gönderirken
            key: formKey, // Formun keyi
            child: Column( // Form içerisinde kolon
              children: <Widget>[ // Ve widgetleri
                TextFormField( // Bu Formun İsim text'i
                  onSaved: (a) => nameSurname = a,// On saved şudur, Üstünde yazılın olanları şuna aktar gibisinden. Yani ben böyle kullandım
                  decoration: InputDecoration( // Dekarasyon
                    labelText: "Adınız", // text sorusu
                    border: OutlineInputBorder(), // Border şekli
                    prefixIcon: Icon(Icons.account_circle), // Text'in icon'u
                  ),
                ),
                SizedBox(// Form içerisinde 10 piksel boşluk attım
                  height: 10,
                ),
                TextFormField( // Form'un mail text'i
                  initialValue: email, // İlk GELEN DEĞER. İlk gelen değer diğer sayfadan taşıdığımız email. Ama istersek değiştirip başka kişilere de mail atabiliriz.
                  keyboardType: TextInputType.emailAddress, // Text'in çıkış tipi
                  onSaved: (a) => email = a, // Aynı şekilde içerisinde bulunan şeyler email değişkenine aktarılıyor. Zaten hiç text'den yazı silmez isek diğer sayfadan gelen değer olmuş olacak.
                  decoration: InputDecoration( // Dekarasyon
                    labelText: "E-mail", // Text sorusu
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.alternate_email), // Text icon
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField( // Formun Konu text'i
                  onSaved: (a) => subject = a, // Değişkende tutulan değer
                  decoration: InputDecoration(
                    labelText: "Konu",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.subject),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField( // Formun mesaj texti
                  onSaved: (a) => message = a,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Mesaj",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.message),
                  ),
                  maxLines: 4,
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton.icon( // Gönder butonu
                  icon: Icon(Icons.send), // Gönderme buton icon ayarı
                  label: Text("Gönder"), // Gönder butonunun Text'i
                  onPressed: () async { // ASYNC formatında gönderiyoruz
                    if (formKey.currentState.validate()) { // Formkey currentstate textr de ki yazılar veriler vb
                      formKey.currentState.save();
                      bool sendingStatus = await sendMail( // Burada Config dart dosyasında ki sendMail classına yukarıda aldığımız değişkenleri yolluyoruz ve bunu bool değişkeninde tutuyoruz. Durumunu.
                          nameSurname, email, subject, message, context);
                      showSnackbar(sendingStatus); // Snackbar ise alttan çıkan bildiri paneli. SendingStatus da içerisinde yazacak olan yazı, Onu aşağıda tanımlayacağız.
                    }
                  },
                ),
                SizedBox( // Gönder butonu ile aşağıda ki buton arasına 10 piksel boşluk
                  height: 10,
                ),
                FlatButton.icon( // Temizleme butonu
                  icon: Icon(Icons.delete), // İcon ayarı
                  label: Text("Temizle"), // text ayarı
                  onPressed: () {
                    formKey.currentState.reset(); // Butona tıklandığında bütün formkey'i sıfırlar. Yani yazılar gidecek. Temizlemiş olacak
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void showSnackbar(bool sendingStatus) { // SnackBar'ımızı burada tanımlıyoruz
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM, // Flusbhar aşağıdan yukarıya doğru çıkan bildirim paneli. Nereden çıkacağını belirliyoruz.
      margin: EdgeInsets.all(8), // Heryerden uzaklığı
      borderRadius: 15, // Kenarlık yarı çapayarı
      backgroundGradient: LinearGradient( // eğim ayarı, Yani dekarasyon ayarı denilebilir.
        colors: [Colors.lightBlueAccent, Colors.green], // Renk ayarı
      ),
      backgroundColor: Colors.red, // Flushbar'ın arka plan rengi
      boxShadows: [
        BoxShadow( // Kutunun gölgelendirmesi, Ayarlaması
          color: Colors.blue[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0, // Renk ayarları ve gölge ayarları.
        )
      ],
      //title: "Mesaj Bildirimi",
      message: sendingStatus == true // Messajın bool değişkeni true ise, Mesaj Gönderildi, False ise Mesaj gönderilemedi yazısı çıkıyor.
          ? "Mesaj Gönderildi. En kısa sürede geri dönüş sağlanacaktır."
          : "Mesaj Gönderilmede Hata Oluştu.",
      icon: Icon( // İcon ayarları
        sendingStatus == true ? Icons.done_all : Icons.error,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3), // 3 saniye ekranda duracağını belirtiyoruz !1
      //leftBarIndicatorColor: Colors.blue[300],
    )..show(context);
  }
}