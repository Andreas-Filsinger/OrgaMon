# TGPuttyLib
A shared library / DLL with Delphi and C++ bindings based on PuTTY, for Windows, macOS, and Linux.

The new TGPuttyLib SFTP Library is a DLL/.so/.dylib conversion of the psftp program from the well-known PuTTY suite by Simon Tatham.

It allows developers to transfer files with the highest possible transfer rates (over 100MB/sec). The rates are higher than with any other known library.

TGPuttyLib is based on PuTTY Release 0.80. Ready-to-use classes are currently available for C++, Delphi and Free Pascal.

The library is now available for Windows, macOS and Linux.

The compiled libraries can be found in the Win32/Win64/Linux (Compiled Libs)/macOS (Compiled Libs) folders. There is no difference between a Debug and Release version.

Compiled demos can be found in the Releases section, and on the project web site.

For more information, please visit the project web site: 
https://www.syncovery.com/tgputtylib

---------------------
DIRECTORIES AND FILES
---------------------

tgputtylib.pas         -   Delphi Unit interfacing with the DLL

tgputtysftp.pas        -   Delphi SFTP Client Class (recommended, but uses 8-bit strings)

tgputtysftpclient.pas  -   Delphi SFTP Client Component (not needed, see note at the end of this document)

ctgputtylib.cpp,h      -   C++ DLL bindings

tgputtylibcbclass.cpp,h    -  C++ Builder SFTP Client Class (using 8-bit strings)

tgputtycbsftpclient.cpp,h   -  C++ Builder Component (using UnicodeStrings)

tgputtylibvcclass.cpp,h   -  Visual C++ SFTP Client Class (using 8-bit strings)

---------------------

TGPuttyLib.dpk etc.    -   Delphi Package for SFTP Client Component

TGPuttyLibCPP.cbproj etc.  -  C++ Builder Package for SFTP Client Component

---------------------

DelphiSimpleDemos      -   Delphi Command Line Demos

DelphiVCLComponentDemo -   Fully working SFTP client application using the SFTP Client Component

DelphiVCLDemo          -   Fully working SFTP client application using the SFTP Client Class

FPCSimpleDemos         -   FPC Command Line Demos

CPPDemos               -   C++ Demos

---------------------

tgputtylib             -   DLL source code based on PuTTY

---------------------

bpl                    -   compiled Delphi Package for XE 10.3

Win32, Win64           -   compiled binaries for Windows

Linux (Compiled Libs)  -   compiled binaries for Linux (various CPU types)

macOS (Compiled Libs)  -   compiled binaries for macOS (Intel 32 and 64 bits)


---------------------

DELPHI RECOMMENDATION

Please consider just using the TTGPuttySFTP class in tgputtysftp.pas
rather than the TTGPuttySFTPClient component in tgputtysftpclient.pas.
Just include the folder with the Pascal source files in your compiler path.

The class has many advantages! You don't have to install anything into the IDE.
Much easier when you switch to a newer Delphi version in the future.

You can just create the class and assign properties in Delphi code, rather than using
the component.

Take a look at the DelphiVCLDemo example, rather than DelphiVCLComponentDemo.

Note that the TTGPuttySFTP class uses AnsiStrings, so you need to work with Utf8Encode and Utf8Decode or Utf8ToString.

The component, on the other hand, uses UnicodeStrings.

