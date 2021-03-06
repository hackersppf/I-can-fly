//Βιβλιοθήκες
#include <MPU6050_tockn.h> //Εισάγω τις βιβλιοθήκες για την μονάδα IMU
#include <Wire.h>          //Εισάγω τις βιβλιοθήκες για την μονάδα IMU

//Μεταβλητές
MPU6050 imu(Wire);         //Δημιουργώ ένα αντικείμενο με το όνομα imu

void setup() {
  Serial.begin(9600);        //Ξεκινάω την σειριακή επικοινωνία με τον υπολογιστή
  Wire.begin();              //Ξεκινάω την μονάδα wire
  imu.begin();               //Ξεκινάω το αντικείμενο imu
  imu.calcGyroOffsets(true); //Κάνω αρχικοποίηση της μονάδας imu 
  pinMode(2,OUTPUT);         //Στο pin 2 έχω συνδέσει το ρελέ που ανοίγει κινητήρες δόνησης και ανεμιστήρα και το δηλώνω ως έξοδο
}

void loop() {
  imu.update();                 //Ενημερώνω την μονάδα imu
  float gX = imu.getAngleX();   //Αποθηκεύω την γωνία Χ
  float gY = imu.getAngleY();   //Αποθηκεύω την γωνία Υ
  float gZ = imu.getAngleZ();   //Αποθηκεύω την γωνία Ζ

  //Αν κάποια περιστροφή μου είναι παραπάνω από 20 μοίρες ανοίγω ανεμιστήρες και δονητικά αλλιώς τα κλείνω
  if (gX > 20 || gX <-20 || gY > 20 || gY <-20 || gZ > 20 || gZ <-20) {
    digitalWrite(2,HIGH);
  } else {
    digitalWrite(2,LOW);
  }
  //Στέλνω τα δεδομένα στην σειριακή θύρα για να τα πάρει ο υπολογιστής
  //Χρησιμοποιώ μια συγκεκριμένη δομή για να μπορέσω να τα αποσπάσω μετά 
  //στην Processing. Έτσι ξεκινάω με την λέξη STARTX μετά βάζω την γωνία Χ
  //στη συνέχεια βάζω το γράμμα Υ και την γωνία Υ, μετά βάζω το γράμμα Ζ και 
  //την γωνία Ζ και στο τέλος βάζω την λέξη END.
  Serial.print("STARTX");               
  Serial.print(gX);
  Serial.print("Y");
  Serial.print(gY);
  Serial.print("Z");
  Serial.print(gZ);
  Serial.println("END");
}
