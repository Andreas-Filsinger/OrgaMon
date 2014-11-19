<?php
/*
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012  Andreas Filsinger
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

define("SEQUENCE_HOST", "localhost");
define("SEQUENCE_NAMESPACE", ".69VVTGKZ1");
define("SEQUENCE_NAME", "sequence");

// globales MemCache-Object, hält während der ganzen
// Laufzeit des Scriptes eine Verbindung zum Memcache
// Server offen
$m_spc = null;

// Zuletzt gelesener Stand vom MemCache-Zähler
// kann inzwischen höher sein.
// -MaxInt .. -1 = MemCache ist offline
// 0 = MemCache wurde bisher nicht abgefragt
// 1 .. MaxInt = normale Increments 
$c_spc = 0;


// Stellt sicher, dass entweder
// * die Verbindung zum MemCache besteht
// * c_spc = -1, das bedeutet der Server läuft nicht
function semiEnsureOpen() {

    global $m_spc;
    global $c_spc;
    global $errorlist;

    // Init?
    if ($m_spc == null) {
        $m_spc = new Memcache();
        if ($m_spc->pconnect(SEQUENCE_HOST)) {
            $m_spc->add(SEQUENCE_NAME . SEQUENCE_NAMESPACE, 0);
        } else {
            $c_spc = -1;
            $errorlist->add("memcache: Verbindung zu " . SEQUENCE_HOST . " fehlgeschlagen!");
        }
    }
}

// liefert einfach die nächste Nummer eines
// Zählers, der den "semi"-"persistent" ist,
// das heisst er lebt länger als das Skript
// erst durch einen Server-Neustart wird dessen
// Wert auf "0" gesetzt. In einer Multi-User
// Umgebung (wie durch das Internet massiv
// gegeben) kann so ein fairer Zähler implementiert
// werden.
function getSemiPersistentSequence() {

    global $m_spc;
    global $c_spc;

    // Init?
    semiEnsureOpen();

    // Increment!
    if ($c_spc < 0)
        $c_spc += -1;
    else
        $c_spc = $m_spc->increment(SEQUENCE_NAME . SEQUENCE_NAMESPACE, 1);

    // Return
    return $c_spc;
}

//
// gibt nicht den aktuellen Zählerstand 
// zurück, sondern den letzten, der durch dieses
// Skript bisher abgefragt wurde.
function lastSemiPersistentSequence() {

    global $c_spc;

    return $c_spc;
}

//
// Ist ein gewisser $key im Semi-Persistent
// Speicher bekannt?
function semiPersistentIsKnown($key) {

    global $m_spc;
    global $c_spc;

    semiEnsureOpen();
    if ($c_spc >= 0)
        return ($m_spc->get($key . SEQUENCE_NAMESPACE) != false);
    else
        return false;
}

// Einen Key für eine gewisse Zeit speichern,
// iN dieser Zeit liefert dann semiPersistenIsKnown
// true
function semiPersistentBrand($key, $releaseTime) {

    global $m_spc;
    global $c_spc;

    semiEnsureOpen();
    if ($c_spc >= 0)
        $m_spc->add($key . SEQUENCE_NAMESPACE, "true", 0, $releaseTime);
}

?>