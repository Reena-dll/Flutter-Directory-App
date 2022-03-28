
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// Burası bizim mail işlerinin döndüğü DART dosyamız.

Future<bool> sendMail(String name, String email, String subject, // diğer sayfadan aldığımız string değişkenler.
    // Bunları burada smt sunucularına yollayıp mail atma işlemini gerçekleştireceğiz.
    String messages, BuildContext context) async { // Asenktron bir şekilde çalışacağız yine. Alt sayfa Arka planda bir iş yaparken bu sayfayı göstereceğiz
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return Scaffold( // Bu kısımda arka da mail atma işlemi gerçeklirken ekrana gelecek olan taraf
      body: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Mesaj Gönderiliyor...", // Ekranda sadece bu mesaj olacak ve yükleniyor işareti olacak.
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              CircularProgressIndicator(), // Yükleme ekranında dönme efekti veren kod.
            ],
          ),
        ),
      ),
    );
  }));
  bool sendStates; // Bir adet bool değişkeni
  try {
    String _username = 'rehberbaraninfo@gmail.com'; // Burası bizim Gönderici mailimizin şifresi ve ismi
    String _password = 'RehberBaran123';  // Bu uygulama için yeni bir adet gmail hesabı açtım

    final smtpServer = new SmtpServer('smtp.gmail.com', // smtp serverin ismi ve username password burada bizim hesabın şifresi oluyor
        username: _username,
        password: _password, // Burada hesaba bağlanıyoruz smtp üstünden
        ignoreBadCertificate: false, // Sertifika ayarı
        ssl: false, // Site adresinin doğrulunu kontrol eden bir sertifika. Bunu da false yapıyoruz
        allowInsecure: true); // Güvenli bağlantı

    /* final smtpServer=hotmail(_username, _password); */

    String date = DateTime.now().toString(); // Date adında string değişkeni oluşturup, bugünün tarihini o değişkene veriyoruz
    String sendmail = email; // Diğer sayfadan gelen email değişkenini sendmail değişkenine aktarıyoruz.
    String konu = subject;  // Diğer sayfadan gelen konu(subjec) değişkeninin konu adlı değişkene aktarıyoruz.
    String mesajIcerigi = // Mesaj içeriğini de bu şekilde dolduruyorum, yani attığım mail de bunların hepsi gidecek karşıya
        "Date/Tarih: $date \nSender name/ Gönderen İsim: $name \nSender e-mail/email: $email \nMesage/Mesaj: $messages";

    // Create our message.
    final message = Message()  // Mesaj oluşturuyorum, Maili yollayabilmek için bir mesaj oluşturuyorum
      ..from = Address("$_username")  // Adreess, gönderenin adresi
      ..recipients.add('$sendmail') // Alıcının adresi
      ..subject = konu // Alıcıya gidecek mesajta ki konut
      ..text = mesajIcerigi; // Alıcıya gidecek mesaj

    try {
      final sendReport = await send(message, smtpServer);  // Bunlar try catch özelliği ile gidip gitmeme durumlarını kontrol ediyoruz
      sendStates = true;
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      sendStates = false;
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  } catch (Exception) {
    //Handle Exception
  } finally {
    Navigator.pop(context); // En sonunda Mesaj Gönderiliyor sayfasını patlatıyoruz. Yani mail sayfasına geri dönmüş oluyoruz.
  }
  return sendStates;
}