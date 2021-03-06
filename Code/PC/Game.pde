/* Το πρόγραμμα που τρέχει στον υπολογιστή μας και περιστρέφει ένα 3Δ αντικείμενο
*  χρησιμοποιώντας τις τιμές περιστροφής που παίρνει από το χειριστήριο μας
*/

import processing.serial.*;  //Εισάγουμε την βιβλιοθήκη για την σιεριακή επικοινωνία με τον υπολογιστή
Serial myPort;               //Δηλώνουμε το αντικείμενο για την σειριακή θύρα επικοινωνίας

String data;  //Μεταβλητή η οποία θα έχει τα δεδομένα που έρχονται από την σειριακή θύρα
float dX;     //Μεταβλητή η οποία θα έχει την περιστροφή γύρω από τον άξονα Χ του χειριστηρίου όπως έρχεται στα δεδομένα
float dY;     //Μεταβλητή η οποία θα έχει την περιστροφή γύρω από τον άξονα Υ του χειριστηρίου όπως έρχεται στα δεδομένα
float dZ;     //Μεταβλητή η οποία θα έχει την περιστροφή γύρω από τον άξονα Ζ του χειριστηρίου όπως έρχεται στα δεδομένα
float mX;     //Μεταβλητή για την περιστροφή σε μοίρες γύρω από τον άξονα Χ στο 3Δ μοντέλο μας
float mY;     //Μεταβλητή για την περιστροφή σε μοίρες γύρω από τον άξονα Υ στο 3Δ μοντέλο μας
float mZ;     //Μεταβλητή για την περιστροφή σε μοίρες γύρω από τον άξονα Ζ στο 3Δ μοντέλο μας
PShape s;     //Το 3Δ σχήμα που θα προσθέσω


void setup() {
  size(800,600,P3D);                         //Ορίζω το μέγεθος σε 800Χ600
  s = loadShape("drone_costum.obj");         //Φορτώνω το 3Δ σχήμα
  s.scale(20);                               //Ορίζω το μέγεθος του σχήματος ώστε να φαίνεται καλά στην οθόνη
  String portName = Serial.list()[0];        //Επιλέγω την πρώτη θύρα από τις διαθέσιμες σειριακές
  myPort = new Serial(this, portName, 9600); //Συνδέομαι στην σειριακή θύρα για να πάρω τα δεδομένα από το Arduino 
  
  mX = 0;  //Ορίζω αρχικά τις περιστροφές στο 3Δ αντικείμενο στις 0 μοίρες
  mY = 0;  //Ορίζω αρχικά τις περιστροφές στο 3Δ αντικείμενο στις 0 μοίρες
  mZ = 0;  //Ορίζω αρχικά τις περιστροφές στο 3Δ αντικείμενο στις 0 μοίρες
}

void draw() {
  background(5,40,230);                                 //Ορίζω το χρώμα του φόντου σε μπλε
  if ( myPort.available() > 0) {                        //Αν υπάρχουν διαθέσιμα δεδομένα στην σειριακή θύρα,
    data = myPort.readStringUntil('\n');                //Τα αποθηκεύω στην μεταβλητή data
    if (data != null) {                                 //Αν τα δεδομένα που αποθήκευσα δεν είναι μηδενικά,
      int posSTART = data.indexOf("START");             //Κρατάω την θέση του δείκτη START
      int posY = data.indexOf("Y");                     //Κρατάω την θέση του δείκτη Y 
      int posZ = data.indexOf("Z");                     //Κρατάω την θέση του δείκτη Z 
      int posEND = data.indexOf("END");                 //Κρατάω την θέση του δείκτη END 
      if (posSTART > -1) {                              //Αν οι δείκτες υπάρχουν μέσα στα δεδομένα,
        dX = float(data.substring(posSTART+6,posY));    //Αποσπάω την τιμή περιστροφής X από τα δεδομένα
        dY = float(data.substring(posY+1,posZ));        //Αποσπάω την τιμή περιστροφής Υ από τα δεδομένα
        dZ = float(data.substring(posZ+1,posEND));      //Αποσπάω την τιμή περιστροφής Ζ από τα δεδομένα
        
        //Τώρα ήρθε η ώρα να υπολογίσω την περιστροφή του 3Δ αντικειμένου από τις τιμές dX,dY,dZ
        mX = -dX;
        mY = dZ;
        mZ = dY;
      }
    }
  }
  
  translate(width/2,height/2); //Πηγαίνω στην μέση της οθόνης
  rotateX(radians(mX));        //Περιστρέφω τον καμβά στον άξονα Χ 
  rotateY(radians(mY));        //Περιστρέφω τον καμβά στον άξονα Y
  rotateZ(radians(mZ));        //Περιστρέφω τον καμβά στον άξονα Z 
  shape(s);                    //Τοποθετώ το 3Δ σχήμα                     
}
