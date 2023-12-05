var id;
var postMsg = function (client, data) {
    client.postMessage(data);
};

var broadcast = function (data, excludes) {
    // Loop over all available clients
    clients.matchAll().then(function (clients) {
        clients.forEach(function (client) {
            if (excludes.indexOf(client.id) === -1) {
                postMsg(client, data);
            }
        })
    })
};
var sendTo = function (data, clientId){
    clients.matchAll().then(function (clients) {
        clients.some(function (client) {
            if (client.id === clientId) {
                postMsg(client, data)
            }
        })
    })
};
var getClients = function () {
    clients.matchAll().then(function (clients) {
        var cl = clients.map(function (c) {
            console.log(JSON.stringify(c));
            return c.id;
        });
        console.log(cl);
    });
};

self.addEventListener('message', function (e) {
    console.log('>message ', e.data);
    var cId = e.source.id;
    if (e.data === "INIT") {
    console.log(e.data);
        if (!id) {
            id = Math.floor(Math.random()*100000);
            console.log(id);
        }
        broadcast(cId + ' has joined!', [cId]);
        postMsg(e.source, {state: 'READY'});
        postMsg(e.source, "Welcome to SW " + id + "!");
        postMsg(e.source, "You are identified as " + cId);
    } else {
        console.log(e.data);
        postMsg(e.source, 'Yo (Re: '+e.data+')');
    }
});
self.addEventListener('install', function (e) {
    console.log('>installing…');
    self.skipWaiting();
});

self.addEventListener('activate', function (e) {
    console.log('>activate');
});

