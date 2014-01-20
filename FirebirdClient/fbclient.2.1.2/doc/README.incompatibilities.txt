********************************************************************************
  LIST OF KNOWN INCOMPATIBILITIES
  between versions 2.0 and 2.1
********************************************************************************

This document describes all the changes that make v2.1 incompatible in any way
as compared with the previous release and hence could affect your databases and
applications.

Please read the below descriptions carefully before upgrading your software to
the new Firebird version.

INSTALLATION/CONFIGURATION
--------------------------

  * The database migration process has changed. If your databases contain text
    blobs with non-ASCII data inside, then the backup/restore cycle is not
    enough. Please pay attention to the files in the /misc/upgrade/metadata
    directory of your installation.

  * Parameter CreateInternalWindow of firebird.conf is deprecated. You no longer
    need to disable it if you need to run multiple FB instances simultaneously.

SECURITY
--------------------------

  * On Windows, the default authentication mode is "Mixed" which allows domain
    users to attach databases without knowing the Firebird login/password. Also,
    privileged OS users (those included into Local Admins / Domain Admins groups)
    would be treated as SYSDBA. If you consider this insecure for your setup,
    change parameter Authentication in firebird.conf.

SQL SYNTAX
--------------------------

  * A number of new reserved keywords are introduced. The full list is available
    here: /doc/sql.extentions/README.keywords. Please ensure your DSQL
    statements and procedure/trigger sources don't contain those keywords as
    identifiers. Otherwise, you'll need to either use them quoted (in Dialect 3
    only) or rename them.

SQL EXECUTION RESULTS
--------------------------

  * Malformed UTF8 strings and blobs are no longer allowed. Also, in order to
    have the metadata stored in the database properly (i.e. in UTF8), please
    make sure that DDL statements are encoded into the connection charset.
    Mixed usage of the NONE and other charsets is not recommended and may lead
    to unexpected runtime errors.

PERFORMANCE
--------------------------

  * Some queries may no longer use indices in this version. This covers cases
    where an indexed field and an argument have different datatypes and the
    implicit conversion cannot be performed consistently. Prior versions could
    return wrong results in these cases. A common example is: STR_FIELD = INT_ARG.
    As a numeric can be converted to a string in different ways, the indexed scan
    is not allowed for this predicate anymore. However, the opposite example:
    INT_FIELD = STR_ARG is allowed for the index scanning, because the conversion
    is deterministic.

  * Some date/time expressions in Dialect 1 cannot benefit from available indices
    either, e.g.: DATE_FIELD > 'NOW' + 1. A workaround is to use CAST or
    specify the explicit datatype prefix: TIMESTAMP 'NOW' + 1. This issue is
    expected to be resolved in the first point release.
