/*
    ___                  __  __
   / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  | |_| | | | (_| | (_| | |  | | (_) | | | |
   \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
             |___/
                                       
  Copyright (c) 2008 Christoph Thielecke
  Copyright (C) 2008 Martin Schmidt
  Copyright (C) 2007-2010 Andreas Filsinger
                                           
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
                                                          
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
                                                                          
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
                                                                                   
  http://orgamon.org/
         
*/


#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
	
// gwenhywfar
#include <gwenhywfar/cgui.h>
#include <gwenhywfar/gui_be.h>
#include <gwenhywfar/text.h>
#include <gwenhywfar/debug.h>
#include <gwenhywfar/version.h>

// aqbanking
#include <aqbanking/version.h>
#include <aqbanking/banking.h>
#include <aqbanking/jobgetbalance.h>
#include <aqbanking/jobgettransactions.h>
#include <aqbanking/jobsingledebitnote.h>

// C
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

// globale Variable
const char *currentVersion = "1.034";
const char *pin;
const char *blz;
const char *kto;
char *fileAusgabeFName;
char *csvName;	
int lineend=0;
int deamonMode=0;																																 

// AqBanking 
AB_BANKING *ab;
GWEN_GUI *gui;

void getCorrectFileNum()
{
	char path[500];
	char num[500];
	FILE * file;
	int i=1;
	
	//Überprüfen ob i.log.txt existiert, wenn nicht ist das das nächste file (i++)
	while(i)
	{
		sprintf(path, "logs/%i.log.txt", i);
		i++;
		if((file = fopen(path, "r")))
		{
			fclose(file);
		}
		else
		{
			sprintf(num, "%i", i-1);
			fileAusgabeFName = num;
			i=0;
		}
	};
}

void doc(const char *text, int x)
{
		FILE *logfile;
		char fileName[1024];
		time_t rawtime;
		struct tm * timeinfo;
		
		printf(text);

		//Erstellen des Files
		sprintf(fileName, "logs/%s.log.txt", fileAusgabeFName);
		logfile = fopen(fileName,"a");
		//Ausgabe auf Kommandozeile
		
		//Holen der Aktuellen Uhrzeit
		time ( &rawtime );
		timeinfo = localtime ( &rawtime );
		
		if (lineend)//Ausgabeder Uhrzeit, wenn das Flag lineend true ist
		{
			fprintf(logfile, "%2i:%2i:%2i\n", timeinfo->tm_hour, timeinfo->tm_min, timeinfo->tm_sec);
			lineend =0;
		}
		
		if (text[strlen(text)-1]=='\n') { //Überprüfen ob im letzten Text das letzte Zeichen \n war
			lineend=1; //Setzen des flags
		}

		//Ausgabe ins Logfile, und schließen
		fprintf(logfile, text);
		fclose(logfile);
		
		//Wenn das xFlag gesetzt ist, zusätzlich in eine csv-Datei schreiben
		if (x) {
			FILE *transactionfile;
			sprintf(fileName, "results/%s.%s.csv", fileAusgabeFName, csvName);
			transactionfile = fopen(fileName, "a");
			if (strcmp(text, "(null);")==0)
			{
				text = ";";
			}
			fprintf(transactionfile, text);
			fclose(transactionfile);
		}
}

void getVersion()
{
	//Liest die Aktuellen Versionen und schreibt sie Raus. 
	char buffer[1000];
	csvName = "Version";
	sprintf(buffer, "Modul;Version\r\naqbanking;%s\r\ngwenhywfar;%s\r\nabtest;%s\r\n", 
	AQBANKING_VERSION_FULL_STRING, GWENHYWFAR_VERSION_FULL_STRING, currentVersion);
	doc(buffer, 1);
} 

void usage() 
{
	//Bei eingabe von --help oder allem nicht auflösbaren
	printf("\naqbd -[U|L|B|S|D] BLZ KontoNummer PIN [Datum|\"Pfad\"]\n");
	printf("	-U Ausgabe der Umsaetze in eine Datei \n");
	printf("	-L Durchfuehren von Lastschriften\n");
	printf("	-B Speichern von Terminueberweisungen\n");
	printf("	-N Auflisten von Terminueberweisungen\n");
	printf("	-S Ausgabe von Salden\n");
	printf("	-D werde ein Daemon\n");
	printf("	-V Gibt die aktuelle Version aus\n");

}

int zMessageBox(GWEN_GUI *gui, uint32_t flags,  const char *title,  const char *text,  const char *b1,  const char *b2,  const char *b3,  uint32_t guiid)
{
	//Callback-funktion, die messages von aqbanking darstellt, und bei bedarf immer mit "JA" beantwortet
	doc("<message>", 0);
	doc(text, 0);
	doc("</message>\n", 0);
	flags = 0x1;
	return 0;
}
					  
int zProgressLog (GWEN_GUI *gui, uint32_t id, GWEN_LOGGER_LEVEL level, const char *text) {

char cHBCI[1024];

         if(strstr(text, "HBCI: ") == NULL){
         
	   //Zusaetzliche Statusinformationen werden hier ausgegeben (Callback)
	   doc("<log>", 0);
	   doc(text, 0);
	   doc("</log>\n", 0);
         } else  {

          // 
          sprintf(cHBCI,"INFO: %s\n",text);
          doc(cHBCI,0);

	}
	
	return 0;
}										 

int zPasswortFn(GWEN_GUI *gui, uint32_t flags, const char *token, const char *title, const char *text, char *buffer, int minLen, int maxLen, uint32_t guiid)
{	
	char tan [100];
	
	doc("<password>\n",0);
	doc(text,0);
	doc("\n</password>\n",0);
	
	//Wenn der Callback nach dem PIN Fragt, den inder Kommandozeile erhaltenen PIN zurückgeben
	if (flags & GWEN_GUI_INPUT_FLAGS_TAN) {

			//TanDaemon, wartet auf das tan-File
			if(deamonMode==1)
			{
				FILE *tanreq;
				char fileName[1050];
				char path[1050];
				
				FILE *tanFile;
				char c;
				int i=0;
				int l=0;
				int size;
				
				tan[0]=0;
				//Tanforderug rausschreinben!!
				sprintf(fileName, "results/%s.tan-anfrage.txt", fileAusgabeFName);
				tanreq = fopen(fileName,"w");
				fprintf(tanreq, text);
				fclose(tanreq);

				sprintf(fileName, "jobs/%s.tan", fileAusgabeFName);
				
				//Auf das TAN-File vom client warten
				while (1) {

				  doc("Waiting for TAN-file '", 0);
				  doc(fileName, 0);
				  doc("' ...\n", 0);
				  
				if((tanFile = fopen(fileName, "r"))) {

						//Lesen des inhalts
						fseek(tanFile , 0 , SEEK_END);
						size = ftell(tanFile);
						rewind(tanFile);
						do//Auslesen
						{
							c = fgetc(tanFile);
							tan[i]=c;
							i++;
						}
						while(i<size);
						tan[i]=0;
						fclose(tanFile);
						
						//Verschieben der benutzten TAN
						sprintf(path, "results/%s.used.tan", fileAusgabeFName);
						rename(fileName, path);
						break;
				}
				else {
					
                                          sleep(1);//Eine Sekunde warten....
				}
					l++;
                                        if (l==240) {
                                          doc("TAN-Zeitueberschreitung\n", 0);
                                          return 2; 
				        }
					
				}

				strcpy(buffer, tan);
				doc("benutzte TAN: ", 0);
				doc(tan, 0);
				doc("\n", 0);
			}
			else//Manuelle TAN-Eingabe über die Kommandozeile
			{
				doc("TAN-Eingabe: \n> ", 0);
				fscanf(stdin, "%s", tan);
				strcpy(buffer, tan);
				doc("\n", 0);
			}
	} 
	else {
		strcpy(buffer, pin);
	}

	return(0);
}



int zCheckCert (GWEN_GUI *gui, const GWEN_SSLCERTDESCR *cd, GWEN_SYNCIO *sio, uint32_t guiid) {
/*
    prueft den Zertifikats-Staus, Rueckgabewerte
  
    0   Alles OK 
    1   Es gab Fehler
    2   Es gibt kein Vergleichszertifikat, es wurde eben angelegt
*/
	const char *hash;
	const char *status;
	const char *ipAddr;
	
	FILE *savCert;
	char cert [5000]; // Abgelegtes Zertifikat
	char buffer [5000]; // Aktuelles zertifikat

	char path [500];
	char c;
	int size=0;
	int l=0;
	int statusOK=0;
	FILE *hashfile;
	
	char varName[128];
	char dbuffer1[32];
	char dbuffer2[32];
	const GWEN_TIME *ti;
	const char *unknown;
	const char *commonName;
	const char *organizationName;
	const char *organizationalUnitName;
	const char *countryName;
	const char *localityName;
	const char *stateOrProvinceName;

	//char *msg="The following certificate has been received:\nName        : %s\nOrganisation: %s\nDepartment  : %s\nCountry     : %s\nCity        : %s\nState       : %s\nValid after : %s\nValid until : %s\nHash        : %s\nStatus      : %s\nDo you wish to accept this certificate?\n";
	char *msg="Organisation: %s\nDepartment  : %s\nCountry     : %s\nCity        : %s\nState       : %s\nValid after : %s\nValid until : %s\nHash        : %s\n";
	
	//Callback zur Ausgabe und verifizierung des empfangenen Zertifikates
	
	doc("\n<certificate>", 0);
	memset(dbuffer1, 0, sizeof(dbuffer1));
	memset(dbuffer2, 0, sizeof(dbuffer2));
	memset(varName, 0, sizeof(varName));

	hash=GWEN_SslCertDescr_GetFingerPrint(cd);
	if (GWEN_SslCertDescr_GetStatusFlags(cd) & GWEN_SSL_CERT_FLAGS_OK) {
         statusOK=1;	 
	}
	status=GWEN_SslCertDescr_GetStatusText(cd);
	ipAddr=GWEN_SslCertDescr_GetIpAddress(cd);

	ti=GWEN_SslCertDescr_GetNotBefore(cd);
	if (ti) 
	{
		GWEN_BUFFER *tbuf;
		tbuf=GWEN_Buffer_new(0, 32, 0, 1);
		if (GWEN_Time_toString(ti, "YYYY/MM/DD hh:mm:ss", tbuf)) 
		{
			DBG_ERROR(GWEN_LOGDOMAIN,"zCheckCert: Could not convert beforeDate to string");
			abort();
		}
		strncpy(dbuffer1, GWEN_Buffer_GetStart(tbuf), sizeof(dbuffer1)-1);
		GWEN_Buffer_free(tbuf);
	}

	ti=GWEN_SslCertDescr_GetNotAfter(cd);
	if (ti) 
	{
		GWEN_BUFFER *tbuf;

		tbuf=GWEN_Buffer_new(0, 32, 0, 1);
		if (GWEN_Time_toString(ti, "YYYY/MM/DD hh:mm:ss", tbuf)) 
		{
			DBG_ERROR(GWEN_LOGDOMAIN,"zCheckCert: Could not convert untilDate to string");
			abort();
		}
		strncpy(dbuffer2, GWEN_Buffer_GetStart(tbuf), sizeof(dbuffer2)-1);
		GWEN_Buffer_free(tbuf);
	}

	unknown="unknown";
	commonName=GWEN_SslCertDescr_GetCommonName(cd);
	if (!commonName)
	{
		commonName=unknown;
	}
	organizationName=GWEN_SslCertDescr_GetOrganizationName(cd);
	if (!organizationName)
	{
		organizationName=unknown;
	}
	organizationalUnitName=GWEN_SslCertDescr_GetOrganizationalUnitName(cd);
	if (!organizationalUnitName)
	{
		organizationalUnitName=unknown;
	}
	countryName=GWEN_SslCertDescr_GetCountryName(cd);
	if (!countryName)
	{
		countryName=unknown;
	}
	localityName=GWEN_SslCertDescr_GetLocalityName(cd);
	if (!localityName)
	{
		localityName=unknown;
	}
	stateOrProvinceName=GWEN_SslCertDescr_GetStateOrProvinceName(cd);
	if (!stateOrProvinceName)
	{
		stateOrProvinceName=unknown;
	}
	if (!status)
	{
		status=unknown;
	}
	
	
	sprintf(buffer,msg, organizationName, organizationalUnitName, countryName, localityName, stateOrProvinceName, dbuffer1, dbuffer2, hash);
	doc (buffer, 0);
	doc ("</certificate>\n", 0);
	

        // Empfangenes Zertifikat speichern!!
	//sprintf(path, "cert.%s.%s.tmp", blz, kto);
	sprintf(path, "%s.tmp", commonName);
	savCert = fopen(path, "w");
	fprintf(savCert, buffer);
	fclose(savCert);
	
	
	// immer ignorieren?
	sprintf(path, "%s.ignore", commonName);
	if((hashfile = fopen(path, "r"))) {
	
         // Informieren, falls das Zertifikat eigentlich nicht gueltig ist
         if (!statusOK) {
	   char failure [200];
	   sprintf(failure, "WARNING: Problematischer Zertifikatstatus: %s\n", status );
	   doc(failure, 0);
         }
	
	
           doc("The Certificate is ignored and accepted!\n", 0);
           return 0;
	}

	//empfangenes Zertifikat auf gültigkeit prüfen (The certificate is valid)
	if (!statusOK) {
		char failure [200];
		sprintf(failure, "ERROR: Problematischer Zertifikatstatus: %s!\n", status );
		doc(failure, 0);
		return -1;
	}
	
	
	
	// altes gespeichertes Zertifikat mit empfangenen Zertifikat vergleichen!!
	//sprintf(path, "cert.%s.%s.txt", blz, kto);
	sprintf(path, "%s.txt", commonName);
	if((hashfile = fopen(path, "r")))
	{
		fseek(hashfile , 0 , SEEK_END);
		size = ftell(hashfile);
		rewind(hashfile);
		do
		{
			c = fgetc(hashfile);
			cert[l]=c;
			l++;
		}
		while((l<size)&&(l<5000));
		cert[l] =0;
		fclose(hashfile);
	
		if(strcmp(buffer, cert)==0)
		{
			doc("The Certificate is identical and accepted!\n", 0);
			return 0;
		}
		else
		{
			sprintf(path, "cert.%s.%s.tmp", blz, kto);
			doc("Stimmt nicht mit den gespeicherten Zertifikat ueberein!!\n", 0);
			doc("Ueberpruefen Sie den Inhalt von ", 0);
			doc(path,0);
			doc("\n", 0);
			doc("ERROR: Das Vergleichs-Zertifikat sieht aber anders aus!\n", 0);
			return -1;
		}
	}
	else {
		
                // Das Zertifikat stillschweigend akzetieren, da wir beim initialen
                // Zugriff nicht von einer Zertifikatsfaelschung ausgehen
		sprintf(path, "%s.txt", commonName);
		savCert = fopen(path, "w");
		fprintf(savCert, buffer);
		fclose(savCert);
		doc("WARNING: Ein Vergleichs-Zertifikat lag bisher nicht vor!\n",0);
		return 0;
	}
}

int AB_create() {

	int rv=0;
	char buffer[1024];

	//Initialisierungen GWEN
	GWEN_Logger_SetLevel(0, GWEN_LoggerLevel_Verbous);
	gui=GWEN_Gui_CGui_new();
	GWEN_Gui_SetGui(gui);

	// Initialisierungen AB
	ab=AB_Banking_new("aqbd", 0, AB_BANKING_EXTENSION_NONE);
	rv=AB_Banking_Init(ab);
	if (rv) {
		sprintf(buffer,"ERROR: AB_Banking_Init == %d\n", rv);
		doc(buffer, 0);
		return 2;
	}
	rv=AB_Banking_OnlineInit(ab);
	if (rv) {
		sprintf(buffer,"ERROR: AB_Banking_OnlineInit == %d\n", rv);
		doc(buffer, 0);
		return 2;
	}
	
	//Setzen der Call-backs::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	GWEN_Gui_SetProgressLogFn(gui,zProgressLog);
	GWEN_Gui_SetGetPasswordFn(gui, zPasswortFn);
	GWEN_Gui_SetCheckCertFn(gui, zCheckCert);
	GWEN_Gui_SetMessageBoxFn(gui, zMessageBox);

	return 0;

}

int AB_free() {

	int rv=0;
	char buffer[1024];

	rv=AB_Banking_OnlineFini(ab);
	if (rv) 
	{
		sprintf(buffer, "ERROR: Error on deinit online modules (%d)!\n", rv);
		doc(buffer, 0);
		return 3;
	}

	rv=AB_Banking_Fini(ab);
	if (rv) 
	{
		sprintf(buffer, "ERROR: Error on deinit (%d)!\n", rv);
		doc(buffer, 0);
		return 3;
	}

	AB_Banking_free(ab);
	return 0;

}



int umsaetze(AB_BANKING *ab, const char *date)
{

	int rv;
	int ErrorCount;
	char buffer [5000];
	AB_ACCOUNT *a;
	AB_JOB_LIST2 *jl;
	AB_JOB *j;
	AB_IMEXPORTER_CONTEXT *ctx;
	AB_IMEXPORTER_ACCOUNTINFO *ai;
	
	//Initialisierungen
	ctx=AB_ImExporterContext_new();
	jl=AB_Job_List2_new();
	csvName = "Umsatz";
	
	//Transaktionsteil
	a=AB_Banking_GetAccountByCodeAndNumber(ab, blz, kto);
	if(!a)
	{
		doc("ERROR: Kombination BLZ KTO# ist unbekannt!\n", 0);
		return 1;
	}

	j=AB_JobGetTransactions_new(a);
	if(date)
	{
		AB_JobGetTransactions_SetFromTime(j, GWEN_Time_fromString(date, "DD.MM.YYYY"));
	}

	rv=AB_Job_CheckAvailability(j);
	if (rv)
	{
		sprintf(buffer, "ERROR: Job ist nicht verfuegbar (%d)!\n", rv);
		doc(buffer, 0);
		return 2;
	}
	//Job zur liste hinzufgen
	AB_Job_List2_PushBack(jl, j);
	//Jobs ausfuehren!
	rv=AB_Banking_ExecuteJobs(ab, jl, ctx);	
	if (rv) 
	{
		sprintf(buffer, "ERROR: Ausfuehrung misslungen (%d)!\n", rv);
		doc(buffer, 0);
		return 3;
	}
	
        ErrorCount=0;
	
	//Erstellen der .csv-Datei
	doc("\n<transactions>", 0);
	//erste Zeile im CSV-File
	doc("PosNo;Datum;Valuta;Betrag;Waehrung;Typ;VorgangID;VorgangText;PrimaNota;VonBLZ;VonKonto;VonREF;VonName1;VonName2;Buchungstext1;Buchungstext2;Buchungstext3;Buchungstext4;Buchungstext5;Buchungstext6;Buchungstext7\r\n", 1);
	
	ai=AB_ImExporterContext_GetFirstAccountInfo(ctx); //AccountInfo herausziehen
        if (ai) {
          int i=1;
          const AB_TRANSACTION *t;
          t=AB_ImExporterAccountInfo_GetFirstTransaction(ai);
          while(t) {
		const AB_VALUE *v;
		const char *purpose1;
		const char *purpose2;
		const char *purpose3;
		const char *purpose4;
		const char *purpose5;
		const char *purpose6;
		const char *purpose7;
		const char *vonREF;
		const char *from1;
		const char *from2;
		char betrag [21];
		char date [32];
		char valutaDate [32];
		int j=0;
		const GWEN_TIME *ti;
		const GWEN_STRINGLIST *sl;

		//Getting Time
		ti = AB_Transaction_GetDate(t);
		if (ti) 
		{
			GWEN_BUFFER *tbuf;
			tbuf = GWEN_Buffer_new(0, 32, 0, 1);
			rv = GWEN_Time_toString(ti, "DD.MM.YYYY", tbuf);
			if (rv) 
			{
				strcpy(date, "Convert Error");
			}
			strncpy(date, GWEN_Buffer_GetStart(tbuf), sizeof(date)-1);
			GWEN_Buffer_free(tbuf);
		}
		else
		{
			strcpy(date, "date=nil");
		}

		ti = AB_Transaction_GetValutaDate(t);
		if(ti)
		{
			GWEN_BUFFER *tbuf;
			tbuf=GWEN_Buffer_new(0, 32, 0, 1);
			rv = GWEN_Time_toString(ti, "DD.MM.YYYY", tbuf);
			strncpy(valutaDate, GWEN_Buffer_GetStart(tbuf), sizeof(valutaDate)-1);
			GWEN_Buffer_free(tbuf);
		}
		else
		{
			strcpy(valutaDate,"valutaDate=nil");
		}
		//Weitere Vorbereitungen

		v = AB_Transaction_GetValue(t);
		sprintf(betrag, "%.2lf", AB_Value_GetValueAsDouble(v));
		while ((betrag[j]!='.') && (j<20)&& (betrag[j]))
		{
			j++;
		}
		if (betrag[j] == '.')
		{
			betrag[j] = ',';//Dezimalkomma
		}
		sl = AB_Transaction_GetPurpose(t);
		purpose1 = GWEN_StringList_StringAt(sl,0);
		purpose2 = GWEN_StringList_StringAt(sl,1);
		purpose3 = GWEN_StringList_StringAt(sl,2);
		purpose4 = GWEN_StringList_StringAt(sl,3);
		purpose5 = GWEN_StringList_StringAt(sl,4);
		purpose6 = GWEN_StringList_StringAt(sl,5);
		purpose7 = GWEN_StringList_StringAt(sl,6);
		sl = AB_Transaction_GetRemoteName(t);
		from1 = GWEN_StringList_StringAt(sl,0);
		from2 = GWEN_StringList_StringAt(sl,1);
		vonREF = AB_Transaction_GetCustomerReference(t);
		
		if(vonREF==0)
		{
			vonREF="NONREF";
		}
		
		//Ausgaben in die CSV-Datei
		sprintf(buffer, "%i;", i);											doc(buffer,1);
		sprintf(buffer, "%s;", date);										doc(buffer,1);
		sprintf(buffer, "%s;", valutaDate);									doc(buffer,1);
		sprintf(buffer, "%s;", betrag);										doc(buffer,1);
		sprintf(buffer, "%s;", AB_Value_GetCurrency(v));					doc(buffer,1);
		sprintf(buffer, "N%s;", AB_Transaction_GetTransactionKey(t));		doc(buffer,1);
		sprintf(buffer, "%i;", AB_Transaction_GetTransactionCode(t));	doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetTransactionText(t));	doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetPrimanota(t));		doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetRemoteBankCode(t));		doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetRemoteAccountNumber(t));	doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetCustomerReference(t));		doc(buffer,1);
		sprintf(buffer, "%s;", from1);										doc(buffer,1);
		sprintf(buffer, "%s;", from2);										doc(buffer,1);
		sprintf(buffer, "%s;", purpose1);									doc(buffer,1);
		sprintf(buffer, "%s;", purpose2);									doc(buffer,1);
		sprintf(buffer, "%s;", purpose3);									doc(buffer,1);
		sprintf(buffer, "%s;", purpose4);									doc(buffer,1);
		sprintf(buffer, "%s;", purpose5);									doc(buffer,1);
		sprintf(buffer, "%s;", purpose6);									doc(buffer,1);
		sprintf(buffer, "%s;", purpose7);									doc(buffer,1);
		doc("\r\n", 1);
		i++;

		t=AB_ImExporterAccountInfo_GetNextTransaction(ai);
	  } /* while transactions */
         } /* if ai */
        else {
         ErrorCount++;
         doc("WARNING: Keine Umsaetze!\n",0);
        }
	doc("</transactions>", 0);
	
	//Freigaben
	if (jl) {
	 AB_Job_List2_free(jl);
	}
	if (ctx) {
  	 AB_ImExporterContext_free(ctx);
 	}
	return ErrorCount;
}

 
int vorgemerkte(AB_BANKING *ab, const char *date)
{

	int rv;
	char buffer [5000];
	AB_ACCOUNT *a;
	AB_JOB_LIST2 *jl;
	AB_JOB *j;
	AB_IMEXPORTER_CONTEXT *ctx;
	AB_IMEXPORTER_ACCOUNTINFO *ai;
	int i=1;
	int si;
	const AB_TRANSACTION *t;
	
	//Initialisierungen
	ctx=AB_ImExporterContext_new();
	jl=AB_Job_List2_new();
	csvName = "vorgemerkterUmsatz";
	
	//Transaktionsteil
	a=AB_Banking_GetAccountByCodeAndNumber(ab, blz, kto);
	if(!a)
	{
		doc("ERROR: Kombination BLZ KTO# ist unbekannt!\n", 0);
		return 1;
	}

	j=AB_JobGetTransactions_new(a);
	if(date)
	{
		AB_JobGetTransactions_SetFromTime(j, GWEN_Time_fromString(date, "DD.MM.YYYY"));
	}

	rv=AB_Job_CheckAvailability(j);
	if (rv)
	{
		sprintf(buffer, "ERROR: Job is not available (%d)\n", rv);
		doc(buffer, 0);
		return 2;
	}
	//Job zur liste hinzufgen
	AB_Job_List2_PushBack(jl, j);
	//Jobs ausfuehren!
	rv=AB_Banking_ExecuteJobs(ab, jl, ctx);	
	if (rv) 
	{
		sprintf(buffer, "ERROR: ExecuteJobs misslungen (%d)!\n", rv);
		doc(buffer, 0);
		return 3;
	}
	
	
	//Erstellen der .csv-Datei
	doc("\n<notedtransactions>", 0);
	//erste Zeile im CSV-File
	doc("PosNo;Datum;Valuta;Betrag;Waehrung;Typ;VorgangID;VorgangText;PrimaNota;VonBLZ;VonKonto;VonREF;VonName1;VonName2;Buchungstext1;Buchungstext2;Buchungstext3;Buchungstext4;Buchungstext5;Buchungstext6;Buchungstext7\r\n", 1);
	
	ai=AB_ImExporterContext_GetFirstAccountInfo(ctx);//AccountInfo herausziehen
	t=AB_ImExporterAccountInfo_GetFirstNotedTransaction(ai);
	while(t)// für jede Transaktion = jeden Datensatz
	{
		const AB_VALUE *v;
		const char *purpose1;
		const char *purpose2;
		const char *purpose3;
		const char *purpose4;
		const char *purpose5;
		const char *purpose6;
		const char *purpose7;
		const char *vonREF;
		const char *from1;
		const char *from2;
		char betrag [21];
		char date [32];
		char valutaDate [32];
		const GWEN_TIME *ti;
		const GWEN_STRINGLIST *sl;

		//Getting Time
		ti = AB_Transaction_GetDate(t);
		if (ti) 
		{
			GWEN_BUFFER *tbuf;
			tbuf = GWEN_Buffer_new(0, 32, 0, 1);
			rv = GWEN_Time_toString(ti, "DD.MM.YYYY", tbuf);
			if (rv) 
			{
				strcpy(date, "Convert Error");
			}
			strncpy(date, GWEN_Buffer_GetStart(tbuf), sizeof(date)-1);
			GWEN_Buffer_free(tbuf);
		}
		else
		{
			strcpy(date, "date=nil");
		}

		ti = AB_Transaction_GetValutaDate(t);
		if(ti)
		{
			GWEN_BUFFER *tbuf;
			tbuf=GWEN_Buffer_new(0, 32, 0, 1);
			rv = GWEN_Time_toString(ti, "DD.MM.YYYY", tbuf);
			strncpy(valutaDate, GWEN_Buffer_GetStart(tbuf), sizeof(valutaDate)-1);
			GWEN_Buffer_free(tbuf);
		}
		else
		{
			strcpy(valutaDate,"valutaDate=nil");
		}
		//Weitere Vorbereitungen

		// Betrag 
		v = AB_Transaction_GetValue(t);
		sprintf(betrag, "%.2lf", AB_Value_GetValueAsDouble(v));
                si = 0;
		while ((betrag[si]!='.') && (si<20)&& (betrag[si])) {
			si++;
		}
		if (betrag[si] == '.') {
			betrag[si] = ',';//Dezimalkomma
		}
		
		sl = AB_Transaction_GetPurpose(t);
		purpose1 = GWEN_StringList_StringAt(sl,0);
		purpose2 = GWEN_StringList_StringAt(sl,1);
		purpose3 = GWEN_StringList_StringAt(sl,2);
		purpose4 = GWEN_StringList_StringAt(sl,3);
		purpose5 = GWEN_StringList_StringAt(sl,4);
		purpose6 = GWEN_StringList_StringAt(sl,5);
		purpose7 = GWEN_StringList_StringAt(sl,6);
		sl = AB_Transaction_GetRemoteName(t);
		from1 = GWEN_StringList_StringAt(sl,0);
		from2 = GWEN_StringList_StringAt(sl,1);
		vonREF = AB_Transaction_GetCustomerReference(t);
		
		if(vonREF==0) {
			vonREF="NONREF";
		}
		
		//Ausgaben in die CSV-Datei
		sprintf(buffer, "%i;", i);		doc(buffer,1);
		sprintf(buffer, "%s;", date);		doc(buffer,1);
		sprintf(buffer, "%s;", valutaDate);	doc(buffer,1);
		sprintf(buffer, "%s;", betrag);		doc(buffer,1);
		sprintf(buffer, "%s;", AB_Value_GetCurrency(v));			doc(buffer,1);
		sprintf(buffer, "N%s;", AB_Transaction_GetTransactionKey(t));		doc(buffer,1);
		sprintf(buffer, "%i;", AB_Transaction_GetTextKey(t));			doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetTransactionText(t));		doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetPrimanota(t));			doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetRemoteBankCode(t));		doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetRemoteAccountNumber(t));	doc(buffer,1);
		sprintf(buffer, "%s;", AB_Transaction_GetCustomerReference(t));		doc(buffer,1);
		sprintf(buffer, "%s;", from1);						doc(buffer,1);
		sprintf(buffer, "%s;", from2);						doc(buffer,1);
		sprintf(buffer, "%s;", purpose1);					doc(buffer,1);
		sprintf(buffer, "%s;", purpose2);					doc(buffer,1);
		sprintf(buffer, "%s;", purpose3);					doc(buffer,1);
		sprintf(buffer, "%s;", purpose4);					doc(buffer,1);
		sprintf(buffer, "%s;", purpose5);					doc(buffer,1);
		sprintf(buffer, "%s;", purpose6);					doc(buffer,1);
		sprintf(buffer, "%s;", purpose7);					doc(buffer,1);
		doc("\r\n", 1);
		i++;

		t=AB_ImExporterAccountInfo_GetNextNotedTransaction(ai);
	} /* while transactions */
	doc("</notedtransactions>", 0);
	
	//Freigaben
	AB_Job_List2_free(jl);
	AB_ImExporterContext_free(ctx);
	return 0;
}

int lastschrift( AB_BANKING *ab, const char *path )
{
	char buffer[5000];
	AB_TRANSACTION *t=0;
	AB_ACCOUNT *a;
	AB_JOB_LIST2 *jl=0;
	AB_IMEXPORTER_CONTEXT *ctx=0;
	AB_JOB *job=0;
        AB_USER *u=0;
	GWEN_STRINGLIST *sl=0;
	GWEN_STRINGLIST *sl2=0;
	FILE *LASTCSV;
	
	long size =0; //Laenge der Datei
	char c=0; //Zeichenpuffer

    // Spalten aus der CSV, ACHTUNG: unter Umstaenden Multibyte-Strings
	char name[100+1];
	char fblz[100+1];
	char fkto[100+1];
	char betrag[100+1];
	char vz1[100+1];
	char vz2[100+1];
	char vz3[100+1];
	char vz4[100+1];
	char vz5[100+1];
	char vz6[100+1];
	char vz7[100+1];
	char parameter[100+1];

	int i=0;//Position im buffer
	int rv=0;

	int l=0;//position in der Datei
	int spalte=0;
	int iLineCount=0;
	
	//Konto suchen
	a = AB_Banking_GetAccountByCodeAndNumber(ab, blz, kto);
	if(!a){
		doc("ERROR: Kombination 'BLZ Kontonummer' nicht gefunden!\n", 0);
		return 2;
	}
        u = AB_Account_GetFirstUser( a );					
	
        sprintf(buffer,"INFO: Konto Bezeichnung (userName) ist \"%s\"!\n",AB_User_GetUserName(u));
        doc(buffer,0);

	//Die csv-datei mit den Lastschriftdatensätzen suchen und auslesen
	if((LASTCSV = fopen(path, "r")))
	{
		fseek(LASTCSV , 0 , SEEK_END);
		size = ftell(LASTCSV);
		rewind(LASTCSV);
		
		ctx=AB_ImExporterContext_new();
		jl=AB_Job_List2_new();
		
		while(l<size)
		{

			iLineCount++;

                        // lese eine Zeile!
			spalte=0;
	 name[0]=0;
	 fblz[0]=0;
	 fkto[0]=0;
	 betrag[0]=0;
	 vz1[0]=0;
	 vz2[0]=0;
	 vz3[0]=0;
	 vz4[0]=0;
	 vz5[0]=0;
	 vz6[0]=0;
	 vz7[0]=0;
			while (l<size) {

                                // eine Zelle aufbauen!
				i=0;
				while (l<size) {

					c = fgetc(LASTCSV);
					l++;

					if ((c != '"')&&(c != '\r')&&(c != '\n')&&(c != ';')&&(i<100)) //Die ungeliebten anfuehrungszeichen entfernen
					{
						parameter[i]=c;
						i++;
					}
					
					if ((c==';')||(c=='\n'))
					 break;
				};
				parameter[i]=0;
				
				switch(spalte)
				{
					case 0: /*RID*/	break;
					case 1: /*Name*/  strcpy(name, parameter); break;
					case 2: /*Ort*/	break;
					case 3: /*BLZ*/   strcpy(fblz, parameter); break;
					case 4: /*Konto*/  strcpy(fkto, parameter); break;
					case 5: /*Betrag*/ strcpy(betrag, parameter); break;
					case 6: /*VZ1*/   strcpy(vz1, parameter);	 break;
					case 7: /*VZ2*/   strcpy(vz2, parameter); break;
					case 8: /*VZ3*/   strcpy(vz3, parameter); break;
					case 9: /*VZ4*/   strcpy(vz4, parameter); break;
					case 10: /*VZ5*/  strcpy(vz5, parameter); break; // optional
					case 11: /*VZ6*/  strcpy(vz6, parameter); break; // optional
					case 12: /*VZ7*/  strcpy(vz7, parameter); break; // optional
				}
				spalte++;
				
				if (c=='\n') 
				 break;
			}
			
			if (spalte>=10) {

				if(iLineCount>1) //Kopfzeile verwerfen
				{
					// Aus dem Komma ein Punkt machen! 
					i=0;
					while (betrag[i]!=',' && i<100)	{
						i++;
					}
					if (betrag[i]==',') {
 						betrag[i] = '.';//Dezimalpunkt!!
					}
					
					// einen Job erstellen
					job = AB_JobSingleDebitNote_new(a);
					rv = AB_Job_CheckAvailability(job);
					if(rv) {
					
					        doc("ERROR: Job \"SingleDebiNote\" ist nicht erlaubt!\n",0);
						return 2;
					}
					
					t = AB_Transaction_new();

					// Local Settings
					AB_Transaction_SetLocalBankCode(t, blz);
					AB_Transaction_SetLocalAccountNumber(t, kto);
					AB_Transaction_SetLocalName(t, AB_User_GetUserName(u));

					// Remote Settings
					AB_Transaction_SetRemoteBankCode(t, fblz);
					AB_Transaction_SetRemoteAccountNumber(t, fkto);
					AB_Transaction_SetValue(t, AB_Value_fromString(betrag));

					sl2 = GWEN_StringList_new();
					GWEN_StringList_AppendString(sl2, name, 1, 0);
					AB_Transaction_SetRemoteName(t, sl2);

					sl = GWEN_StringList_new();
					GWEN_StringList_AppendString(sl, vz1, 1, 0);
					GWEN_StringList_AppendString(sl, vz2, 1, 0);
					GWEN_StringList_AppendString(sl, vz3, 1, 0);
					GWEN_StringList_AppendString(sl, vz4, 1, 0);
					GWEN_StringList_AppendString(sl, vz5, 1, 0);
					GWEN_StringList_AppendString(sl, vz6, 1, 0);
					GWEN_StringList_AppendString(sl, vz7, 1, 0);
					AB_Transaction_SetPurpose(t, sl);

					AB_JobSingleDebitNote_SetTransaction(job, t);
					AB_Job_List2_PushBack(jl, job);//Job zur liste hinzufgen
					AB_Transaction_free(t);
				
					//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				}
			}
			else
			{
				sprintf(buffer,"ERROR: in Zeile %i: zumindest 10 Spalten erwartet!\n", iLineCount);
				doc(buffer,0);
				
			}
		}
		fclose(LASTCSV);
		
		sprintf(buffer,"%d Lastschriftauftraege\n",AB_Job_List2_GetSize(jl));
		doc(buffer,0 );
		
		//Alle Datensätze gelesen und in jobs geparst
		rv=AB_Banking_ExecuteJobs(ab, jl, ctx);//Jobs ausfuehren!
		if (rv) 
		{
			sprintf(buffer, "ERROR: AB_Banking_ExecuteJobs : %d\n", rv);
			doc(buffer, 0);

			//Verschieben der lastschrift CSV nach "error"...
			sprintf(buffer, "error/%s.csv", fileAusgabeFName);
			rename(path, buffer);
			return 3;
		}
		else
		{

			//Verschieben der lastschrift CSV nach "results"...
			sprintf(buffer, "results/%s.csv", fileAusgabeFName);
			rename(path, buffer);
		}
	}
	else
	{
           sprintf(buffer, "ERROR: Lastschrift-Datei '%s' nicht gefunden!\n", path);   
           doc(buffer, 0);
	   return 2;
	}
		
	//Aufraeumen
	AB_Job_List2_free(jl);
	AB_ImExporterContext_free(ctx);
	return 0;
}

int saldo(AB_BANKING *ab)
{

	char buffer[5000];
	const AB_VALUE *v =0;
	int rv=0;
	int j=0;
	char betrag[21];
	
	
	const AB_ACCOUNT_STATUS * status;
	const AB_BALANCE * bal;
	AB_ACCOUNT *a=0;
	AB_JOB_LIST2 *jl=0;
	AB_IMEXPORTER_CONTEXT *ctx=0;
	AB_IMEXPORTER_ACCOUNTINFO *ai;
	AB_JOB *job=0;
	AB_USER *u=0;

	//Inits
	csvName = "Saldo";
	ctx=AB_ImExporterContext_new();
	jl=AB_Job_List2_new();
	
	//Konto suchen
	a = AB_Banking_GetAccountByCodeAndNumber(ab, blz, kto);
	if(!a) {
		sprintf(buffer,"ERROR: Bitte BLZ (%s) und KTO (%s) ueberpruefen!\n",blz,kto);
		doc(buffer, 0);
		return 2;
	}
	u = AB_Account_GetFirstUser( a );					

        sprintf(buffer,"INFO: Konto Bezeichnung (userName) ist \"%s\"!\n",AB_User_GetUserName(u));
        doc(buffer,0);
	
	//Job erzeugen und ausführen
	job = AB_JobGetBalance_new(a);
	AB_Job_List2_PushBack(jl, job);
	rv=AB_Banking_ExecuteJobs(ab, jl, ctx);//Jobs ausfuehren!
	if (rv) 
	{
		sprintf(buffer, "ERROR: on executeQueue (%d)\n", rv);
		doc(buffer, 0);
		return 3;
	}
	
	//Verarbeitung
	ai = AB_ImExporterContext_GetFirstAccountInfo (ctx);
	status = AB_ImExporterAccountInfo_GetFirstAccountStatus (ai);
	bal = AB_AccountStatus_GetBookedBalance (status);
	v = AB_Balance_GetValue (bal);
	sprintf(betrag, "%.2lf;%s\r\n", AB_Value_GetValueAsDouble(v), AB_Value_GetCurrency(v));
    j=0;
	while (betrag[j]!='.' && j<20){
		j++;
	}
	if (betrag[j]=='.')	{
		betrag[j] = ',';//Dezimalkomma
	}
	
	//Ausgabe
	doc("==BALANCE==\n", 0);
	doc("Betrag;Waehrung\r\n", 1);
	doc(betrag, 1);
	doc("==BALANCE==\n", 0);
	
	//Freeing 
	AB_Job_List2_free(jl);
	AB_ImExporterContext_free(ctx);
	
    return 0;
}

int proceed(int argc, char **argv)
{
	int rv;
	int retn=0;
	const char *date;
	char path[5000];

	//Import der Parameter::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	do {
		if (strcmp(argv[1], "-U")==0||strcmp(argv[1], "-u")==0)	{
			//Umsaetze sollen abgerufen werden!
			doc( "Umsaetze:\n", 0);
			if (argc<5) {
				usage();
				retn=2;
			}
			else
			{
				date = 0;
				blz = argv[2];
				kto = argv[3];
				pin = argv[4];
				if (argv[5]) {
					date = argv[5];
				}

				while (1) {

				  rv = AB_create();
				  if (rv) {
					retn=rv;
					break;
				  }
				
				  rv = umsaetze(ab, date);
				  if(rv) {
					retn=rv;
					break;
				  }
				  
				  rv = AB_free();
				  if(rv) {
					retn=rv;
					break;
				  }
				  break;
				  
				  
				}
            }
            break;
		}

		if (strcmp(argv[1], "-L")==0||strcmp(argv[1], "-l")==0) {
				doc("Lastschrift:\n", 0);
				if(argc<6)
				{
					usage();
					retn=2;
				}
				else
				{
					blz = argv[2];
					kto = argv[3];
					pin = argv[4];
					sprintf(path, "jobs/%s", argv[5]);
				while (1) {

				  rv = AB_create();
				  if (rv) {
					retn=rv;
					break;
				  }
				
					rv = lastschrift(ab, path);
					if(rv)
					{
						retn=rv;
						break;
					}
				  rv = AB_free();
				  if(rv) {
					retn=rv;
					break;
				  }
				  break;
				  
				  
				}
				}
				break;
		}

		if(strcmp(argv[1], "-S")==0||strcmp(argv[1], "-s")==0)
		{
					
			doc( "Saldo:\n", 0);
			if(argc!=5)
			{
				usage();
				retn=2;
			}
			else
			{
				date = 0;
				blz = argv[2];
				kto = argv[3];
				pin = argv[4];
				while (1) {

				  rv = AB_create();
				  if (rv) {
					retn=rv;
					break;
				  }
				
				rv = saldo(ab);
				if(rv)
				{
					retn= rv;
					break;
				}
				  rv = AB_free();
				  if(rv) {
					retn=rv;
					break;
				  }
				  break;
				  
				  
				}
			}
			break;
		}
		
		if(strcmp(argv[1], "-N")==0||strcmp(argv[1], "-n")==0)//Auf ersten Parameter Ueberpruefen!
		{
			//Umsaetze sollen abgerufen werden!
			doc( "Vorgemerkte:\n", 0);
			if(argc<5)
			{
                usage();
				retn= 2;
			}
			else
			{
				date = 0;
				blz = argv[2];
				kto = argv[3];
				pin = argv[4];
				if(argv[5])
				{
					date = argv[5];
				}
				while (1) {

				  rv = AB_create();
				  if (rv) {
					retn=rv;
					break;
				  }
				
				rv = vorgemerkte(ab, date);
				if(rv)
				{
					retn=rv;
					break;
				}
				  rv = AB_free();
				  if(rv) {
					retn=rv;
					break;
				  }
				  break;
				  
				  
				}
            		}
            		break;
 		}
 
		if(strcmp(argv[1], "-V")==0||strcmp(argv[1], "-v")==0)
		{
					
			doc( "Versionen:\n", 0);
			if(argc!=2)
			{
				usage();
				retn=2;
			}
			else
			{
				getVersion();
			}
			break;
		}
		usage();
		
	} while (0);
	

  if (retn!=0) { 
   doc("ERROR: proceed ging schief\n", 0); 
  }
  return retn;
}

int deamon()
{
    int iWarteCount=0;
	FILE *jobFile;
	DIR *logDir; 
	char fileNumBuffer[1030];
	char *argv[10];
	char buffer[5000];
	char jobFileName[200];
	char c;
	struct dirent *entry; 
	int i=0;
	int l=0;
	int size;
	int argc=1;
	int rv=0;


	//Sucht in einer Schleife nach job-Files und startet die proceed
	while(1) {
		
		//Lesen und erkennen von JobFiles!!
		jobFileName[0]=0;
		logDir = opendir("jobs");
                while (1) {
			entry = readdir(logDir); 
			if (entry) { 
				if (strstr(entry->d_name,".job")) {
					sprintf(jobFileName, "%s", entry->d_name);
				}
			} 
			else {
				break;
			}
		}  
		closedir(logDir);
		
		if (jobFileName[0]!=0) {
		
                        if (iWarteCount>0) {		
                                  			 printf("Nach %03d:%02d:%02d h Schlaf wegen %s aufgewacht\n", iWarteCount / 3600,	(iWarteCount / 60) % 60, iWarteCount % 60, jobFileName);
                                             iWarteCount=0;
                        }
			
			//nur den numerischen "JOB-ID" suchen...
			i=0;
			while((jobFileName[i]) && (jobFileName[i] != '.'))
			{
				fileNumBuffer[i] = jobFileName[i];
				i++;
			}
			fileNumBuffer[i]=0;
			fileAusgabeFName = fileNumBuffer;
			
			// JobFileName soll ab sofort den vollen Pfad beinhalten
			sprintf(buffer,"jobs/%s",jobFileName);
			sprintf(jobFileName,"%s",buffer);
			
			printf("open %s ...\n",jobFileName);
			
			//lesen des inhalts und trennen in Argumente
			jobFile = fopen(jobFileName, "r");
			fseek(jobFile , 0 , SEEK_END);
			size = ftell(jobFile);
			rewind(jobFile);
			i=0;
			l=0;
			argv[0] = "/srv/aqb";
			argc=1;
			while(l<size) {
				do {
					c = fgetc(jobFile);
					if(c!='"') {
                 				buffer[i]=c;
						i++;
					}
					l++;
				} while((c != ' ')&&(l<size)&&(c!='\r')&&(c!='\n'));
					
				if((c==' ')||(c=='\n')||(c=='\r')) {
					buffer[i-1]=0;
				}
				else {
					buffer[i]=0;
				}
				i=0;
				argv[argc] = (char*)malloc(strlen(buffer)+1);
				strcpy(argv[argc], buffer);
				argc++;
			}
			fclose(jobFile);
			argv[argc]=0;
			
			rv = proceed(argc, argv);
			
			//Proceed durchgearbeitet
			if(rv==0)//Erfolg!!
			{
				//Jobfile verschieben in results
				sprintf(buffer, "results/%s.job", fileAusgabeFName);
				rename(jobFileName, buffer);
				doc("File moved to ", 0);
				doc(buffer, 0);
				doc("\n", 0);
				
			}
			else//Misserfolg!!!
			{
			 	//Jobfile verschieben in error
			 	sprintf(buffer, "error/%s.job", fileAusgabeFName);
			 	doc("File moved to ", 0);
			 	doc(buffer, 0);
			 	doc("\n", 0);
			 	rename(jobFileName, buffer);
				
			}

                        // Speicher freigeben
			i=1;
			while(argv[i]) {
				free(argv[i]);
				argv[i]=0;
				i++;
			}
		}
		else//Kein JOB-File gefunden!
		{
			if (iWarteCount==0) {
				sprintf(buffer,"Schlafe ein ...\n");
				printf(buffer);
			}
			
			sleep(1);
			iWarteCount++;
		}
	}
	return 0;
}

int main(int argc, char **argv) 
{
	int rv=0;

	printf("aqbd Rev. %s (",currentVersion);
	printf("gwenhywfar Rev. %s", GWENHYWFAR_VERSION_FULL_STRING );
	printf(" / aqbanking Rev. %s", AQBANKING_VERSION_FULL_STRING );
	printf(")\n");

	//Alle Aufgaben werden in der proceed erledigt, da eine doppelte initialisierung der AB_Banking verhindert werden muss.
	//Nur der Daemon muss in dieser funktion angesprungen werden, ohne ein AB_Banking zu initialisieren, da dies für jeden Job seperat erledigt wird!!
	fileAusgabeFName = "std";
	if (argc < 2) {
         usage();
	} 
	else {



		if(strcmp(argv[1], "-D")==0||strcmp(argv[1], "-d")==0)	{
			
			if (argc!=2) {
				usage();
				return 2;
			}
			else {
				//Erstellen der Verzeichnisse
				if (chdir("/srv/aqb/")==0) 
				{
					// Lese Verzeichnisse
					mkdir("logs", ALLPERMS );
					chmod("logs/", 0755);
					mkdir("results", ALLPERMS );
					chmod("results/", 0755);
					mkdir("error", ALLPERMS );
					chmod("error/", 0755);

					// Job-Verzeichnis
					mkdir("jobs", ALLPERMS );
					chmod("jobs/", 0777);
					
	                        	
					deamonMode=1;
					rv = deamon(); //kommt nicht vor...
					if(rv){
						return rv;
					}
				} 
				else {
					printf("ERROR: Pfad /srv/aqb existiert nicht!\n");
					return 2;
				}
			}
			
		}
		
		else
		{
			if (chdir("/srv/aqb/")==0) 
			{
				// Lese Verzeichnisse
				mkdir("logs", ALLPERMS );
				chmod("logs/", 0755);
				mkdir("results", ALLPERMS );
				chmod("results/", 0755);
				mkdir("error", ALLPERMS );
				chmod("error/", 0755);
							
				getCorrectFileNum();//Bei Kommandozeilenbenutzung ergebnisse und logs von 1 ab durchnummerieren
				return proceed(argc, argv);
			} 
			else 
			{
				printf("ERROR: Pfad /srv/aqb existiert nicht!\n");
				return 2;
			}
		}
		
	}
	return 0;
}