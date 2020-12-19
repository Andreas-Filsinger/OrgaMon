/*

   ______   ___   _  ____
  / ___\ \ / / \ | |/ ___|
  \___ \\ V /|  \| | |
   ___) || | | |\  | |___
  |____/ |_| |_| \_|\____|

  (c) Michael Hack Software e.K.


* SYNC ist System zur Replikation einzelner Tabellen zwischen der lokalen OrgaMon- Datenbank und einem Remote Webshop mit einer MariaDB Datenhaltung.
* es besteht aus Datenbank- Feldern mit der Bezeichnung "SYNC" in der OrgaMon- Datenbank und PHP- Scripten, die der Remote Webshop aufruft

Bedeutung der ~TABELLE~.SYNC Werte (SmallInt) auf OrgaMon Seite:

 NULL  ? 
 -2    ?
 -1    DO_NOT_CHANGE, ein Flag das die Datenbank anweist diesen Update Vorgang als nicht relevant für die Synchronisation zu betrachten
 0     ?
 1     ?
 
*/ 