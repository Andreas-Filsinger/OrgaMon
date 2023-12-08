"use strict";

if ('serviceWorker' in navigator) {
                        var initializing = true;
                        var worker;
                        var postMessage = function (data) {
                                        console.log(data, navigator.serviceWorker);
                                        if (worker) {
                                                        return void worker.postMessage(data);               
                                        }
                                        console.log('NOT READY');
                        };
}
                        
navigator.serviceWorker.register('sw.js', ) 
  .then(function(reg) {
    console.log('Reg: '+ reg.scope);
                                                        
    reg.onupdatefound = function () {
                        if (initializing) {
                            var w = reg.installing;
                            var onStateChange = function () {
                                if (w.state === "activated") {
                                    console.log(w);
                                    worker = w;
                                    postMessage("INIT");
                                    w.removeEventListener("statechange", onStateChange);
                                }
                            };
                            w.addEventListener('statechange', onStateChange);
                            return;
             }
                        console.log('new SW version found!');
                        
                        // KILL EVERYTHING, but how?
                        
                    };
                                
                    // Here we add the event listener for receiving messages
                    navigator.serviceWorker.addEventListener('message', function (e) {
                        var data = e.data;
                        console.log('Incoming Msg from sw.js', data);
                        if (data && data.state === "READY") {
                            initializing = false;
                            postMessage(["GOOD SERVICE"]);
                            return;
                        }
                    });
                                
                    if (reg.active) {
                        worker = reg.active;
                        console.log('reg.active: send INIT');
                        postMessage("INIT");
                    }
                }).catch(function(error) {
                    console.log('Registration failed with ' + error);
                });
