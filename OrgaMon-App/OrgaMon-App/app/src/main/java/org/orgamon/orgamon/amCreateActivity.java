/*
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2021  Andreas Filsinger
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    http://orgamon.org/
  |
 */
package org.orgamon.orgamon;

import android.Manifest;
import android.app.SearchManager;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Typeface;
import android.media.SoundPool;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.support.v7.app.AppCompatActivity;
import android.text.InputType;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Gallery;
import android.widget.GridLayout;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.Random;
import java.util.StringTokenizer;

import javax.net.ssl.HttpsURLConnection;

import static android.graphics.Paint.ANTI_ALIAS_FLAG;
import static android.os.Environment.getExternalStoragePublicDirectory;
import static java.net.HttpURLConnection.HTTP_BAD_REQUEST;
import static java.net.HttpURLConnection.HTTP_FORBIDDEN;
import static java.net.HttpURLConnection.HTTP_OK;

public class amCreateActivity extends AppCompatActivity {

    static final String TAG = "Activity";

    // Anwendungsname
    static final String APP = "OrgaMon-App";
    static final String VERSION = "2.047"; //
    static final String REV = "Rev. " + VERSION;

    // App-Namensraum + Programm-Parameter-ContainerName
    static final String cINI = "OrgaMon";
    //  FTPS + https: Host
    static final String cTLD = "orgamon.net";

    // Serverkommunikation
    static final String cUP = "up.php?";
    static final String cID = "id=";
    static final String cWEB_TAN = "tan=";
    static final String cWEB_DATA = "data=";
    static final String cPROCEED = "proceed=";
    static final String cAUFTRAG = "auftrag.utf-8.txt";

    // Programm Konstanten
    static final String cTAN = "00000";
    static final String cGERAET = "000";
    static final String cHANDY = "352286043221604";
    static final String cSALT = "#########";
    static final String SEPERATOR = "~";

    // Auftrags-Daten-Haltung
    static final String cDELIMITER = "\\;";
    static final String cFLAG_UNCHANGED = "N";
    static final String cFLAG_MODIFIED = "Y";
    static final String cFLAG_FERTIG = "F"; // unused by now

    // Protokoll Feldnamen
    static final String cPROTOKOLL_AllesFertig = "ZZ";

    // Persistente Daten in "SharedPreferences" (Key,Value)-Stores

    // ContainerName "INPUT", der Eingabe-Context
    static final String cSAVE = "INPUT";
    static final String cSAVE_FULLDATA = "0"; // 0=die ganze Datenzeile
    static final String cSAVE_TITLE = "1"; // 1=Protokoll-Überschrift
    static final String cSAVE_RID = "2"; // 2=RID
    static final String cSAVE_PARAMETER = "3"; // 3=Parametername des aktuellen Fotos, z.B. "FA"
    static final String cSAVE_SCAN = "4"; // 4=Parametername des aktuellen Barcode SCANs
    static final String cSAVE_FOCUS = "5:"; // 5=Id des fokusierten Views
    static final String cSAVE_REGLERNUMMERALT = "6";
    static final String cSAVE_FOTONAME = "7"; // Dateiname des gemachten Fotos ohne "$"

    // ContainerName "~TAN~", heist so wie die TAN
    // ContainerName "~PROT~", heist so wie das Protokoll
    // ContainerName "~TAN~" Zusatz
    static final String cSEARCH_FLAG = ".S";

    // Spalten des Auftrages
    static final int COLUMN_MODIFIED = 0;
    static final int COLUMN_RID = 1;
    static final int COLUMN_TERMIN = 2;
    static final int COLUMN_ABNUMMER = 3;
    static final int COLUMN_ART = 4;
    static final int COLUMN_ZAEHLER_ALT = 5;
    static final int COLUMN_REGLER_ALT = 6;
    static final int COLUMN_ZAEHLER_INFO = 7;
    static final int COLUMN_MONTEUR_INFO = 8;
    static final int COLUMN_ORT = 9;
    static final int COLUMN_PROTOKOLL_NAME = 10;

    // Aufbau der Ergebnis-Rückmeldung:
    //
    // RID;Z#A-Korrektur;Z#N;ZSN;ZSA;R#-Korrektur;R#-Neu;Protokoll;Datum-Ist;Uhr-Ist

    // -----> Folgende Felder gehen auch wieder zurück!
    static final int COLUMN_ZAEHLER_KORR = 11;
    static final int COLUMN_ZAEHLER_NEU = 12;
    static final int COLUMN_ZAEHLER_STAND_NEU = 13;
    static final int COLUMN_ZAEHLER_STAND_ALT = 14;
    static final int COLUMN_REGLER_KORR = 15;
    static final int COLUMN_REGLER_NEU = 16;
    static final int COLUMN_PROTOKOLL = 17;
    static final int COLUMN_EINGABE_DATUM = 18; // Datum oder Auftrag-Stati AS_
    static final int COLUMN_EINGABE_UHR = 19;
    static final int COLUMN_INDEX = 20;

    // Auftrag Stati
    // Erledigungsstati von Aufträgen
    static final int AS_VORGEZOGEN = -6;
    static final int AS_INFO = -5;
    static final int AS_NEU_ANSCHREIBEN = -4;
    static final int AS_WEGFALL = -3;
    static final int AS_UNMOEGLICH = -2;
    static final int AS_RESTANT = -1;
    static final int AS_BISHER_KEINE_EINGABE = 0;

    // Lokale Programm-Optionen
    static final String OPTION_FIXED_SERVER = "0"; // use "raib100" as IPAdress
    static final String OPTION_SINGLE_TAN = "1"; // no TAN double buffer (save
    // Disk Space)
    static final String OPTION_NO_PROTOCOL = "2"; // no Protocols (save Disk
    // Space)
    static final String OPTION_NO_ENDAPP = "3"; // kein (extra) "Ende" in den
    // Menüs
    static final String OPTION_MENU2 = "4"; // Kleine Handies ... links/rechts
    // vertauscht: scheinbar ist es so,
    // die Geräte haben entweder rechts
    // oder links
    static final String OPTION_SIMPLE_CHECK = "5"; // keine Texte bei den
    // Checkboxes
    static final String OPTION_NIU = "6"; // unbenutzt
    static final String OPTION_CLEAR = "7"; // nichts produktiv verarbeiten, nur ein test
    static final String OPTION_MICRO = "8"; // Micro Sender (nur abzeichnen
    // lassen)
    static final String OPTION_NEU = "9"; // Darf der Monteur einen eigenen
    // Auftrag anlegen?
    // Remote Programm-Optionen
    static final String OPTION_KEINE_DOPPELEINGABE_ZAEHLERSTAND_ALT = "a";
    static final String OPTION_KEINE_DOPPELEINGABE_ZAEHLERNUMMER_NEU = "b";
    static final String OPTION_KEINE_DOPPELEINGABE_ZAEHLERSTAND_NEU = "c";

    // Benutzer-Eingabeformulare
    static final int VIEW_SETTINGS = 0;
    static final int VIEW_LISTE = 1;
    static final int VIEW_PROTOKOLL = 2;
    static final int VIEW_UNTERSCHRIFT = 3;
    static final int VIEW_FOTO = 4;

    // Benutzer-Eingabecontrols
    public EditText focused = null;
    public EditText requestFocus = null;
    public static String DoppelEingabe = "";
    public static String VorEingabe = "";

    // System Parameter

    // Geräte Identifikationsnummer
    public static String iGeraeteNo = "";
    public static String iHandyId = "";
    public static String iSalt = "";

    // Programm Sonderoptionen
    public static String iLokaleOptionen = ""; //
    public static String iRemoteOptionen = "";

    // Derzeitige Transaktionsnummer
    public static String iTAN = "";

    // Derzeitige Position inerhalb der Auftrags-Liste "0..n-1"
    public static int iIndex = 0;

    // Derzeitige Anzahl der Aufträge auf dem Gerät "n"
    public static int iAnz = 0;
    public static int iGesamt = 0;

    public static String iLastError = ""; // Letzer Fehler aus "senden"
    public static String iLastSearch = ""; // letzte Sucheingabe des Monteurs
    public static String iStandTxt = ""; // Letzter erfolgreicher Abruf

    // Welcher View wird im Moment angezeigt
    public static int iView = VIEW_SETTINGS;

    public static Context iThis = null;

    // Wie lautet das aktuell aktive Protokoll
    // inclusive des aktuellen Eingabepfades
    // gespeichert in COLUMN_PROTOKOLL_NAME
    public static String iProtokoll = "";

    // Die im Moment angesagte Barcode Technologie
    static final String iBarcode_DEFAULT = "ITF";
    public static String iBarcode = "";

    // Wie lautet der aktuelle Host (Subdomain und FTP-LoginName)
    static final String iHost_DEFAULT = "Name";
    public static String iHost = ""; // Prefix von .orgamon.net, Webhost
    public static String iPwd = ""; // HTTPS und FTP(S) fix 9 stellig
    public static String iFTPS = ""; // use FTPS (default "true")

    // normalerweise ist der FTPhost=Webhost
    // zu Testzwecken kann aber ein alternativer Host
    // verwendet werden
    public static String iHost_FTP = "";

    // Wo liegen die Bilder
    static final String iFotoPath_DEFAULT = "/storage/emulated/0/Pictures";
    public static String iFotoPath = "";

    // Soll nach dem Fotografieren ein Bestätigungsschirm angezeigt werden
    public static String iFotoConfirm = "true";

    // Zu welchem Feld soll im Protokoll gesprungen werden
    static final String iFocus_DEFAULT = "14";
    public static String iFocus = "";
    public static String iAutoExit = "";

    // Soll direkt etwas gescannt werden?
    public static String iScan = "";

    // Parameter aus dem laufenden Programm, sind auch persistent

    // AUFTRAG.RID wie z.B. 217625625
    public static String RID = "";

    // Foto, Parametername wie z.B. "FA","FN" oder "FU"
    public static String PARAMETER = "";

    // das Barcode-Scanner Ergebnis
    public static String SCAN = "";
    // Fenster-Titel des Protokolles
    public static String TITEL = "";
    // Name und Ebene des aktuellen Protokolles
    public static String PROTOKOLL = "";
    // der Fokus-ID der zuletzt aktiven Eingabe-Position
    public static int FOCUS = 0;
    // Name der aktuellen Foto-Datei
    public static String FOTONAME = null; // z.B. 001-4711-FA.jpg

    // Caching für einzelne Spalten, nicht persistent
    public static String cache_EINGABEDATUM = null;
    public static String cache_EINGABEUHR = null;

    // Wunsch-Handles der verwendeten INTENTS
    int INTENTHANDLE_ZXING = 1;
    int INTENTHANDLE_CAMERA = 2;

    // Layout Allgemein
    LayoutInflater inflater;

    // Einstellungen
    LinearLayout viewSettings;
    EditText viewSettings_geraeteNo;
    EditText viewSettings_server;

    // Liste der Aufträge
    ListView viewListe;

    // Protokoll
    ScrollView viewProtokoll;

    // Unterschrift View (übergeordnetes View)
    LinearLayout viewUnterschrift = null;
    // der eigentliches Unterschrift-Canvas (ist auch ein View)
    Unterschrift canvasUnterschrift = null;

    // Foto Kontrolle
    ScrollView viewFoto = null;

    // für Audioausgabe
    static SoundPool soundPool = null;
    static int soundFail;

    public int getCount() {
        return iAnz;
    }

    public static String strSTATUS(String s) {

        int ausfuehren_ist_datum;
        try {
            ausfuehren_ist_datum = Integer.parseInt(s);
        } catch (Exception e) {
            ausfuehren_ist_datum = 0;
        }

        switch (ausfuehren_ist_datum) {

            case AS_VORGEZOGEN:
                return "Vorgezogen";

            case AS_INFO:
                return "Info";

            case AS_NEU_ANSCHREIBEN:
                return "Zurück";

            case AS_WEGFALL:
                return "Wegfall";

            case AS_UNMOEGLICH:
                return "Unmöglich";

            case AS_RESTANT:
                return "Restant";

            case AS_BISHER_KEINE_EINGABE:
                return "";

            default:
                return "fertig";
        }
    }

    public void loadSettings() {

        Log.i(TAG, "loadSettings");
        iThis = this;
        try {

            SharedPreferences prefs = this.getSharedPreferences(cINI, Context.MODE_PRIVATE);
            iGeraeteNo = prefs.getString("GeraeteNo", cGERAET);
            iHandyId = prefs.getString("HandyId", cHANDY);
            iSalt = prefs.getString("Salt", cSALT);
            iPwd = prefs.getString("Pwd", "");
            iLokaleOptionen = prefs.getString("LokaleOptionen",OPTION_NO_ENDAPP + OPTION_MENU2 + OPTION_SIMPLE_CHECK);
            iRemoteOptionen = prefs.getString("RemoteOptionen", "");
            iTAN = prefs.getString("TAN", cTAN);
            iView = prefs.getInt("View", VIEW_SETTINGS);
            iProtokoll = prefs.getString("Protokoll", "");
            iIndex = prefs.getInt("Index", 0);
            iAnz = prefs.getInt("Anzahl", 0);
            iGesamt = prefs.getInt("Gesamt", 0);
            iLastError = prefs.getString("Fehler", "");
            iStandTxt = prefs.getString("Stand", "bisher keine");
            iLastSearch = prefs.getString("Suche", "");
            iBarcode = prefs.getString("Barcode", iBarcode_DEFAULT);
            iHost = prefs.getString("Host", iHost_DEFAULT);
            iFTPS = prefs.getString("FTPS", "true");
            iFotoPath = prefs.getString("Fotos", iFotoPath_DEFAULT);
            iFotoConfirm = prefs.getString("Nachfrage", "true");
            iFocus = prefs.getString("Fokus", iFocus_DEFAULT);
            iScan = prefs.getString("Scan", "");
            iAutoExit = prefs.getString("Exit", "");

        } catch (Exception e) {
            Log.e(TAG, "LoadSettings", e);
        }
    }

    public void saveSettings() {

        Log.i(TAG, "saveSettings");
        try {
            SharedPreferences prefs = this.getSharedPreferences(cINI,
                    Context.MODE_PRIVATE);
            Editor editor = prefs.edit();
            editor.putString("GeraeteNo", iGeraeteNo);
            editor.putString("HandyId", iHandyId);
            editor.putString("Salt", iSalt);
            editor.putString("Pwd", iPwd);
            editor.putString("LokaleOptionen", iLokaleOptionen);
            editor.putString("RemoteOptionen", iRemoteOptionen);
            editor.putString("TAN", iTAN);
            editor.putInt("View", iView);
            editor.putString("Protokoll", iProtokoll);
            editor.putInt("Index", iIndex);
            editor.putInt("Anzahl", iAnz);
            editor.putInt("Gesamt", iGesamt);
            editor.putString("Fehler", iLastError);
            editor.putString("Stand", iStandTxt);
            editor.putString("Suche", iLastSearch);
            editor.putString("Barcode", iBarcode);
            editor.putString("Host", iHost);
            editor.putString("FTPS", iFTPS);
            editor.putString("Fotos", iFotoPath);
            editor.putString("Nachfrage", iFotoConfirm);
            editor.putString("Fokus", iFocus);
            editor.putString("Scan", iScan);
            editor.putString("Exit", iAutoExit);
            editor.commit();

        } catch (Exception e) {
            Log.e(TAG, "SaveSettings", e);
        }
    }

    public void wipePref(String prefName) {

        Log.i(TAG, "wipePref" + prefName);
        try {
            SharedPreferences prefs = this.getSharedPreferences(prefName,
                    Context.MODE_PRIVATE);
            Editor editor = prefs.edit();
            editor.clear();
            editor.commit();
        } catch (Exception e) {
            Log.e(TAG, "wipePref" +prefName, e);
        }
    }

    //
    // ein Auftrag ist gewählt. Nun werden alle Details des Auftrages in einen
    // Edit Context geschrieben, Änderungen macht der Anwender in diesem Context
    // File "iTAN" to "cSAVE"
    //  cSAVE_FULLDATA=
    //  cSAVE_TITLE=
    //  cSAVE_RID=
    //  cSAVE_REGLERNUMMERALT=
    //  11=
    //  ...
    //  19=
    //
    public String prepareEditContext() {

        Log.d(TAG, "save full Liste[" + iIndex + "] to cSAVE");
        try {

            SharedPreferences data = this.getSharedPreferences(iTAN,
                    Context.MODE_PRIVATE);
            SharedPreferences save = this.getSharedPreferences(cSAVE,
                    Context.MODE_PRIVATE);
            String s = data.getString(Integer.toString(iIndex), "");
            String[] r = s.split(cDELIMITER);

            if (r.length > COLUMN_EINGABE_UHR) {
                Editor editor = save.edit();
                editor.clear();

                // den alten Gesamt-Zustand kopieren nach cSAVE_FULLDATA
                // Die Grunddaten
                editor.putString(cSAVE_FULLDATA, s);

                // den Titel jedes Protokollblattes sichern
                editor.putString(cSAVE_TITLE,
                        /**/ r[COLUMN_ART] + "-" +
                        /**/ r[COLUMN_ZAEHLER_ALT] + " (" +
                        /**/ r[COLUMN_ABNUMMER] + ")");

                editor.putString(cSAVE_RID, r[COLUMN_RID]);
                editor.putString(cSAVE_REGLERNUMMERALT, r[COLUMN_REGLER_ALT]);

                int i;
                // die Monteur-Daten 11..19
                for (i = COLUMN_ZAEHLER_KORR; i <= COLUMN_EINGABE_UHR; i++) {
                    if (i != COLUMN_PROTOKOLL) {
                        editor.putString(Integer.toString(i), r[i]);
                    } else {
                        Log.d(TAG, "Protokoll="
                                + r[COLUMN_PROTOKOLL]);
                        String[] p = r[COLUMN_PROTOKOLL].split("\\~");
                        int k;
                        int j;
                        for (j = 0; j < p.length; j++) {
                            k = p[j].indexOf("=");
                            if (k > 0) {
                                Log.d(TAG,"set"+
                                        p[j].substring(0, k) + "=" +
                                        p[j].substring(k + 1));
                                editor.putString(p[j].substring(0, k),
                                        p[j].substring(k + 1));
                            }
                        }
                    }
                }
                editor.commit();
                return (r[COLUMN_PROTOKOLL_NAME] + "/");

            } else {
                Log.e(TAG, "Index " + iIndex + " data crash");
                return "";
            }
        } catch (Exception e) {
            Log.e(TAG, "prepareEditContext", e);
            return "";
        }
    }

    //
    // bevor "speichern & OK" gedrückt wird müssen die einzelnen Eingabedaten
    // dennoch persistent gespeichert werden. Dazu wurde bereits der
    // prepareEditContext aufgebaut. Nun werden nur noch einzelne Werte dieses
    // cSAVE überschrieben
    //
    public void saveSingleParameter(String key, String value) {

        Log.i(TAG,"saveSingleParameter('"+key+"','"+value+"')");
        try {

            // Wertumsetzer
            if (key.startsWith("V")) {
                if (value.equals("2")) {
                    value = getTimestamp();
                }
            }

            SharedPreferences prefs = this.getSharedPreferences(cSAVE,
                    Context.MODE_PRIVATE);

            String _value = prefs.getString(key, "");

            if (!_value.equals(value)) {

                Editor editor = prefs.edit();
                if (value.length() == 0) {

                    Log.d(TAG, "saveSingleParameter." + key + " from '" + _value + "' to <null>");
                    editor.remove(key);

                } else {

                    Log.d(TAG,"saveSingleParameter." + key + " from '" + _value + "' to '"
                            + value + "'");

                    editor.putString(key, value);
                }
                editor.commit();
            }

        } catch (Exception e) {
            Log.e(TAG,"saveSingleParameter." + key, e);
        }

        // ist es ein Autoexit Feld?
        if (iAutoExit.contains(key)) {

            if (key.equals("S1")) {
                saveSingleParameter("18", "-4");
            }

            if (key.equals("S2")) {
                saveSingleParameter("14", "0");
            }

            // speichern!
            if (saveEditContext()) {

                // Listenansicht +/- 1
                iView = VIEW_LISTE;

                if (key.equals("S1")) {
                    iIndex++;
                }

                if (key.equals("S2")) {
                    iIndex--;
                }

                reboot();
            }
        }
    }

    public void inputTimestampNow() {

        String ts = getTimestamp();
        cache_EINGABEDATUM = Integer.toString(getDate(ts));
        cache_EINGABEUHR = Integer.toString(getSeconds(ts));

        Log.d(TAG, "TimeStamp=" + cache_EINGABEDATUM + ";"
                + cache_EINGABEUHR);

    }

    //
    // speichert alle aktuellen Eingaben in der Auftragsliste
    // cSAVE -> cTAN
    //
    public Boolean saveEditContext() {

        boolean plausibel = true;

        Log.d(TAG,"saveEditContext " + iIndex);
        try {

            SharedPreferences save = this.getSharedPreferences(cSAVE,
                    Context.MODE_PRIVATE);

            // den bisherigen Stand laden
            String old = save.getString(cSAVE_FULLDATA, "");
            Log.d(TAG,"old " + old);
            String[] r = old.split(cDELIMITER);
            String neu = cFLAG_MODIFIED;
            String parameterName;

            // zunächst die bisherigen Werte
            cache_EINGABEDATUM = save.getString(
                    Integer.toString(COLUMN_EINGABE_DATUM), "");
            cache_EINGABEUHR = save.getString(Integer.toString(COLUMN_EINGABE_UHR),
                    "");

            int i;
            for (i = 1; i < r.length; i++) {

                switch (i) {

                    case COLUMN_PROTOKOLL:

                        String protokoll = "";
                        boolean addParameter = true;
                        // nun den Protokoll-String zusammenbauen
                        for (Map.Entry<String, ?> entry : save.getAll().entrySet()) {
                            Object val = entry.getValue();
                            if (val != null) {

                                parameterName = entry.getKey();
                                addParameter = true;

                                if (!Character.isDigit(parameterName.charAt(0))) {

                                    Log.d(TAG,
                                            parameterName + "="
                                                    + String.valueOf(val));

                                    // ZZ=J -> fertig, ZZ=N -> wieder unfertig
                                    if (parameterName.equals(cPROTOKOLL_AllesFertig)) {
                                        // notiere den Alles fertig Status
                                        if (String.valueOf(val).equals("J"))
                                            if (cache_EINGABEDATUM.length() < 4)
                                                inputTimestampNow();
                                        // lösche den Alles fertig Status
                                        if (String.valueOf(val).equals("N")) {
                                            cache_EINGABEDATUM = Integer.toString(AS_BISHER_KEINE_EINGABE);
                                            cache_EINGABEUHR = "0";
                                            // speichere ZZ=N nicht!
                                            addParameter = false;
                                        }
                                    }

                                    // In der Monteur-Info ist
                                    // Plausibilisierungs-Info drin
                                    if (plausibel)
                                        // Plausibilisierung ist angefordert?
                                        if (r[COLUMN_ZAEHLER_INFO]
                                                .contains(parameterName + "(")) {

                                            // Wert so vorgegeben?
                                            plausibel = r[COLUMN_ZAEHLER_INFO]
                                                    .contains(parameterName + "("
                                                            + String.valueOf(val)
                                                            + ")");

                                        }

                                    // Protokoll wird um den einen Parameter erweitert
                                    if (addParameter) {
                                        if (protokoll.equals("")) {
                                            protokoll = parameterName + "="
                                                    + String.valueOf(val);
                                        } else {
                                            protokoll += SEPERATOR + parameterName
                                                    + "=" + String.valueOf(val);
                                        }
                                    }
                                }
                            }
                        }
                        neu += ";" + protokoll;
                        break;

                    case COLUMN_ZAEHLER_STAND_ALT:
                        String nZSA = save.getString(
                                Integer.toString(COLUMN_ZAEHLER_STAND_ALT), "");
                        if (!r[COLUMN_ZAEHLER_STAND_ALT].equals(nZSA))
                            inputTimestampNow();

                        neu += ";" + nZSA;
                        break;

                    case COLUMN_EINGABE_DATUM:
                        neu += ";" + cache_EINGABEDATUM;
                        break;

                    case COLUMN_EINGABE_UHR:
                        neu += ";" + cache_EINGABEUHR;
                        break;

                    case COLUMN_ZAEHLER_KORR:
                    case COLUMN_ZAEHLER_NEU:
                    case COLUMN_ZAEHLER_STAND_NEU:
                    case COLUMN_REGLER_KORR:
                    case COLUMN_REGLER_NEU:
                        neu += ";" + save.getString(Integer.toString(i), "");
                        break;
                    default:
                        // einfach kopieren, da "Nur-Lese"-Felder
                        neu += ";" + r[i];
                }
            }

            // speichern, aber nur wenn es was neues gibt!
            if (plausibel) {
                if (!old.substring(1).equals(neu.substring(1))) {

                    Log.i(TAG,"saveEditContext.save " + neu);

                    SharedPreferences data = this.getSharedPreferences(iTAN,
                            Context.MODE_PRIVATE);
                    Editor editor = data.edit();
                    editor.putString(Integer.toString(iIndex), neu);
                    editor.commit();
                } else {
                    Log.i(TAG,"saveEditContext S K I P");
                }
            } else {

                Log.e(TAG,"saveEditContext unplausibel");

                if (soundPool==null) {
                    soundPool =  new SoundPool.Builder()
                            .setMaxStreams(1)
                            .build();
                    soundFail = soundPool.load(getApplicationContext(), R.raw.fail48, 1);
                }
                soundPool.play(soundFail, 1, 1, 1, 0, 1f);
            }

        } catch (Exception e) {
            Log.e(TAG, "saveEditContext", e);
            plausibel = false;
        }
        return plausibel;
    }

    static public class Auftraege extends BaseAdapter {

        static final String TAG = "Aufträge";

        // Ein Container, der alles Speichern können muss,
        // was den View ausmacht.
        static class ViewHolder {
            TextView tvSchlagzeile;
            TextView tvOrt;
            TextView tvInfos;
        }

        private LayoutInflater mInflater;
        private SharedPreferences mPrefs;

        public Auftraege(Context context) {

            mInflater = LayoutInflater.from(context);
            mPrefs = context.getSharedPreferences(iTAN, Context.MODE_PRIVATE);
        }

        public int getCount() {
            return (iAnz);
        }

        public Object getItem(int position) {
            // Für was?
            return null;
        }

        public long getItemId(int position) {
            return position;
        }

        public View getView(int position, View convertView, ViewGroup parent) {

            ViewHolder holder;
            try {
                if (convertView == null) {
                    convertView = mInflater.inflate(
                            R.layout.auftragliste_element, null);
                    holder = new ViewHolder();
                    holder.tvSchlagzeile = (TextView) convertView
                            .findViewById(R.id.schlagzeile);
                    holder.tvOrt = (TextView) convertView
                            .findViewById(R.id.ort);
                    holder.tvInfos = (TextView) convertView
                            .findViewById(R.id.info);

                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }

                String s = mPrefs.getString(Integer.toString(position), null);
                if (s != null) {

                    String[] r = s.split(cDELIMITER);

                    if (s.startsWith(cFLAG_MODIFIED)) {
                        holder.tvSchlagzeile.setTypeface(
                                Typeface.defaultFromStyle(Typeface.BOLD),
                                Typeface.BOLD);
                    } else {
                        holder.tvSchlagzeile.setTypeface(
                                Typeface.defaultFromStyle(Typeface.ITALIC),
                                Typeface.ITALIC);
                    }

                    int DatumAsInt;
                    try {
                        DatumAsInt = Integer.parseInt(r[COLUMN_EINGABE_DATUM]);
                    } catch (Exception e) {
                        DatumAsInt = 0;
                    }

                    switch (DatumAsInt) {

                        case AS_VORGEZOGEN:
                            holder.tvSchlagzeile.setTextColor(0xFFCCFFFF); // blau
                            break;

                        case AS_INFO:
                            holder.tvSchlagzeile.setTextColor(0xFFFFFFFF); // weiss
                            break;

                        case AS_NEU_ANSCHREIBEN:
                            holder.tvSchlagzeile.setTextColor(0xFFFF0000); // rot
                            break;

                        case AS_WEGFALL:
                            holder.tvSchlagzeile.setTextColor(0xFFCCCCCC); // grau
                            break;

                        case AS_UNMOEGLICH:
                            holder.tvSchlagzeile.setTextColor(0xFFFF6666); // rot
                            break;

                        case AS_RESTANT:
                            holder.tvSchlagzeile.setTextColor(0xFFFFCCBB); // oranje
                            break;

                        case AS_BISHER_KEINE_EINGABE:
                            holder.tvSchlagzeile.setTextColor(0xFFFFFF00); // gelb
                            // (restant)
                            break;

                        default:
                            holder.tvSchlagzeile.setTextColor(0xFF99FF99); // grün
                            // (fertig)

                    }

                    holder.tvSchlagzeile.setText(
                            r[COLUMN_ABNUMMER] + " " +
                            strSTATUS(r[COLUMN_EINGABE_DATUM]) + " " +
                            r[COLUMN_TERMIN] + "\n" +
                            r[COLUMN_MONTEUR_INFO]);
                    holder.tvOrt.setText(r[COLUMN_ART] + "-"
                            + r[COLUMN_ZAEHLER_ALT] + " " + r[COLUMN_ORT]);
                    holder.tvInfos.setText(r[COLUMN_ZAEHLER_INFO]);
                }
            } catch (Exception e) {
                Log.e(TAG, "getView", e);
            }
            return convertView;
        }
    }

    static public class Unterschrift extends View {

        static final String TAG = "Unterschrift";
        private Paint paint_dot = new Paint(ANTI_ALIAS_FLAG);
        private Paint paint_line = new Paint(ANTI_ALIAS_FLAG);
        private Path path_dot = new Path();
        private Path path_line = new Path();
        private Integer dotCount;
        static final int STIFT_DICKE = 7;
        static final int STIFT_KLECKS = 4;
        static final int MINIMUM_DOT_COUNT = 30;

        public Unterschrift(Context context) {
            super(context);
            paint_line.setColor(Color.BLACK);
            paint_line.setStyle(Paint.Style.STROKE);
            paint_line.setStrokeJoin(Paint.Join.ROUND);
            paint_line.setStrokeWidth(STIFT_DICKE);

            paint_dot.setColor(Color.BLACK);
            paint_dot.setStyle(Paint.Style.FILL);
            dotCount = 0;
        }

        public void saveJPG() {

            if (dotCount>=MINIMUM_DOT_COUNT) {

                try {
                    // get the canvas
                    setDrawingCacheEnabled(true);
                    Bitmap bm = Bitmap.createBitmap(getDrawingCache());
                    setDrawingCacheEnabled(false);

                    // combine FileName
                    String newName = iGeraeteNo + "-" + RID + "-" + PARAMETER + ".jpg";
                    Log.i(TAG,"Save '" + newName + "' ...");
                    File file = new File(iFotoPath, newName);
                    FOTONAME = newName;

                    // remove old Version
                    if (file.exists()) {
                        file.delete();
                    }

                    // save jpg
                    FileOutputStream fOut = new FileOutputStream(file);
                    bm.compress(Bitmap.CompressFormat.JPEG, 85, fOut);
                    fOut.flush();
                    fOut.close();

                    Log.i(TAG,"Saved!");
                    dotCount = 0;

                } catch (Exception e) {
                    Log.e(TAG, "", e);
                }
            }
        }

        @Override
        public void onWindowFocusChanged (boolean hasWindowFocus) {

            Log.i(TAG,"FocusChanged with " + dotCount + " Dots");
            if (!hasWindowFocus) {

             saveJPG();

            }

        }

        @Override
        protected void onDraw(Canvas canvas) {

            canvas.drawPath(path_dot, paint_dot);
            canvas.drawPath(path_line, paint_line);
        }

        @Override
        public boolean onTouchEvent(MotionEvent event) {


            float eventX = event.getX();
            float eventY = event.getY();

            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:

                    path_dot.addCircle(
                            eventX,
                            eventY,
                            STIFT_KLECKS,
                            Path.Direction.CW);
                    path_line.moveTo(eventX, eventY);
                    break;

                case MotionEvent.ACTION_MOVE:
                case MotionEvent.ACTION_UP:

                    dotCount++;
                    path_line.lineTo(eventX, eventY);

                    // Feedback to User: Minimum Data now collected
                    if (dotCount>=MINIMUM_DOT_COUNT) {
                        setBackgroundColor(0xFFebf5d7);
                        //
                    }


                    break;

                default:
                    return false;
            }

            invalidate((int) (eventX - 10.0),(int) (eventY-10.0),(int)(eventX+20.0),(int)(eventY+20.0));
            return true;
        }
    }

    public void createUnterschrift() {

        Log.d(TAG,"createUnterschrift");
        setTitle("Bitte unterschreiben");

        // load local used data (used for the Name of the jpg)
        SharedPreferences savedInput = this.getSharedPreferences(cSAVE,
                Context.MODE_PRIVATE);
        RID = savedInput.getString(cSAVE_RID, Integer.toString(iIndex));
        PARAMETER = savedInput.getString(cSAVE_PARAMETER, "");

        try {

            viewUnterschrift = new LinearLayout(this);
            viewUnterschrift.setOrientation(LinearLayout.VERTICAL);
            viewUnterschrift.setBackgroundColor(0xFFFFFFFF);
            viewUnterschrift.setFocusable(true);
            viewUnterschrift.setFocusableInTouchMode(true);

            canvasUnterschrift = new Unterschrift(this);
            viewUnterschrift.addView(canvasUnterschrift);

            setContentView(viewUnterschrift);

        } catch (Exception e) {
            Log.e(TAG, "createUnterschrift", e);
        }
    }

    public void createFoto() {

        Log.d(TAG,"createFoto");

        // load local used data (used for the Name of the jpg)
        SharedPreferences savedInput = this.getSharedPreferences(cSAVE,
                Context.MODE_PRIVATE);
        PARAMETER = savedInput.getString(cSAVE_PARAMETER, "");
        FOTONAME = savedInput.getString(cSAVE_FOTONAME, "");

        setTitle(PARAMETER+"-Foto prüfen");

        try {

            viewFoto = new ScrollView(this);
            LinearLayout l = new LinearLayout(this);
            l.setOrientation(LinearLayout.VERTICAL);

            // ImageView, load with jpg-Picture-File
            ImageView imgView = new ImageView(this);

            // this is due a bug in "decodeFile", BitmapFactory do not
            // eval the orientation stored in .jpg
            imgView.setRotation(90f);
            imgView.setLayoutParams(new GridView.LayoutParams(544, 544)); // 1088 DIV 2

            File imgFile = new  File(iFotoPath,"$" + FOTONAME);
            if(imgFile.exists()){
                imgView.setImageBitmap(BitmapFactory.decodeFile(imgFile.getAbsolutePath()));
            } else {
                imgView.setBackgroundResource(R.drawable.logo);
            }
            l.addView(imgView);

            // Button Area
            LinearLayout butView = new LinearLayout(this);
            butView.setOrientation(LinearLayout.HORIZONTAL);
            butView.setGravity(Gravity.RIGHT);

            // Button "Canel"
            Button b1 = new Button(this);
            b1.setText(" NOCHMAL ");
            b1.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {

                    // remove the "$"-File
                    imgFile.delete();
                    iView = VIEW_PROTOKOLL;
                    reboot();

                }});
            butView.addView(b1);

            // Button "OK"
            Button b2 = new Button(this);
            b2.setText(" OK ");
            b2.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {

                    // rename the "$"-File to real Photo-Filename
                    // so this is visible to Uploader
                    imgFile.renameTo(new File(iFotoPath, FOTONAME));

                    // add to Gallery
                    galleryAdd(new File(iFotoPath, FOTONAME));

                    // set PARAMETER=Photo-Filename
                    saveSingleParameter(PARAMETER, FOTONAME);
                    saveEditContext();

                    // Press "Start" for Upload-Service-Thread
                    startService(new Intent(iThis, orgaMonUploader.class));

                    iView = VIEW_PROTOKOLL;
                    reboot();

                }});
            butView.addView(b2);
            l.addView(butView);
            viewFoto.addView(l);

            setContentView(viewFoto);

        } catch (Exception e) {
            Log.e(TAG, "createFoto", e);
        }
    }

    public void createListe() {

        Log.d("Liste", "create");
        setTitle("Auftragsliste");

        try {
            setContentView(R.layout.auftragliste);
            viewListe = (ListView) findViewById(R.id.auftragliste);
            viewListe.setAdapter(new Auftraege(this));

            // normaler Listen Click -> Protokoll oder Autoscan
            viewListe.setOnItemClickListener(new OnItemClickListener() {

                public void onItemClick(AdapterView<?> a, View v, int position,
                                        long id) {

                    if (inputable(position)) {

                        // Context anpassen
                        if (inSearch()) {
                            iIndex = fromSearch(position);
                            endSearch();
                        } else {
                            iIndex = position;
                        }
                        iProtokoll = prepareEditContext();

                        if (iScan.length() == 0) {

                            // Schalte in das Protokoll & speichern
                            iView = VIEW_PROTOKOLL;
                            saveSettings();

                            // rufe zu dem Datensatz die Eingaben auf!
                            createProtokoll();

                        } else {

                            // speichern
                            saveSettings();

                            // rufe zu dem Datensatz den Scanner auf!
                            createScan();

                        }
                    }
                }
            });

            // langer Click -> geht IMMER ins Protokoll
            viewListe.setOnItemLongClickListener(new OnItemLongClickListener() {

                public boolean onItemLongClick(AdapterView<?> a, View v,
                                               int position, long id) {

                    if (inputable(position)) {
                        // Context anpassen
                        if (inSearch()) {
                            iIndex = fromSearch(position);
                            endSearch();
                        } else {
                            iIndex = position;
                        }
                        iView = VIEW_PROTOKOLL;
                        iProtokoll = prepareEditContext();
                        saveSettings();

                        // rufe zu dem Datensatz die Eingaben auf!
                        createProtokoll();
                    }
                    return true;
                }
            });

        } catch (Exception e) {
            Log.e(APP, "", e);
        }

        // Cursor auf den passenden Datensatz setzen
        viewListe.setSelection(iIndex);

    }

    static public String fullHost() {
        return iHost + "." + cTLD;
    }

    static public String urlPrefix() {
        return "https://" + fullHost() + "/";
    }

    public void createEinstellungen() {

        setTitle(APP + " " + REV);

        viewSettings = new LinearLayout(this);
        viewSettings.setId(100);
        viewSettings.setOrientation(LinearLayout.VERTICAL);
        setContentView(viewSettings);

        TextView viewSettings_Title = new TextView(this);
        viewSettings_Title.setText("Einstellungen");
        viewSettings_Title.setTextColor(0xFFFFFF00);
        viewSettings_Title.setTextSize(40, 0);
        viewSettings.addView(viewSettings_Title);

        TextView viewSettings_Status = new TextView(this);
        viewSettings_Status.setText(
                /**/"TAN:  " + iTAN + "\n" +
                        /**/"Aktualität:  " + iStandTxt + "\n" +
                        /**/"letzter Fehler:  " + iLastError + "\n\n" +
                        /**/"Aufträge:  " + Integer.toString(iIndex + 1) + "/" + iAnz + "\n");
        viewSettings.addView(viewSettings_Status);


        // Geräte Nummer
        LinearLayout viewSettings_1 = new LinearLayout(this);
        viewSettings_1.setId(101);
        viewSettings_1.setOrientation(LinearLayout.HORIZONTAL);

        TextView viewSettings_1_t1 = new TextView(this);
        viewSettings_1_t1.setId(102);
        viewSettings_1_t1.setText("Geräte Nummer:");
        viewSettings_1.addView(viewSettings_1_t1);

        viewSettings_geraeteNo = new EditText(this);
        viewSettings_geraeteNo.setId(103);
        viewSettings_geraeteNo.setInputType(InputType.TYPE_CLASS_TEXT);
        viewSettings_geraeteNo.setHint("nnn");
        viewSettings_geraeteNo.setText(iGeraeteNo);
        viewSettings_1.addView(viewSettings_geraeteNo);

        viewSettings.addView(viewSettings_1);


        // Bezeichnung
        LinearLayout viewSettings_2 = new LinearLayout(this);
        viewSettings_2.setId(104);
        viewSettings_2.setOrientation(LinearLayout.HORIZONTAL);

        TextView viewSettings_2_t = new TextView(this);
        viewSettings_2_t.setId(105);
        viewSettings_2_t.setText("Firma:");
        viewSettings_2.addView(viewSettings_2_t);

        viewSettings_server = new EditText(this);
        viewSettings_server.setId(106);
        viewSettings_server.setInputType(InputType.TYPE_TEXT_VARIATION_URI);
        viewSettings_server.setHint(iHost_DEFAULT);
        viewSettings_server.setText(iHost);
        viewSettings_2.addView(viewSettings_server);

        viewSettings.addView(viewSettings_2);

        LinearLayout viewSettings_3 = new LinearLayout(this);
        viewSettings_3.setId(107);
        viewSettings_3.setOrientation(LinearLayout.HORIZONTAL);

        Button viewSettings_3_b1 = new Button(this);
        viewSettings_3_b1.setId(108);
        viewSettings_3_b1.setText("Speichern");
        viewSettings_3_b1.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                // Button "SPEICHERN"
                String i = viewSettings_geraeteNo.getText().toString();
                boolean makeSense = false;

                switch (i.length()) {
                    case 3:
                        iGeraeteNo = i;
                        makeSense = true;
                        break;
                    case 4:

                        if (i.equals("1000")) {
                            // restore all the defaults!
                            iFotoPath = iFotoPath_DEFAULT;
                            iHost_FTP = "";
                            iFTPS = "true";
                            iFotoConfirm = "true";
                            makeSense = true;
                        }

                        if (i.equals("1001")) {
                            iFotoPath = "/mnt/sdcard/DCIM/Camera";
                            makeSense = true;
                        }


                        if (i.equals("1002")) {
                            iFotoPath = "/mnt/sdcard/DCIM/100ANDRO";
                            makeSense = true;
                        }

                        if (i.equals("1003")) {
                            iFotoPath = "/storage/extSdCard/DCIM/Camera";
                            makeSense = true;
                        }

                        if (i.equals("1004")) {
                            iFotoPath = "/storage/emulated/0/DCIM/Camera";
                            makeSense = true;
                        }

                        if (i.equals("1005")) {
                            iFotoPath = iFotoPath_DEFAULT; // "/storage/emulated/0/Pictures" (default)
                            makeSense = true;
                        }


                        // Fall back to FTP - UNSECURE
                        if (i.equals("1006")) {
                            iFTPS = "false";
                            makeSense = true;
                        }


                        if (i.equals("1007")) {
                            iHost_FTP = "ftp.local";
                            makeSense = true;
                        }

                        if (i.equals("1008")) {
                            iFotoConfirm = "false";
                            makeSense = true;
                        }

                        break;
                    case 9:
                        iPwd = i;
                        makeSense = true;
                        break;
                    case 15:
                        iHandyId = i;
                        makeSense = true;
                        break;
                }
                // revert visible value to iGeraeteNo
                if (makeSense)
                  viewSettings_geraeteNo.setText(iGeraeteNo);

                // b) Hostname
                iHost = viewSettings_server.getText().toString();

                saveSettings();
            }
        });

        Button viewSettings_3_b2 = new Button(this);
        viewSettings_3_b2.setId(109);
        viewSettings_3_b2.setText("Abbruch");
        viewSettings_3.addView(viewSettings_3_b1);
        viewSettings_3.addView(viewSettings_3_b2);

        viewSettings.addView(viewSettings_3);
    }

    public String prev(String path) {

        String s = path;
        int k = s.lastIndexOf("/");
        if (k > 0) {
            s = s.substring(0, k);
            k = s.lastIndexOf("/");
            s = s.substring(0, k + 1);
        }
        return s;

    }

    public boolean isRoot(String path) {
        return (path.lastIndexOf("/") == path.indexOf("/"));
    }

    public void createScan() {

        //
        // Startet direkt den Barcode-Scanner
        //
        // In iScan steht die Reihenfolge der Scan-Protokollfelder
        SharedPreferences savedInput = this.getSharedPreferences(cSAVE,
                Context.MODE_PRIVATE);

        String[] p = iScan.split(cDELIMITER);
        int j;
        for (j = 0; j < p.length; j++) {

            // Suche einen leeren Paramter, der noch nicht gefüllt ist
            if (savedInput.getString(p[j], "").equals("")) {

                SCAN = p[j];
                Log.d("Scan!", SCAN + " because its empty");

                // Scan!
                saveSingleParameter(cSAVE_SCAN, SCAN);

                // Start Scan
                Intent intent = new Intent(
                        "com.google.zxing.client.android.SCAN");

                intent.putExtra("PROMPT_MESSAGE", TITEL + " [" + iBarcode + "]");
                intent.putExtra("SCAN_FORMATS", iBarcode);
                intent.putExtra("RESULT_DISPLAY_DURATION_MS", 0L);

                startActivityForResult(intent, INTENTHANDLE_ZXING);

                break;
            }
        }
    }

    public void createProtokoll() {

        // Erzeugt aus persistent abgelegten Daten ein Protokoll-View

        //
        // Ein Protokoll ist ein Baum aus Formularen, eingeleitet
        // durch "(", abgeschlossen durch ein alleinstehendes ")"
        // In den "Leveln" kann mit "Auruf" und "Rücksprung" navigiert
        // werden
        //

        //
        // Im Protokollbezeichner wird der Protokollabschnitt
        // bezeichnet, der angezeigt werden soll, er setzt sich
        // zusammen aus
        // ~Protokollname~ { "/" ~Unterebene~ }
        //

        //
        // der Parser sucht den Beginn des Formulares und
        // geht nur bis zum Ende des Formualres, dabei sind
        // aus dem Gesamt-Protokoll nur die "Homies" wertvoll
        // Sinkt der Parser-Level unter den Homie-Level kann
        // das Parsen abgebrochen werden.
        //

        viewProtokoll = new ScrollView(this);
        LinearLayout l = new LinearLayout(this);
        SharedPreferences savedInput = this.getSharedPreferences(cSAVE,
                Context.MODE_PRIVATE);

        // einfach mal den aktuellen Context-bilden
        PROTOKOLL = iProtokoll;
        RID = savedInput.getString(cSAVE_RID, Integer.toString(iIndex));
        Log.i(TAG, "Protokoll.load " + RID);

        PARAMETER = savedInput.getString(cSAVE_PARAMETER, "");
        SCAN = savedInput.getString(cSAVE_SCAN, "");
        TITEL = savedInput.getString(cSAVE_TITLE, Integer.toString(iIndex));
        FOCUS = Integer.parseInt(savedInput.getString(cSAVE_FOCUS + PROTOKOLL,
                "0"));
        String[] r = savedInput.getString(cSAVE_FULLDATA,"").split(cDELIMITER);

        l.setOrientation(LinearLayout.VERTICAL);
        viewProtokoll.addView(l);
        setContentView(viewProtokoll);

        // Titel dazumachen
        // Es kann sich jetzt nur noch um festen Text handeln!
        TextView f_i = new TextView(this);
        f_i.setText(TITEL);
        f_i.setTextSize(28);
        f_i.setTextColor(0xFFFFFF00);
        l.addView(f_i);

        // Content dazumachen

        String fullName = iProtokoll;
        String name;
        String home;
        int k;
        int localId = 200; // hard coded Ids from 100..199, dynamic from 700..

        k = fullName.indexOf("/");
        if (k == -1) {
            name = fullName;
            home = "/";
        } else {
            name = fullName.substring(0, k);
            home = fullName.substring(k);
        }
        Log.d("Protokoll", name + home);

        // Gott schütze den Telefon-Parser
        if (home.equals("/"))
        try {
            String telInfo = r[COLUMN_MONTEUR_INFO];
            //
            // Tests:
            // telInfo = "Tel. Tina 92928283";
            // telInfo = "Tel. Bibbi 92928283, Tina 161616161616";
            //
            boolean firstButton = true;
            LinearLayout tel_Bottom = new LinearLayout(this);
            tel_Bottom.setId(localId++);
            tel_Bottom.setOrientation(LinearLayout.VERTICAL);
            while (true) {

                // suche den Einleitungs-Text
                int t1 = telInfo.indexOf("Tel. ");
                if (t1==-1)
                    break;

                telInfo = telInfo.substring(t1 + 4) + ", ";
                while (true) {
                    int k1 = telInfo.indexOf(", ");
                    if (k1==-1)
                        break;
                    String buttonMsg = telInfo.substring(1, k1);
                    telInfo = telInfo.substring(k1 + 1);

                    Button f_tel = new Button(this);
                    f_tel.setId(localId++);
                    f_tel.setText(buttonMsg);
                    f_tel.setAllCaps(false);
                    f_tel.setTag(buttonMsg.replaceAll("[^+0123456789]", ""));
                    f_tel.setOnClickListener(new View.OnClickListener() {
                        public void onClick(View v) {

                            String clipS = (String) v.getTag();

                            // Copy to Clipboard
                            ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                            ClipData clip = ClipData.newPlainText("Kontakt", clipS);
                            clipboard.setPrimaryClip(clip);

                            // give User Feedback
                            Toast toast = Toast.makeText(getApplicationContext(), clipS+" kopiert", Toast.LENGTH_SHORT);
                            toast.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL, 0, 0);
                            toast.show();
                        }
                    });
                    tel_Bottom.addView(f_tel);
                    firstButton = false;
                }
            }
            if (!firstButton) {
                l.addView(tel_Bottom);
                l.addView((ImageView) inflater.inflate(
                        R.layout.trenner, null));
            }
        } catch (Exception e) {
            Log.e(TAG, "Telefon-Parser", e);
        }

        // Obligatorische Buttons
        LinearLayout l_Bottom = new LinearLayout(this);
        l_Bottom.setId(localId++);
        l_Bottom.setOrientation(LinearLayout.HORIZONTAL);

        Button f_Abbruch = new Button(this);
        f_Abbruch.setId(localId++);
        f_Abbruch.setText("Abbruch");
        f_Abbruch.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                //
                if (isRoot(iProtokoll)) {
                    iView = VIEW_LISTE;
                } else {
                    iProtokoll = prev(iProtokoll);
                }
                reboot();
            }
        });
        l_Bottom.addView(f_Abbruch);

        Button f_OK = new Button(this);
        f_OK.setId(localId++);
        f_OK.setText(" Speichern und Zurück ");
        f_OK.setTextSize(19);
        f_OK.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                // "focused" ist das EditText welches noch immer den
                // Eingabe-Fokus besitzt, es wurde von Android jedoch
                // versäumt einen Fokus-Entzug zu melden.
                if (focused != null) {

                    // Log.d("EditText"," " + focused.getTag());
                    String p = ((String) focused.getTag());

                    if (!p.equals("12")) {
                        saveSingleParameter(
                                /**/p,
                                /**/focused.getText().toString());
                    }

                    focused = null;
                }

                // speichern!
                if (saveEditContext()) {

                    // Verzweigen in ...
                    if (isRoot(iProtokoll)) {
                        iView = VIEW_LISTE;
                    } else {
                        iProtokoll = prev(iProtokoll);
                    }
                }

                reboot();
            }
        });
        l_Bottom.addView(f_OK);
        l.addView(l_Bottom);

        // Gott schütze den Protokoll-Parser
        try {
            // Protokoll
            SharedPreferences p = this.getSharedPreferences(name,
                    Context.MODE_PRIVATE);

            int protokollLine = 0;
            int level = 0;
            int form = 0;
            String s;
            String path = "/";
            String fullTitle = "/";
            String newPath = "";
            String parameterName = "Basis-Daten";
            String parameterValue = "";
            boolean newForm;
            boolean insideRadioGroup = false;
            boolean firstHomie = true;
            RadioGroup f_rg = null;
            int indexRadioButton = 0;
            int homieLevel = 0;
            while (true) {

                s = p.getString(Integer.toString(protokollLine++), null);
                if (s == null) {
                    break;
                }

                // Log.d("Protokoll.*", s);

                if (s.equals(")")) {
                    level--;
                    if (level < homieLevel) {
                        Log.d("Optimizer", "break");
                        break;
                    }
                    path = prev(path);
                    fullTitle = prev(fullTitle);
                    continue;
                }

                // Verschiedene Stati setzen und vorauswählen treffen
                newForm = s.startsWith("(");
                if (newForm) {
                    level++;
                    s = s.substring(1);
                    parameterName = s;
                    newPath = path + Integer.toString(form++) + "/";
                    fullTitle += s + "/";
                }

                if (s.length() == 0) {
                    continue;
                }

                if (home.equals(path)) {

                    if (firstHomie) {
                        if (fullTitle.equals("/")) {
                            setTitle("Basis-Daten");
                        } else {
                            setTitle(fullTitle);
                        }
                        homieLevel = level;
                        firstHomie = false;
                    }

                    // Log.d("Protokoll.homies", s);

                    while (true) {

                        // Soll ein Variablen-Wert bekannt gemacht werden?
                        // "~parameterName~="
                        if (s.length() - 1 == s.indexOf("=")) {
                            parameterName = s.substring(0, s.length() - 1);
                            break;
                        }

                        // Nun "~parameterName~" durch seinen Wert ersetzten
                        int k1 = s.indexOf("~");
                        if (k1 > -1) {
                            int k2 = s.lastIndexOf("~");
                            if (k2 > k1) {
                                Log.d("dereference",
                                        s.substring(k1 + 1, k2)
                                                + "="
                                                + savedInput.getString(
                                                s.substring(k1 + 1, k2),
                                                ""));
                                s =
                                        /**/s.substring(0, k1)
                                        + "("
                                        + savedInput.getString(
                                        s.substring(k1 + 1, k2), "")
                                        + ")";
                                Log.d("dereferenced", s);

                            }
                        }

                        // Beginnt ein neues Formular
                        if (newForm) {

                            // Jetzt wird ein Sub-Opener-Knopf gemacht
                            Button f_b = new Button(this);
                            f_b.setId(localId++);
                            f_b.setText(s);
                            f_b.setTextSize(18);
                            f_b.setTag(name + newPath);
                            f_b.setOnClickListener(new View.OnClickListener() {
                                public void onClick(View v) {

                                    // sicherstellen, dass fokusiert wird!
                                    v.setFocusableInTouchMode(true);
                                    v.requestFocus();

                                    iProtokoll = (String) v.getTag();
                                    reboot();
                                }
                            });
                            l.addView(f_b);

                            break;
                        }

                        // Foto?
                        if (s.startsWith("F;")) {
                            s = s.substring(2);

                            Button f_b = new Button(this);
                            f_b.setId(localId++);
                            f_b.setText(s);
                            f_b.setTextSize(18);
                            f_b.setTag(parameterName);
                            f_b.setOnClickListener(new View.OnClickListener() {
                                public void onClick(View v) {

                                    // sicherstellen, dass fokusiert wird!
                                    v.setFocusableInTouchMode(true);
                                    v.requestFocus();

                                    // Sichern, bei welchem Foto wir im Moment
                                    // sind
                                    PARAMETER = (String) v.getTag();
                                    saveSingleParameter(cSAVE_PARAMETER, PARAMETER);

                                    if (PARAMETER.startsWith("FU")) {

                                        // versuche den Focus zu speichern
                                        saveSingleParameter(cSAVE_FOCUS + PROTOKOLL, Integer.toString(v.getId()));

                                        // Unterschrift
                                        FOTONAME = null;
                                        iView = VIEW_UNTERSCHRIFT;
                                        reboot();

                                    } else {

                                        Log.d("Foto", "Intent()...");

                                        // Prepare Foto Intent
                                        Intent camera = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

                                        // Android 11, no more Camera-Picker
                                        camera.setClassName("net.sourceforge.opencamera",
                                                "net.sourceforge.opencamera.MainActivity");

                                        if (camera.resolveActivity(getPackageManager()) != null) {

                                            // Berechne den Speicherort + Dateiname  für das Foto
                                            // der Pfad
                                            File storageDir = getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
                                            if (iFotoPath!=storageDir.getAbsolutePath()) {
                                                Log.d("Foto", "ERROR: iFotoPath<>" + storageDir.getAbsolutePath());
                                            }

                                            // Dateinamen
                                            FOTONAME = iGeraeteNo + "-" + RID;
                                            if (PARAMETER != "") {
                                                FOTONAME += "-" + PARAMETER;
                                            }

                                            // Existiert der Dateiname schon?
                                            File f = new File(iFotoPath,FOTONAME+".jpg");
                                            int i = 0;
                                            while (true) {
                                                if (!f.exists())
                                                    break;
                                                f = new File(
                                                    iFotoPath,
                                                FOTONAME + "-" + Integer.toString(++i) + ".jpg");
                                            }

                                            if (i>0)
                                              FOTONAME += "-" + Integer.toString(i);
                                            FOTONAME += ".jpg";

                                            // Foto-Dateiname ist nun bekannt
                                            saveSingleParameter(cSAVE_FOTONAME, FOTONAME);

                                            File file = null;
                                            if (iFotoConfirm.equals("true")) {

                                                // markiere die Datei als "vorläufig"
                                                // wichtig, um die Datei für den Upload-Thread unsichtbar zu halten
                                                file = new File(iFotoPath,"$" + FOTONAME);

                                            } else {
                                                file = new File(iFotoPath, FOTONAME);
                                            }

                                            // "file" bekannt geben
                                            Log.d("Foto", file.getAbsolutePath());
                                            Uri fileProvider = FileProvider.getUriForFile(
                                                    amCreateActivity.this,
                                                    "org.orgamon.orgamon.fileprovider",
                                                    file);
                                            camera.putExtra(MediaStore.EXTRA_OUTPUT, fileProvider);

                                            Log.d("Foto", "Camera-Intent(" + file.getName() + ")" );

                                            // Foto-INTENT aufrufen
                                            startActivityForResult(camera,
                                                    INTENTHANDLE_CAMERA);
                                        } else {
                                            Log.d("Foto", "ERROR: resolveActivity failed");
                                        }
                                    }

                                }
                            });
                            l.addView(f_b);
                            break;

                        }

                        // Scan?
                        if (s.startsWith("S;")) {
                            s = s.substring(2);

                            Button f_b = new Button(this);
                            f_b.setId(localId++);
                            f_b.setText(s);
                            f_b.setTextSize(18);
                            f_b.setTag(parameterName);
                            f_b.setOnClickListener(new View.OnClickListener() {
                                public void onClick(View v) {

                                    // sicherstellen, dass fokusiert wird!
                                    v.setFocusableInTouchMode(true);
                                    v.requestFocus();

                                    SCAN = (String) v.getTag();
                                    saveSingleParameter(cSAVE_SCAN, SCAN);

                                    // Start Scan
                                    Intent intent = new Intent(
                                            "com.google.zxing.client.android.SCAN");

                                    intent.putExtra("PROMPT_MESSAGE", TITEL + " [" + iBarcode + "]");
                                    intent.putExtra("SCAN_FORMATS", iBarcode);
                                    intent.putExtra("RESULT_DISPLAY_DURATION_MS", 0L);

                                    Log.i("zxing", v.getId() + ";" + iBarcode);

                                    startActivityForResult(intent, INTENTHANDLE_ZXING);

                                }
                            });
                            l.addView(f_b);
                            break;

                        }

                        // Ist es ein Bobbele (RadioButton)
                        if (s.startsWith("B;")) {

                            // erst mal eine Gruppe öffnen
                            if (!insideRadioGroup) {
                                indexRadioButton = 0;
                                insideRadioGroup = true;
                                f_rg = new RadioGroup(this);
                                f_rg.setId(localId++);
                            }

                            // Modifier berechnen
                            StringTokenizer tokens = new StringTokenizer(s, ";");
                            tokens.nextToken();
                            s = tokens.nextToken();
                            if (tokens.hasMoreTokens())
                                parameterValue = tokens.nextToken();
                            else
                                parameterValue = Integer
                                        .toString(++indexRadioButton);

                            RadioButton f_rb = new RadioButton(this);
                            f_rb.setId(localId++);
                            f_rb.setText(s);
                            f_rb.setTextSize(20);
                            f_rb.setChecked(savedInput.getString(parameterName,
                                    "").equals(parameterValue));
                            f_rb.setTag(parameterName + ";" + parameterValue);
                            f_rb.setOnClickListener(new View.OnClickListener() {
                                public void onClick(View v) {
                                    String[] r = ((String) v.getTag())
                                            .split(cDELIMITER);
                                    saveSingleParameter(r[0], r[1]);
                                }
                            });
                            f_rg.addView(f_rb);
                            break;
                        }

                        if (insideRadioGroup) {
                            // die Gruppe nun schliessen
                            insideRadioGroup = false;
                            l.addView(f_rg);
                        }

                        // Is es ein Haken
                        // H;"Bezeichnung";~TrueWert~;~FalseWert~
                        if (s.startsWith("H;")) {
                            s = s.substring(2);

                            // Mach den Haken!
                            CheckBox f_cb = new CheckBox(this);
                            f_cb.setId(localId++);
                            f_cb.setText(s);
                            f_cb.setTextSize(20);
                            f_cb.setChecked(savedInput.getString(parameterName,
                                    "").equals("J"));

                            // imp pend: Diese Info später direkt aus dem
                            // Protokoll
                            // mit Default wie früher ";X"
                            f_cb.setTag(parameterName + ";J;N");
                            f_cb.setOnClickListener(new View.OnClickListener() {
                                public void onClick(View v) {

                                    // Interprätiere den Modifier
                                    String[] r = ((String) v.getTag())
                                            .split(cDELIMITER);
                                    String v_true = "X";
                                    String v_false = "";
                                    if (r.length > 1) {
                                        v_true = r[1];
                                    }
                                    if (r.length > 2) {
                                        v_false = r[2];
                                    }
                                    // Sichere den aktuellen Status
                                    if (((CheckBox) v).isChecked())
                                        saveSingleParameter(r[0], v_true);
                                    else
                                        saveSingleParameter(r[0], v_false);
                                }
                            });
                            l.addView(f_cb);
                            break;
                        }

                        if (s.indexOf(";") == 1) {

                            // Eingabefeld
                            EditText f_e = new EditText(this);
                            f_e.setId(localId++);
                            switch (s.charAt(0)) {
                                case 'N':
                                    f_e.setInputType(InputType.TYPE_CLASS_NUMBER);
                                    break;
                                case 'D':
                                    f_e.setInputType(InputType.TYPE_CLASS_NUMBER
                                            + InputType.TYPE_NUMBER_FLAG_DECIMAL);
                                    break;
                                case 'A':
                                    f_e.setInputType(InputType.TYPE_CLASS_TEXT);
                                    break;
                                case 'T':
                                    f_e.setInputType(InputType.TYPE_CLASS_DATETIME);
                                    break;
                            }

                            s = s.substring(2);
                            if (startsNotWithNumeric(parameterName))
                                f_e.setHint(parameterName);
                            f_e.setTag(parameterName);
                            f_e.setText(savedInput.getString(parameterName, ""));

                            f_e.setOnFocusChangeListener(new View.OnFocusChangeListener() {
                                public void onFocusChange(View v,
                                                          boolean hasFocus) {

                                    // "p"aramter
                                    String p = (String) v.getTag();

                                    // "i"nhalt
                                    String i = ((EditText) v)
                                            .getText().toString();

                                    if (!hasFocus) {

                                        focused = null;

                                        // Log.d("EditText",((String)
                                        // v.getTag()) + ".looseFocus");

                                        if (p.equals("12")) {

                                            Log.d("DoppelEingabe", "bisher '"
                                                    + VorEingabe + "', nun '"
                                                    + i + "'");

                                            if (!i.equals(VorEingabe)) {

                                                // es wurde was neues eingegeben
                                                if (!i.equals(DoppelEingabe)) {

                                                    DoppelEingabe = i;
                                                    ((EditText) v).setText("");
                                                    requestFocus = (EditText) v;

                                                } else {
                                                    // nur speichern wenn
                                                    // identisch zu
                                                    // "Doppeleingabe"
                                                    saveSingleParameter(
                                                            /**/((String) v.getTag()),
                                                            /**/i);

                                                }

                                            }

                                        } else {
                                            // sofort speichern
                                            saveSingleParameter(
                                                    /**/((String) v.getTag()),
                                                    /**/i);
                                        }

                                    } else {

                                        // !hasFocus
                                        if (requestFocus != null) {

                                            if (v != requestFocus) {
                                                // v.clearFocus();
                                                requestFocus.requestFocus();
                                            }
                                            requestFocus = null;

                                        } else {

                                            focused = (EditText) v;
                                            VorEingabe = i;
                                        }
                                        // Log.d("EditText",((String)
                                        // v.getTag()) + ".gainFocus");
                                    }
                                }
                            });

                            l.addView(f_e);
                            break;
                        }

                        // Ist es ein Trenner?
                        if (s.indexOf("--") == 0) {

                            l.addView((ImageView) inflater.inflate(
                                    R.layout.trenner, null));
                            break;
                        }

                        // Sind es "Protokoll-lokale" Einstellungen?
                        if (s.indexOf("%") == 0) {

                            execMe(s.substring(1));
                            break;
                        }

                        // Es kann sich jetzt nur noch um festen Text handeln!
                        TextView f_t = new TextView(this);
                        f_t.setId(localId++);
                        f_t.setText(s);
                        f_t.setTextSize(20);
                        l.addView(f_t);
                        break;
                    }

                }

                if (newForm) {
                    path = newPath;
                }

            }
        } catch (Exception e) {
            Log.e(TAG, "Protokoll-Parser", e);
        }

        // set Focus to old Input
        try {
            if (FOCUS != 0) {
                View v = l.findViewById(FOCUS);
                if (v != null) {
                    v.setFocusableInTouchMode(true);
                    v.requestFocus();
                } else {
                    Log.e(TAG, "View " + Integer.toString(FOCUS)
                            + " nicht gefunden");
                }
            } else {
                if (iFocus.length() != 0) {

                    // Die Fokus-Reihenfolge ist mit Leerschritt getrennt
                    String[] p = iFocus.split(cDELIMITER);
                    int j;
                    for (j = 0; j < p.length; j++) {

                        // Ist das Eingabefeld leer? Nur in diesem Fall wird
                        // fokusiert
                        if (savedInput.getString(p[j], "").equals("")) {

                            Log.d(TAG, "Focus goes to " + p[j] + " because its still empty");

                            // Suche das passende View
                            View v = l.findViewWithTag(p[j]);
                            if (v != null) {

                                // set Focus!
                                v.setFocusableInTouchMode(true);
                                v.requestFocus();
                                break;
                            } else {
                                Log.e(TAG, "View.Tag=" + iFocus
                                        + " nicht gefunden. Fokus kann nicht erteilt werden");
                            }

                        }
                    }

                }
            }
        } catch (Exception e) {
            Log.e(TAG, "Focus", e);
        }
    }

    public void reboot() {
        saveSettings();
        Intent intent = getIntent();
        finish();
        invalidateOptionsMenu();
        startActivity(intent);
    }

    public boolean inSearch() {
         return (iTAN.contains(cSEARCH_FLAG));
    }

    public void endSearch() {

        if (inSearch()) {

            iAnz = iGesamt;
            iTAN = iTAN.substring(0, 5);
        }
    }

    public boolean inputable(int position) {

        SharedPreferences data = this.getSharedPreferences(iTAN,
                Context.MODE_PRIVATE);
        String s = data.getString(Integer.toString(position), null);
        if (s != null) {

            String[] r = s.split(cDELIMITER);

            int DatumAsInt;
            try {
                DatumAsInt = Integer.parseInt(r[COLUMN_EINGABE_DATUM]);
            } catch (Exception e) {
                DatumAsInt = 0;
            }

            switch (DatumAsInt) {

                case AS_INFO:
                    return false;

                case AS_WEGFALL:
                    return false;

            }
        }
        return true;
    }

    public int fromSearch(int position) {
        try {

            // read the index from the original List of the
            // actual search Record.
            SharedPreferences data = this.getSharedPreferences(iTAN,
                    Context.MODE_PRIVATE);
            String s = data.getString(Integer.toString(position), "");
            String r[] = s.split(cDELIMITER);

            if (r.length > COLUMN_INDEX) {

                int i = Integer.parseInt(r[COLUMN_INDEX]);
                Log.i("fromSearch", "Search[" + position + "] -> List[" + i
                        + "]");
                return i;
            } else {
                Log.d("fromSearch", "Mapping failed");
                return 0;
            }
        } catch (Exception e) {
            Log.e(APP, "fromSearch", e);
        }
        return 0;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        Log.d(APP, "onNewIntent");

        setIntent(intent);
        if (Intent.ACTION_SEARCH.equals(intent.getAction())) {
            Log.d(APP, "SEARCH");
            String query = intent.getStringExtra(SearchManager.QUERY);
            doSearch(query);
        }
    }

    public void doSearch(String query) {

        // we want true data
        if (query == null) {
            return;
        }

        if (query == "") {
            return;
        }

        Log.i(APP, "doSearch("+query+")");

        // save Original Search Input
        iLastSearch = query;

        // suche!
        query = query.toLowerCase();
        SharedPreferences data = this.getSharedPreferences(iTAN,
                Context.MODE_PRIVATE);
        String[] r = query.split("\\ ");

        //
        SharedPreferences search = this.getSharedPreferences(
                iTAN + cSEARCH_FLAG, Context.MODE_PRIVATE);
        Editor editor = search.edit();
        editor.clear();
        String s;
        int treffer = 0;
        int found = 0;
        int w = 0;
        for (int i = 0; i < iAnz; i++) {

            s = data.getString(Integer.toString(i), "").toLowerCase();

            found = 0;
            for (w = 0; w < r.length; w++) {
                if (s.indexOf(r[w]) < 1)
                    break;
                found++;

            }

            if (found == r.length) {
                editor.putString(
                        /* Fortlaufender Treffer */Integer.toString(treffer),
                        /* Original Daten */data.getString(Integer.toString(i), "")
                                + ';' +
                                /* Index der Original Daten */Integer.toString(i));
                treffer++;
            }

        }
        editor.commit();

        data = null;
        search = null;

        if (treffer > 0) {

            iGesamt = iAnz;
            iTAN = iTAN + cSEARCH_FLAG;
            iAnz = treffer;
            iIndex = 0;
            reboot();

        } else {

            saveSettings();
            Toast.makeText(
                    /**/getApplicationContext(),
                    /**/"Suche nach " + iLastSearch + " war erfolglos!",
                    /**/Toast.LENGTH_LONG).show();
        }

    }

    public String FindANewPassword (int len) {

        String DATA = "123456789ABCDEFGHJKMNPQRSTUVWXYZ";
        Random RANDOM = new Random();
        StringBuilder sb = new StringBuilder(len);

        for (int i = 0; i < len; i++) {
          sb.append(DATA.charAt(RANDOM.nextInt(DATA.length())));
        }
        return sb.toString();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        Log.d(APP, REV);
        inflater = (LayoutInflater) this
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        loadSettings();

        // Plausibilisierung der Systemparameter
        if (iAnz == 0) {
            iView = VIEW_SETTINGS;
        }

        if (iSalt == cSALT) {
          iSalt = FindANewPassword(9);
        }

        switch (iView) {

            case VIEW_SETTINGS:
                createEinstellungen();
                break;
            case VIEW_LISTE:
                createListe();
                break;
            case VIEW_PROTOKOLL:
                createProtokoll();
                break;
            case VIEW_UNTERSCHRIFT:
                createUnterschrift();
                break;
            case VIEW_FOTO:
                createFoto();
                break;
        }

    }

    @Override
    public void onPause() {
        super.onPause();
        Log.d(APP, "Pause (View=" + iView + ")");
        try {

            switch (iView) {

                case VIEW_SETTINGS:
                    break;
                case VIEW_LISTE:
                    break;
                case VIEW_PROTOKOLL:

                    // Focus saver!
                    View v = getCurrentFocus();
                    if (v != null) {
                        Integer i = v.getId();
                        if (i>0) {
                            saveSingleParameter(cSAVE_FOCUS + PROTOKOLL,
                                    i.toString());
                        } else {
                            Log.i(APP, "focused view has no Id");
                        }
                    } else {
                        Log.d(APP, "nothing has focus");
                    }
                    break;
                case VIEW_UNTERSCHRIFT:

                    if (canvasUnterschrift!=null) {
                        canvasUnterschrift.saveJPG();
                    }
                    break;
            }
        } catch (Exception e) {
            Log.e(APP, "Pause", e);
        }
    }

    @Override
    public void onStop() {
        super.onStop();
        Log.d(APP, "Stop (View=" + iView + ")");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        try {

            Log.d("Menu", "create (View=" + iView + ")");
            MenuInflater inflater = getMenuInflater();
            inflater.inflate(R.menu.context, menu);

            switch (iView) {
                case VIEW_SETTINGS:

                    menu.findItem(R.id.c_liste).setVisible(true);
                    menu.findItem(R.id.c_search).setVisible(false);
                    menu.findItem(R.id.c_settings).setVisible(false);
                    menu.findItem(R.id.c_upload).setVisible(!inSearch());
                    menu.findItem(R.id.c_exit).setVisible(false);
                    menu.findItem(R.id.c_refresh).setVisible(false);
                    menu.findItem(R.id.c_start).setVisible(true);
                    menu.findItem(R.id.c_stop).setVisible(true);
                    break;

                case VIEW_LISTE:

                    menu.findItem(R.id.c_liste).setVisible(inSearch());
                    menu.findItem(R.id.c_search).setVisible(!inSearch());
                    menu.findItem(R.id.c_upload).setVisible(!inSearch());
                    menu.findItem(R.id.c_settings).setVisible(true);
                    menu.findItem(R.id.c_exit).setVisible(false);
                    menu.findItem(R.id.c_refresh).setVisible(false);
                    menu.findItem(R.id.c_start).setVisible(false);
                    menu.findItem(R.id.c_stop).setVisible(false);
                    break;

                case VIEW_PROTOKOLL:
                case VIEW_FOTO:

                    menu.findItem(R.id.c_liste).setVisible(true);
                    menu.findItem(R.id.c_search).setVisible(false);
                    menu.findItem(R.id.c_settings).setVisible(true);
                    menu.findItem(R.id.c_upload).setVisible(false);
                    menu.findItem(R.id.c_exit).setVisible(false);
                    menu.findItem(R.id.c_refresh).setVisible(false);
                    menu.findItem(R.id.c_start).setVisible(false);
                    menu.findItem(R.id.c_stop).setVisible(false);

                    break;
                case VIEW_UNTERSCHRIFT:

                    menu.findItem(R.id.c_liste).setVisible(true);
                    menu.findItem(R.id.c_search).setVisible(false);
                    menu.findItem(R.id.c_settings).setVisible(false);
                    menu.findItem(R.id.c_upload).setVisible(false);
                    menu.findItem(R.id.c_exit).setVisible(true);
                    menu.findItem(R.id.c_refresh).setVisible(true);
                    menu.findItem(R.id.c_start).setVisible(false);
                    menu.findItem(R.id.c_stop).setVisible(false);

                    break;
            }

        } catch (Exception e) {

            Log.e(APP, "CreateOptionsMenu", e);
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        Log.i(APP, "Menu Option selected");

        // Handle item selection
        switch (item.getItemId()) {

            case R.id.c_refresh:
                reboot();
                break;

            case R.id.c_exit:

                if (iView==VIEW_UNTERSCHRIFT) {

                    if (FOTONAME!=null) {

                        // save edits
                        saveSingleParameter(PARAMETER, FOTONAME);

                        // Big Save
                        saveEditContext();
                    }

                    startService(new Intent(iThis, orgaMonUploader.class));
                }
                iView = VIEW_PROTOKOLL;
                reboot();
                break;

            case R.id.c_search:
                onSearchRequested();
                break;

            case R.id.c_liste:

                // wieder in den Listen-Modus schalten
                iView = VIEW_LISTE;
                if (inSearch()) {
                    endSearch();
                }
                reboot();
                break;

            case R.id.c_upload:

                senden();
                break;

            case R.id.c_settings:

                iView = VIEW_SETTINGS;
                reboot();
                break;

            case R.id.c_start:

                startService(new Intent(this, orgaMonUploader.class));
                break;

            case R.id.c_stop:

                stopService(new Intent(this, orgaMonUploader.class));
                break;

            default:
                // drawView.beep();
                // return super.onOptionsItemSelected(item);
        }
        return true;
    }

    public Boolean goodCheckDigit(String scanCode) {

        final String TAG = "CheckDigit";

        // store Length
        int l = scanCode.length();

        // Length has to be 2 Chars at least
        if (l < 2) {

            Log.d(TAG, "ERROR: minimum scanCode-length is 2");
            return false;
        }

        // Length must be even
        if (l % 2 == 1) {

            Log.d(TAG, "ERROR: scanCode-Length must be even");
            return false;
        }

        //
        int checkSum = 0;
        int n = -1;
        for (int i = 0; true; i++) {

            n = Character.getNumericValue(scanCode.charAt(i));
            if (n < 0) {

                Log.d(TAG, "ERROR: scanCode should be pure numeric");
                return false;
            }

            if (i == l - 1)
                break;
            if (n > 0) {
                if (i % 2 == 0) {
                    checkSum += n * 3;
                } else {
                    checkSum += n;
                }
            }
        }

        checkSum = checkSum % 10;
        if (checkSum > 0) {
            checkSum = 10 - checkSum;
        }

        if (checkSum == n) {
            return true;
        } else {

            Log.d(TAG, "ERROR: scanCodes CheckDigit is '" + n
                    + "', but should be '" + checkSum + "'");
            return false;
        }
    }
    private void galleryAdd(File f) {

        // add to Gallery
        Intent galleryIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        galleryIntent.setData(Uri.fromFile(f));
        getApplicationContext().sendBroadcast(galleryIntent);
    }

    private void galleryRemove(File f) {
        // remove from Gallery
        ContentResolver resolver = getApplicationContext().getContentResolver();
        resolver.delete(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI, MediaStore.Images.Media.DATA +
                        "=?", new String[]{f.getAbsolutePath()});

    }

    // INTENT - CALL - BACKs
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == INTENTHANDLE_CAMERA) {
            if (resultCode == RESULT_OK) {

                // by this point we have the camera photo already on disk


                // Sorry, Must restart to reflect Foto-Name on Button / Confirm the photo
                if (iFotoConfirm.equals("true")) {
                    iView = VIEW_FOTO;
                } else {

                    // add to Gallery
                    galleryAdd(new File(iFotoPath, FOTONAME));

                    // Bildname aufzeichnen
                    saveSingleParameter(PARAMETER, FOTONAME);

                    // Press "Start" for Uploads
                    startService(new Intent(this, orgaMonUploader.class));

                }
                // Taking a Picture is a implicit "Save"
                saveEditContext();
                reboot();
            }
        }

        if (requestCode == INTENTHANDLE_ZXING) {
            if (resultCode == RESULT_OK) {
                while (true) {
                    // String format =
                    // data.getStringExtra("SCAN_RESULT_FORMAT");

                    // Barcode-Wert aufzeichnen
                    String s = data.getStringExtra("SCAN_RESULT");

                    // Barcode-Diagnose / wenn mal wieder "komische" Zeichen drin sind!
                    /*
                    Log.i(TAG,iBarcode+':');
                    byte[] b = s.getBytes(StandardCharsets.UTF_8);
                    for (int i = 0; i < b.length; i++) {

                        Log.i(TAG, String.valueOf(i)+':'+String.valueOf(b[i]));

                    }

                    10 = LF = \n
                    13 = CR = \r

                    Linux = LF
                    DOS   = CRLF
                    iOS   = CR

                    */

                    // Barcode immer auf die erste Zeile beschränken
                    int eol = Math.min(s.indexOf('\n'), s.indexOf('\r'));
                    if (eol!=-1) {
                        s = s.substring(0,eol);
                    }

                    if (iBarcode.equals("ITF")) {

                        // Prüfziffern Kontrolle
                        if (goodCheckDigit(s)) {
                            saveSingleParameter(SCAN, "+" + s);
                        } else {
                            saveSingleParameter(SCAN, "-" + s);
                        }

                        // Big Save
                        saveEditContext();
                        break;
                    }

                    if (iBarcode.equals("CODE_39")) {

                        // HeBu-Lager
                        // keine weitere Prüfung nötig
                        saveSingleParameter(SCAN, s);

                        // Zeitstempel dazu
                        saveSingleParameter(SCAN + "t", getTimestamp());

                        //
                        if (SCAN.equals("S1")) {
                            saveSingleParameter("18", "-4");
                        } else {
                            saveSingleParameter("14", "0");
                        }

                        // Big Save
                        if (saveEditContext()) {

                            // Listenansicht +/- 1
                            iView = VIEW_LISTE;
                            if (SCAN.equals("S1")) {
                                iIndex++;
                            } else {
                                iIndex--;
                            }

                        }
                        saveSettings();
                        break;
                    }

                    saveSingleParameter(SCAN, s);
                    saveEditContext();
                    break;
                }

                // Sorry, Must restart to reflect Scan-Result on Button
                reboot();

            }
        }

    }

    private static boolean startsNotWithNumeric(String s) {
        if (s.length() > 0) {
            return (!Character.isDigit(s.charAt(0)));
        }
        return false;
    }

    public static String getTimestamp() {

        Calendar ci = Calendar.getInstance();
        Date d = ci.getTime();
        return DateFormat.format("dd.MM.yyyy - kk:mm:ss", d).toString();
    }

    public static int getDate(String timestamp) {

        return (Integer.parseInt(timestamp.substring(6, 10)) * 10000
                + Integer.parseInt(timestamp.substring(3, 5)) * 100 + Integer
                .parseInt(timestamp.substring(0, 2)));
    }

    public static int getSeconds(String timestamp) {

        return (Integer.parseInt(timestamp.substring(13, 15)) * 3600
                + Integer.parseInt(timestamp.substring(16, 18)) * 60 + Integer
                .parseInt(timestamp.substring(19, 21)));
    }

    public boolean isNetworkAvailable() {
        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = cm.getActiveNetworkInfo();
        // if no network is available networkInfo will be null, otherwise check
        // if we are connected
        if (networkInfo != null && networkInfo.isConnected()) {
            return true;
        }
        return false;
    }

    public void senden() {

        // Letzte möglichkeit alles zu prüfen
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.INTERNET)
                != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(
                    /**/getApplicationContext(),
                    /**/"Berechtigung 'Internet' fehlt!",
                    /**/Toast.LENGTH_LONG).show();
            return;
        }
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_NETWORK_STATE)
                != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(
                    /**/getApplicationContext(),
                    /**/"Berechtigung 'Netzwerk Status' fehlt!",
                    /**/Toast.LENGTH_LONG).show();
            return;
        }
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(
                    /**/getApplicationContext(),
                    /**/"Berechtigung 'Kamera' fehlt!",
                    /**/Toast.LENGTH_LONG).show();
            return;
        }
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(
                    /**/getApplicationContext(),
                    /**/"Berechtigung 'Speicher' fehlt!",
                    /**/Toast.LENGTH_LONG).show();
            return;
        }

        // Prüfen, ob Netzwerk vorhanden
        if (!isNetworkAvailable()) {
            Toast.makeText(
                    /**/getApplicationContext(),
                    /**/"Senden im Moment nicht möglich, da kein Netz vorhanden!",
                    /**/Toast.LENGTH_LONG).show();
            return;
        }

        // Prüfen, ob eine Gerätenummer gesetzt ist
        if ((iGeraeteNo.length() != 3) || (iGeraeteNo == cGERAET)) {
            // erst mal die Gerätenummer eingeben!
            setContentView(viewSettings);
            viewSettings_geraeteNo.requestFocus();
            return;
        }

        Thread checkUpdate = new Thread() {
            public void run() {

                try {

                    int fatalErrors = 0;

                    while (true) {

                        URL ur = new URL(
                                /**/ urlPrefix() +
                                /**/ cUP +
                                /**/ cID +
                                /**/ iGeraeteNo + ";" +
                                /**/ iTAN + ";" +
                                /**/ VERSION + ";" +
                                /**/ iLokaleOptionen + iRemoteOptionen + ";" +
                                /**/ URLEncoder.encode(getTimestamp(), "UTF-8") + ";" +
                                /**/ iHandyId + ";" +
                                /**/ iSalt
                                );

                        // TAN anfordern
                        String newTAN = invoke(ur.toString());

                        if (newTAN.length() == 5) {

                            // OrgaMon hat eine neue TAN vergeben
                            if (Integer.parseInt(newTAN) < 10000) {

                                fatalErrors++;
                                iLastError = "1077:" + "Ungültige TAN '"
                                        + newTAN + "'"; /* LASTERROR */
                                break;
                            }

                        } else {

                            // OrgaMonServer will einen Fehler mitteilen.
                            fatalErrors++;
                            Log.e("no OK", newTAN);
                            iLastError = newTAN;
                            break;
                        }

                        if (!iGeraeteNo.equals("000")) {

                            //
                            // jetzt alle Eingaben senden!
                            // durchlaufe die Datenbank und schaue nach
                            // veränderten Datensätze, diese
                            // müssen hochgeladen werden!
                            //

                            SharedPreferences data = getSharedPreferences(iTAN,
                                    Context.MODE_PRIVATE);

                            String s;

                            for (int i = 0; i < iAnz; i++) {

                                s = data.getString(Integer.toString(i), "");
                                if (!s.startsWith(cFLAG_UNCHANGED)) {

                                    // Änderungen müssen gemeldet werden
                                    String[] col = s.split(cDELIMITER);
                                    if (col.length > COLUMN_EINGABE_UHR) {

                                        String line = col[COLUMN_RID] + ";"
                                                + col[COLUMN_ZAEHLER_KORR]
                                                + ";" + col[COLUMN_ZAEHLER_NEU]
                                                + ";"
                                                + col[COLUMN_ZAEHLER_STAND_NEU]
                                                + ";"
                                                + col[COLUMN_ZAEHLER_STAND_ALT]
                                                + ";" + col[COLUMN_REGLER_KORR]
                                                + ";" + col[COLUMN_REGLER_NEU]
                                                + ";" + col[COLUMN_PROTOKOLL]
                                                + ";"
                                                + col[COLUMN_EINGABE_DATUM]
                                                + ";" + col[COLUMN_EINGABE_UHR];

                                        // Versuche zu Melden
                                        ur = new URL(
                                                /**/urlPrefix() +
                                                /**/cUP +
                                                /**/cWEB_TAN + newTAN + "&" +
                                                /**/cWEB_DATA +
                                                /**/URLEncoder.encode(line, "UTF-8")
                                                /**/);

                                        String dataRESULT = invoke(ur
                                                .toString());
                                        if (!dataRESULT.equals("OK")) {
                                            fatalErrors++;
                                            iLastError = dataRESULT;
                                            break;
                                        }
                                    }
                                }
                            }

                            if (fatalErrors > 0) {
                                break;
                            }
                        }
                        // jetzt proceed machen!
                        ur = null;
                        ur = new URL(
                                /**/urlPrefix() +
                                /**/cUP + cPROCEED +
                                /**/newTAN);
                        String resultPROCEED = invoke(ur.toString());
                        if (!resultPROCEED.equals("OK")) {
                            iLastError = resultPROCEED;
                            break;
                        }

                        // jetzt den neuen Auftrag laden!
                        String resultRESOURCE = resource(newTAN);
                        if (!resultRESOURCE.equals("OK")) {
                            iLastError = resultRESOURCE;
                            break;
                        }

                        // alte Record-Stores löschen, somit Platz schaffen
                        if (!iTAN.equals(newTAN)) {
                            wipePref(iTAN);
                            wipePref(iTAN + cSEARCH_FLAG);
                        }

                        // Umschalten auf den neuen Auftrag
                        iTAN = newTAN;
                        iLastError = "ohne Fehler";
                        iStandTxt = getTimestamp();

                        break;
                    }
                } catch (Exception e) {
                    Log.d("senden", e.getMessage());
                }

                iView = VIEW_SETTINGS;
                saveSettings();
                reboot();

            }
        };

        // Run the Thread
        checkUpdate.start();
    }

    public String invoke(String params) {

        Log.d("invoke.request", params);
        try {

            URL url = new URL(params);
            HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
            urlConnection.setRequestProperty("Cookie", "pwd=" + iPwd);

            int responseCode = urlConnection.getResponseCode();

            // Imp pend: Check the response Code
            if (responseCode == HTTP_OK) {

                // Get the response
                BufferedReader rd =
                        new BufferedReader(
                                new InputStreamReader(urlConnection.getInputStream()));

                String line = "";
                int k, l;
                while ((line = rd.readLine()) != null) {
                    // Log.d("invoke.response", line);
                    l = line.indexOf("<BODY>");
                    if (l != -1) {
                        k = line.indexOf("</BODY>");
                        if (k > 4) {
                            line = line.substring(l + 6, k);
                            // Log.d("invoke.result", line);
                            return line;
                        }
                    }
                }

            } else {
                if (responseCode==HTTP_FORBIDDEN) {
                    return("das Passwort ist falsch");
                 } else {
                    return("HTTP Fehler-Code " + responseCode);
                }
            }

        } catch (Exception e) {
            Log.e(APP, "invoke", e);
            return e.toString();
        }
        return "";
    }

    public void execMe(String command) {

        //
        // execMe
        //
        // hier werden nach dem "senden" Befehle ausgeführt. Es ist
        // möglich Dateien zu verschieben, sowie Dateien zu löschen
        // und auch Systemparameter zu setzen.
        //
        // execMe wird im Rahmen der Protokoll-Speicherung ausgeführt
        // also einmal nach dem "Senden"
        //

        Log.i("execMe", command);
        try {
            String[] p = command.split("\\ ");

            while (true) {

                if (p[0].equals("mv")) {
                    File f = new File(p[1]);
                    File n = new File(p[2]);
                    if (!n.exists()) {
                        if (f.exists()) {
                            f.renameTo(n);
                            // Log Sucess!
                        } else {
                            Log.d("execMe", "ERROR: " + p[1]
                                    + " does not exists");
                        }

                    } else {
                        Log.d("execMe", "ERROR: " + p[2]
                                + " already there, delete first");
                    }
                    break;
                }

                if (p[0].equals("rm")) {
                    File f = new File(p[1]);
                    if (f.exists()) {
                        f.delete();
                        // Log Sucess!
                    } else {
                        Log.i("execMe", "WARNING: " + p[1] + " does not exists");
                    }
                    break;
                }

                if (p[0].equals("set")) {

                    if (p[1].equals("BARCODE_TYPE")) {
                        iBarcode = p[2];
                        break;
                    }

                    if (p[1].equals("AUTO_FOCUS")) {
                        iFocus = p[2];
                        break;
                    }

                    if (p[1].equals("AUTO_EXIT")) {
                        iAutoExit = p[2];
                        break;
                    }

                    if (p[1].equals("AUTO_SCAN")) {
                        iScan = p[2];
                        break;
                    }

                    Log.e("execMe", "ERROR: set: unknown parameter '" + p[1] + "'");
                    break;

                }

                Log.e("execMe", "ERROR: unknown command '" + p[0] + "'");
                break;
            }
        } catch (Exception e) {
            Log.e(APP, "execMe", e);
        }

    }

    public String resource(String newTAN) {

        URL url;
        try {

          url = new URL(
                        /**/ urlPrefix() +
                        /**/ newTAN + "." +
                        /**/ cAUFTRAG
                        /**/);

        } catch (Exception e) {
            Log.e(APP, "resource", e);
            return e.toString();
        }

        Log.d("resource.request", url.toString());
        try {

            HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();
            urlConnection.setRequestProperty("Cookie", "pwd=" + iPwd);

            // Get the response
            BufferedReader rd = new BufferedReader(new InputStreamReader(
                    urlConnection.getInputStream()));

            // Platz machen, es könnte ein vorhergehender Download
            // abgebrochen worden sein
            wipePref(newTAN);

            SharedPreferences prefs;
            Editor editor;
            boolean mainClose = true;
            try {
                prefs = this.getSharedPreferences(newTAN, Context.MODE_PRIVATE);
                editor = prefs.edit();
                Log.d("pref", newTAN);

            } catch (Exception e) {
                Log.e(APP, "wipeTAN", e);
                return e.toString();
            }

            //
            String line = "";
            String protokollName = newTAN;
            int i = 0;

            while ((line = rd.readLine()) != null) {

                if (line.length() > 0) {

                    // Log.d("resource.response", line);

                    // Switch auf einen anderen Pref-Namespace, da
                    // jetzt die Protokolle kommen

                    switch (line.charAt(0)) {

                        case ':':
                            // Begin a new Store
                            try {
                                Log.d("close", protokollName + "[" + i + "]");
                                editor.commit();
                                protokollName = line.substring(1);
                                if (mainClose) {
                                    mainClose = false;
                                    iAnz = i;
                                }

                                wipePref(protokollName);
                                Log.d("open", protokollName);

                                prefs = this.getSharedPreferences(protokollName,
                                        Context.MODE_PRIVATE);
                                editor = prefs.edit();
                                Log.d("pref", protokollName);
                                i = 0;

                            } catch (Exception e) {
                                Log.e(APP, "resource", e);
                                return e.toString();
                            }
                            break;
                        case '$':
                            // Execute a command
                            execMe(line.substring(1));
                            break;
                        default:

                            // Daten aufbereiten in den Recordstore speichern
                            // System.out.println(rsNewName + "<- " + str);
                            if (mainClose) {
                                if (line.length() > 2) {
                                    line = line.replace('|', '\n');
                                    editor.putString(Integer.toString(i++), line);
                                }
                            } else {
                                editor.putString(Integer.toString(i++), line);
                            }

                    }

                }

            }
            Log.d("close", protokollName + "[" + i + "]");
            editor.commit();
            if (mainClose) {
                mainClose = false;
                iAnz = i;
            }
            if (iIndex >= iAnz)
                iIndex = iAnz - 1;
            if (iAnz < 1) {
                iIndex = -1;
            } else {
                if (iIndex < 0) {
                    iIndex = 0;
                }
            }

        } catch (Exception e) {
            Log.e(APP, "resource", e);
            return e.toString();
        }
        return "OK";
    }
}