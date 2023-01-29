import 'package:flutter/material.dart';


const String NETSENSEURL = "https://borreapp.netsense.nl";
const String PRODUCTIONURL = "https://fosdem.org/";
String MAINURL = PRODUCTIONURL;
const String CHECKCLIENTURL="/app/index.php?action=CheckClient";
const String GETEVENTURL="/schedule/xml";
const String ARCHIVEURL="https://archive.fosdem.org/";
const String GETBOOKCATEGORIES="/app/index.php?action=GetBookCategories";
const String GETBOOKPAGEURL="/app/index.php?action=GetBookPage";
const String GETBOOKPAGEAUDIOURL="/app/index.php?action=GetBookAudio";
const String DECREMENTDOWNLOADCOUNTURL="/app/index.php?action=DecrementDownloadCount";
// date the app was published. Used to calculate if any warnings should still be displayed.
const String APPINSTORE="2020-06-20T00:00:00Z";

const String GROUP = "&Group=";
const String CLIENTID = "&ClientId=";
const String POSTCODE = "&PostCode=";
const String BOOKPAGE = "&Page=";
const String BOOKCODE = "&BookCode=";
const String LOGIN_FAILED="Onjuist lidnummer of postcode.";
const String ERROR="""Fout
""";
const String NOT_AUTHORIZED="""Authenticatie mislukt, probeer a.u.b. opnieuw in te loggen
\nAls het probleem aanhoudt, neem dan contact op met Borre Educatief bv.""";
const String NO_NETWORK="""Er is geen verbinding met het netwerk
Controleer je verbinding en probeer het opnieuw.""";
const String OK="OK";
const  String CANCEL="Annuleren";
const String NEW_VERSION_AVAILABLE="Van dit boek is een nieuwe versie beschikbaar. Wil je deze nu downloaden, of het boek lezen?";
const String DOWNLOAD_NEW_VERSION="Downloaden";
const String READ_BOOK="Boek lezen";
const int RUNDEBUGCODE = 0;
const int FREEGROUP = 10;
const double iconSize = 40.0;


enum Eventstatus{ EventStatusUnavailable, EventStatusAvailable, EventStatusLimitExceeded,EventStatusDownloaded, EventStatusDownloadedButUpdateAvailable }
enum VersionData{ Version1, Version2, Version3, Version4, Version5, CurrentVersion }
enum DebugLevel{ None, All, Database, XMLJSONParsing, ScreenLayout, LoginStatus, Sound}
enum ConnectivityStatus {
  WiFi,
  Cellular,
  Offline
}
const debug = DebugLevel.XMLJSONParsing;
const debugDownload = false;
const Color borreColor1 = Color(0xFFC3E0E4);
const Color borreColor2 = Color(0xFF5DB3BE);
const Color borreColor1ligther = Color(0x90C3E0E4);
const Color borreColor3 = Color(0xFF91CBD4);
const Color borreColorButtonBackground = Color(0xFF8FCDD5);
const Color borreColorButtonTekst = Color(0xFF4C949A);

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  elevation: 10.0,
  //onPrimary: Colors.black87,
  //primary: borreColor2,
  textStyle: TextStyle(color: borreColor1),
  backgroundColor: borreColor1,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

final ButtonStyle borreButtonStyle = ElevatedButton.styleFrom(
  elevation: 10.0,
  //onPrimary: Colors.black87,
  //primary: borreColor2,
  textStyle: TextStyle(color: borreColorButtonTekst),
  backgroundColor: borreColor1,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);