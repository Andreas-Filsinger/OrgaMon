s/\([[:alnum:]]*\)[[:space:]]*:[[:space:]]*\([[:alnum:]]\)/\1: \2/
s/longint/Longint/gi
s/dword/DWORD/gi
s/(\* Const before type ignored \*)//g
s/{ C++ end of extern C conditionnal removed }//g
s/^[[:space:]]*Const/const/gi
s/[[:space:]]*pointer/ Pointer/gi
s/[[:space:]]pvoid/ Pointer/gi
s/ to:/ aTo:/g
s/;cdecl;/; cdecl;/gi
s/;external/; external/gi
s/external;/external UNKNOWN_SO;/gi
s/\^xmlChar/PxmlChar/g
s/\^char/PChar/g
s/ file:/ aFile:/gi
s/:\([[:alnum:]]\)/: \1/g
s/ _type:/ aType:/g
s/ PFILE/ PLibXml2File/g
s/var [[:space:]]*\([[:alnum:]]*\):[[:space:]]*TextFile/\1: PLibXml2File/g
s/{\$define /{\$DEFINE /gi
s/{\$ifdef /{\$IFDEF /gi
s/{\$ifndef /{\$IFNDEF /gi
s/{\$else/{\$ELSE/gi
s/{\$endif/{\$ENDIF/gi
s/{\$if /{\$IF /gi
s/{\$ifend/{\$IFEND/gi
s:/\*:(\*:g
s:\*/:\*):g
s/[[:space:]]*$//
s:^{.*PACKRECORDS.*$::
s:^{$:(\*:
s/^\([[:space:]]*\)[[:space:]]}$/\1\*)/
s/[[:space:]]*{\$include .*}$//gi
# prefix content of comments with ' *'
/^(\*$/,/^ \*)/{s/^   / * /;s/^$/ */;}
# remove header's global ifdef construct
s/^[[:space:]]*{\$ifndef[[:space:]]*__.*__[[:space:]]*}$//i
s/^[[:space:]]*{\$define[[:space:]]*__.*__[[:space:]]*}$//i
s/^[[:space:]]*{[[:space:]]*__.*__[[:space:]]*}$//i
# try to make indent=2
s/^   \([^ ]\)/  \1/
#
s/\(=.*\);.*: array of const\();.*$\)/\1\2  {\$IFDEF HAS_TVA} varargs; {\$ENDIF}/
s/\(.*\);.*: array of const\();.*$\)/\1\2  {\$IFDEF HAS_VA} varargs; {\$ENDIF}/
#
s:^[[:space:]]*_\(.*\)[[:space:]]*=[[:space:]]*\1;$:  \1 = record end;:
s:^[[:space:]]*\(.*\)Ptr[[:space:]]*=[[:space:]]*\1;$:  \1Ptr = \^\1;:
#
# WHEN ALL IS DONE, REMOVE BLANK LINES:
/^[[:space:]]*$/d
