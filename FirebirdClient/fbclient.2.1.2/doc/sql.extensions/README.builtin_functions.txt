=================
Builtin functions
=================

Builtin functions below (except DECODE) are used only if there is no
UDF declared with the same name.
This choice of UDF or system function is decided when compiling the
statement and isn't changed if the statement is stored (trigger / SP).

Authors:
    Adriano dos Santos Fernandes <adrianosf@uol.com.br>
    Oleg Loa <loa@mail.ru>
    Alexey Karyakin <aleksey.karyakin@mail.ru>


---
ABS
---

Function:
    Returns the absolute value of a number.

Format:
    ABS( <number> )

Example:
    select abs(amount) from transactions;


----
ACOS
----

Function:
    Returns the arc cosine of a number.

Format:
    ACOS( <number> )

Notes:
    Argument to ACOS must be in the range -1 to 1 and returns a value in
    the range 0 to PI.

Example:
    select acos(x) from y;


----------
ASCII_CHAR
----------

Function:
    Returns the ASCII character with the specified code.

Format:
    ASCII_CHAR( <number> )

Notes:
    Argument to ASCII_CHAR must be in the range 0 to 255 and returns a value
    with NONE character set.

Example:
    select ascii_char(x) from y;


---------
ASCII_VAL
---------

Function:
    Returns the ASCII code of the first character of the specified string.

Format:
    ASCII_VAL( <string> )

Notes:
    1) Returns 0 if the string is empty.
    2) Throws error if the first character is multi-byte.

Example:
    select ascii_val(x) from y;


----
ASIN
----

Function:
    Returns the arc sine of a number.

Format:
    ASIN( <number> )

Notes:
    Argument to ASIN must be in the range -1 to 1 and returns a value in
    the range -PI / 2 to PI / 2.

Example:
    select asin(x) from y;


----
ATAN
----

Function:
    Returns the arc tangent of a number.

Format:
    ATAN( <number> )

Notes:
    Returns a value in the range -PI / 2 to PI / 2.

Example:
    select atan(x) from y;


-----
ATAN2
-----

Function:
    Returns the arc tangent of the first number / the second number.

Format:
    ATAN( <number>, <number> )

Notes:
    Returns a value in the range -PI to PI.

Example:
    select atan2(x, y) from z;


-------
BIN_AND
-------

Function:
    Returns the result of a binary AND operation performed on all arguments.

Format:
    BIN_AND( <number> [, <number> ...] )

Example:
    select bin_and(flags, 1) from x;


------
BIN_OR
------

Function:
    Returns the result of a binary OR operation performed on all arguments.

Format:
    BIN_OR( <number> [, <number> ...] )

Example:
    select bin_or(flags1, flags2) from x;


-------
BIN_SHL
-------

Function:
    Returns the result of a binary shift left operation performed on the arguments (first << second).

Format:
    BIN_SHL( <number>, <number> )

Example:
    select bin_shl(flags1, 1) from x;


-------
BIN_SHR
-------

Function:
    Returns the result of a binary shift right operation performed on the arguments (first >> second).

Format:
    BIN_SHR( <number>, <number> )

Example:
    select bin_shr(flags1, 1) from x;


-------
BIN_XOR
-------

Function:
    Returns the result of a binary XOR operation performed on all arguments.

Format:
    BIN_XOR( <number> [, <number> ...] )

Example:
    select bin_xor(flags1, flags2) from x;


--------------
CEIL | CEILING
--------------

Function:
    Returns a value representing the smallest integer that is greater 
    than or equal to the input argument.

Format:
    { CEIL | CEILING }( <number> )

Example:
    1) select ceil(val) from x;
    2) select ceil(2.1), ceil(-2.1) from rdb$database;  -- returns 3, -2


---
COS
---

Function:
    Returns the cosine of a number.

Format:
    COS( <number> )

Notes:
    The angle is specified in radians and returns a value in the range -1 to 1.

Example:
    select cos(x) from y;


----
COSH
----

Function:
    Returns the hyperbolic cosine of a number.

Format:
    COSH( <number> )

Example:
    select cosh(x) from y;


---
COT
---

Function:
    Returns 1 / tan(argument).

Format:
    COT( <number> )

Example:
    select cot(x) from y;


-------
DATEADD
-------

Function:
    Returns a date/time/timestamp value increased (or decreased, when negative)
    by the specified amount of time.

Format:
    DATEADD( <number> <timestamp_part> TO <date_time> )
    DATEADD( <timestamp_part>, <number>, <date_time> )

    timestamp_part ::= { YEAR | MONTH | DAY | HOUR | MINUTE | SECOND | MILLISECOND }

Notes:
    1) YEAR, MONTH, DAY and WEEKDAY could not be used with time values.
    2) HOUR, MINUTE and SECOND could not be used with date values.
    3) All timestamp_part values could be used with timestamp values.

Example:
    select dateadd(-1 day for current_date) as yesterday
	    from rdb$database;


--------
DATEDIFF
--------

Function:
    Returns an exact numeric value representing the amount of time from the first
    date/time/timestamp value to the second one.

Format:
    DATEDIFF( <timestamp_part> FROM <date_time> TO <date_time> )
    DATEDIFF( <timestamp_part>, <date_time>, <date_time> )

Notes:
    1) Returns positive value if the second value is greater than the first one,
	   negative when the first one is greater or zero when they are equal.
    2) Comparison of date with time values is invalid.
    3) YEAR, MONTH, DAY and WEEKDAY could not be used with time values.
    4) HOUR, MINUTE and SECOND could not be used with date values.
    5) All timestamp_part values could be used with timestamp values.


------
DECODE
------

Function:
    DECODE is a shortcut to CASE ... WHEN ... ELSE expression.

Format:
    DECODE( <expression>, <search>, <result> [ , <search>, <result> ... ] [, <default> ]

Example:
	select decode(state, 0, 'deleted', 1, 'active', 'unknown') from things;


---
EXP
---

Function:
    Returns the exponential e to the argument.

Format:
    EXP( <number> )

Example:
    select exp(x) from y;


-----
FLOOR
-----

Function:
    Returns a value representing the largest integer that is less 
    than or equal to the input argument.

Format:
    FLOOR( <number> )

Example:
    1) select floor(val) from x;
    2) select floor(2.1), floor(-2.1) from rdb$database;  -- returns 2, -3


--------
GEN_UUID
--------

Function:
    Returns a universal unique number.

Format:
    GEN_UUID()

Example:
    insert into records (id) value (gen_uuid());


----
HASH
----

Function:
    Returns a HASH of a string.

Format:
    HASH( <string> )

Example:
    select hash(x) from y;


----
LEFT
----

Function:
    Returns the substring of a specified length that appears at the start of a string.

Format:
    LEFT( <string>, <number> )

Example:
    select left(name, char_length(name) - 10)
        from people
        where name like '% FERNANDES';


--
LN
--

Function:
    Returns the natural logarithm of a number.

Format:
    LN( <number> )

Example:
    select ln(x) from y;


---
LOG
---

Function:
    LOG(x, y) returns the logarithm base x of y.

Format:
    LOG( <number>, <number> )

Example:
    select log(x, 10) from y;


-----
LOG10
-----

Function:
    Returns the logarithm base ten of a number.

Format:
    LOG10( <number> )

Example:
    select log10(x) from y;


----
LPAD
----

Function:
    LPAD(string1, length, string2) appends string2 to the beginning of
    string1 until length of the result string becomes equal to length.

Format:
    LPAD( <string>, <number> [, <string> ] )

Notes:
    1) If the second string is omitted the default value is one space.
    2) The second string is truncated when the result string will
	   become larger than length.

Example:
    select lpad(x, 10) from y;


--------
MAXVALUE
--------

Function:
    Returns the maximum value of a list of values.

Format:
    MAXVALUE( <value> [, <value> ...] )

Example:
    select maxvalue(v1, v2, 10) from x;


--------
MINVALUE
--------

Function:
    Returns the minimun value of a list of values.

Format:
    MINVALUE( <value> [, <value> ...] )

Example:
    select minvalue(v1, v2, 10) from x;


---
MOD
---

Function:
    MOD(X, Y) returns the remainder part of the division of X by Y.

Format:
    MOD( <number>, <number> )

Example:
    select mod(x, 10) from y;


-------
OVERLAY
-------

Function:
    OVERLAY( <string1> PLACING <string2> FROM <start> [ FOR <length> ] ) returns
    string1 replacing the substring FROM start FOR length by string2.

Format:
    OVERLAY( <string> PLACING <string> FROM <number> [ FOR <number> ] )

Notes:
    1) If <length> is not specified, CHAR_LENGTH( <string2> ) is implied.
    2) The OVERLAY function is equivalent to:
           SUBSTRING(<string1>, 1 FOR <start> - 1) ||
           <string2> ||
           SUBSTRING(<string1>, <start> + <length>)


--
PI
--

Function:
    Returns the PI constant (3.1459...).

Format:
    PI()

Example:
    val = PI();


--------
POSITION
--------

Function:
    Returns the position of the first string inside the second string starting at
    an offset (or from the beginning when omitted).

Format:
    POSITION( <string> IN <string> )
    POSITION( <string>, <string> [, <number>] )

Example:
    select rdb$relation_name
        from rdb$relations
        where position('RDB$' IN rdb$relation_name) = 1;


-----
POWER
-----

Function:
    POWER(X, Y) returns X to the power of Y.

Format:
    POWER( <number>, <number> )

Example:
    select power(x, 10) from y;


----
RAND
----

Function:
    Returns a random number between 0 and 1.

Format:
    RAND()

Example:
    select * from x order by rand();


-------
REPLACE
-------

Function:
    REPLACE(searched, find, replacement) replaces all occurences of "find"
    in "searched" by "replacement".

Format:
    REPLACE( <string>, <string>, <string> )

Example:
    select replace(x, ' ', ',') from y;


-------
REVERSE
-------

Function:
    Returns a string in reverse order.

Format:
    REVERSE( <value> )

Notes:
    REVERSE is an useful function to index strings from right to left.

Example:
    create index people_email on people computed by (reverse(email));
    select * from people where reverse(email) starting with reverse('.br');


-----
RIGHT
-----

Function:
    Returns the substring of a specified length that appears at the end of a string.

Format:
    RIGHT( <string>, <number> )

Example:
    select right(rdb$relation_name, char_length(rdb$relation_name) - 4)
        from rdb$relations
        where rdb$relation_name like 'RDB$%';


-----
ROUND
-----

Function:
    Returns a number rounded to the specified scale.

Format:
    ROUND( <number> [, <number> ] )

Notes:
    If the scale (second parameter) is negative, the integer part of
    the value is rounded. Ex: ROUND(123.456, -1) returns 120.000.

Examples:
    select round(salary * 1.1, 0) from people;


----
RPAD
----

Function:
    RPAD(string1, length, string2) appends string2 to the end of
    string1 until length of the result string becomes equal to length.

Format:
    RPAD( <string>, <number> [, <string> ] )

Notes:
    1) If the second string is omitted the default value is one space.
    2) The second string is truncated when the result string will
	   become larger than length.

Example:
    select rpad(x, 10) from y;


----
SIGN
----

Function:
    Returns 1, 0, or -1 depending on whether the input value is positive, zero or 
    negative, respectively.

Format:
    SIGN( <number> )

Example:
    select sign(x) from y;


---
SIN
---

Function:
    Returns the sine of a number.

Format:
    SIN( <number> )

Notes:
    Argument to SIN must be specified in radians.

Example:
    select sin(x) from y;


----
SINH
----

Function:
    Returns the hyperbolic sine of a number.

Format:
    SINH( <number> )

Example:
    select sinh(x) from y;


----
SQRT
----

Function:
    Returns the square root of a number.

Format:
    SQRT( <number> )

Example:
    select sqrt(x) from y;


---
TAN
---

Function:
    Returns the tangent of a number.

Format:
    TAN( <number> )

Notes:
    Argument to TAN must be specified in radians.

Example:
    select tan(x) from y;


----
TANH
----

Function:
    Returns the hyperbolic tangent of a number.

Format:
    TANH( <number> )

Example:
    select tanh(x) from y;


-----
TRUNC
-----

Function:
    Returns the integral part (up to the specified scale) of a number.

Format:
    TRUNC( <number> [, <number> ] )

Notes:
    If the scale (second parameter) is negative, the integer part of
    the value is truncated. Ex: TRUNC(123.456, -1) returns 120.000.

Example:
    1) select trunc(x) from y;
    2) select trunc(-2.8), trunc(2.8) from rdb$database;  -- returns -2, 2
    3) select trunc(987.65, 1), trunc(987.65, -1) from rdb$database;  -- returns 987.60, 980.00
