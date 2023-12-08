"use strict";
importScripts('./sqlite3.js');

let db;

self.addEventListener('install', e => {

  self.skipWaiting();

    console.log('>installing…');

console.log('Loading and initializing SQLite3 module...');


self
  .sqlite3InitModule()
  .then(function (sqlite3) {
  
    
    // Do we have SQLite3 Support?
    try {
      console.log('SQLite3 Rev. ',sqlite3.version.libVersion);
      
    } catch (e) {
      console.error('Exception:', e.message);
    }

    // open the Database 
    //const db = new sqlite3.oo1.DB('local:polyzalos.sqlite3?vfs=kvvs','ct');
    //const db = new sqlite3.oo1.DB(':localStorage:','ct');
    
    
    db = new sqlite3.oo1.DB(
{
   filename: "polyzalos.sqlite3",
   flags: "ct"
   
   }    
);


    console.log(db.selectValue('select count(*) from sqlite_master'))    ;
    //console.log("db.storageSize():",db.storageSize());
    
    // can we open the Table?
    if(0===db.selectValue('select count(*) from sqlite_master')){
      console.log('Database is empty');
      
      try{
        const saveSql = [];
        db.exec({
          sql: [
                "create table if not exists t(a);",
                "insert into t(a) values(?),(?),(?)"],
          bind: [performance.now() >> 0,
                 (performance.now() * 2) >> 0,
                 (performance.now() / 2) >> 0],
          saveSql
        });
        console.log("saveSql =",saveSql);
        console.log("DB (re)initialized.");
      }catch(e){
        console.error(e.message);
      }
      console.log(db.filename);
      //db.close();
      
      
    }  

    
  });
  
});

self.addEventListener('fetch', event => {
  
    console.log('>fetch');
    
    if (db) {

    if(0===db.selectValue('select count(*) from sqlite_master')){
      console.log('Database is empty');
    } else {
     console.log('Anzahl der Tabellen ',db.selectValue('select count(*) from sqlite_master')) ;
    }
    } else
    {
      console.log('Database not opened');
    }  
    
    event.respondWith(fetch(event.request));
});
