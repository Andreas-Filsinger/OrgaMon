
FreePascal HTTP2 Server 
(in a early alpha-State)

http://wiki.orgamon.org/index.php5/OrgaMon-next#HTTP.2F2_Server


what it can do

* Open a TLS 1.2 Server Socket
* read the "ServerName" the client expects to talk to
* make clear to use the "h2" protocol and nothing else
* Consume incoming Clients FRAMEs from a Firefox-Browser or a Chrome-Browser
* HPACK decode
* Send a first SETTINGS-FRAME
* Decode the first HEADERS Request from the Client

what it can not do

* really Server a Connection
* encode a HEADERS Frame
* HPACK encode
* send Content

what i am working on

* getting friends who can help
