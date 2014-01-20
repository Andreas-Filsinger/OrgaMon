-----------------
Monitoring tables
-----------------

  Function:
    Allow to monitor server-side activity happening inside a particular database.

  Concept:    
    The engine offers a set of so called "virtual" tables that provides the user
    with a snapshot of the current activity within the given database. The word
    "virtual" means that the table data doesn't exist until explicitly asked for.
    However, its metadata is stable and can be retrieved from the schema. Virtual
    monitoring tables exist only in ODS 11.1 (and higher) databases, so a
    migration via backup/restore is required in order to use this feature.

    The key term of the monitoring feature is an activity snapshot. It represents
    the current state of the database, consisting of various information about
    the database itself, active attachments and users, transactions, prepared and
    running statements, etc. A snapshot is created the first time any of the
    monitoring tables is being selected from in the given transaction and it's
    preserved until the transaction ends, so multiple queries (e.g. master-detail
    ones) will always return the consistent view of the data. In other words, the
    monitoring tables always behave like a snapshot (aka consistency) transaction,
    even if the host transaction has been started with another isolation level.
    To refresh the snapshot, the current transaction should be finished and the
    monitoring tables should be queried in the new transaction context. Creation
    of a snapshot is usually quite fast operation, but some delay should be
    expected under high load (especially in the Classic Server). 

    A valid database connection is required in order to retrieve the monitoring
    data. The monitoring tables return information about the attached database
    only. If multiple databases are being accessed on the server, each of them
    has to be connected to and monitored separately.

    System variables CURRENT_CONNECTION and CURRENT_TRANSACTION could be used
    to select data about the current (for the caller) connection and transaction
    respectively. These variables correspond to the ID columns of the appropriate
    monitoring tables.

  Security:
    Complete database monitoring is available to SYSDBA and a database owner.
    Regular users are restricted to the information about their own attachments
    only (other attachments are invisible for them).

  Author:
    Dmitry Yemanov <dimitr at firebirdsql dot org>

  Scope:
    DSQL and PSQL

  Metadata:
    MON$DATABASE (connected database)
      - MON$DATABASE_NAME (database pathname or alias)
      - MON$PAGE_SIZE (page size)
      - MON$ODS_MAJOR (major ODS version)
      - MON$ODS_MINOR (minor ODS version)
      - MON$OLDEST_TRANSACTION (OIT number)
      - MON$OLDEST_ACTIVE (OAT number)
      - MON$OLDEST_SNAPSHOT (OST number)
      - MON$NEXT_TRANSACTION (next transaction number)
      - MON$PAGE_BUFFERS (number of pages allocated in the cache)
      - MON$SQL_DIALECT (SQL dialect of the database)
      - MON$SHUTDOWN_MODE (current shutdown mode)
          0: online
          1: multi-user shutdown
          2: single-user shutdown
          3: full shutdown
      - MON$SWEEP_INTERVAL (sweep interval)
      - MON$READ_ONLY (read-only flag)
      - MON$FORCED_WRITES (sync writes flag)
      - MON$RESERVE_SPACE (reserve space flag)
      - MON$CREATION_DATE (creation date/time)
      - MON$PAGES (number of pages allocated on disk)
      - MON$BACKUP_STATE (current physical backup state)
          0: normal
          1: stalled
          2: merge
      - MON$STAT_ID (statistics ID)

    MON$ATTACHMENTS (connected attachments)
      - MON$ATTACHMENT_ID (attachment ID)
      - MON$SERVER_PID (server process ID)
      - MON$STATE (attachment state)
          0: idle
          1: active
      - MON$ATTACHMENT_NAME (connection string)
      - MON$USER (user name)
      - MON$ROLE (role name)
      - MON$REMOTE_PROTOCOL (remote protocol name)
      - MON$REMOTE_ADDRESS (remote address)
      - MON$REMOTE_PID (remote client process ID)
      - MON$REMOTE_PROCESS (remote client process pathname)
      - MON$CHARACTER_SET_ID (attachment character set)
      - MON$TIMESTAMP (connection date/time)
      - MON$GARBAGE_COLLECTION (garbage collection flag)
      - MON$STAT_ID (statistics ID)

    MON$TRANSACTIONS (started transactions)
      - MON$TRANSACTION_ID (transaction ID)
      - MON$ATTACHMENT_ID (attachment ID)
      - MON$STATE (transaction state)
          0: idle
          1: active
      - MON$TIMESTAMP (transaction start date/time)
      - MON$TOP_TRANSACTION (top transaction)
      - MON$OLDEST_TRANSACTION (local OIT number)
      - MON$OLDEST_ACTIVE (local OAT number)
      - MON$ISOLATION_MODE (isolation mode)
          0: consistency
          1: concurrency
          2: read committed record version
          3: read committed no record version
      - MON$LOCK_TIMEOUT (lock timeout)
          -1: infinite wait
          0: no wait
          N: timeout N
      - MON$READ_ONLY (read-only flag)
      - MON$AUTO_COMMIT (auto-commit flag)
      - MON$AUTO_UNDO (auto-undo flag)
      - MON$STAT_ID (statistics ID)

    MON$STATEMENTS (prepared statements)
      - MON$STATEMENT_ID (statement ID)
      - MON$ATTACHMENT_ID (attachment ID)
      - MON$TRANSACTION_ID (transaction ID)
      - MON$STATE (statement state)
          0: idle
          1: active
      - MON$TIMESTAMP (statement start date/time)
      - MON$SQL_TEXT (statement text, if appropriate)
      - MON$STAT_ID (statistics ID)

    MON$CALL_STACK (call stack of active PSQL requests)
      - MON$CALL_ID (call ID)
      - MON$STATEMENT_ID (top-level DSQL statement ID)
      - MON$CALLER_ID (caller request ID)
      - MON$OBJECT_NAME (PSQL object name)
      - MON$OBJECT_TYPE (PSQL object type)
      - MON$TIMESTAMP (request start date/time)
      - MON$SOURCE_LINE (SQL source line number)
      - MON$SOURCE_COLUMN (SQL source column number)
      - MON$STAT_ID (statistics ID)

    MON$IO_STATS (I/O statistics)
      - MON$STAT_ID (statistics ID)
      - MON$STAT_GROUP (statistics group)
          0: database
          1: attachment
          2: transaction
          3: statement
          4: call
      - MON$PAGE_READS (number of page reads)
      - MON$PAGE_WRITES (number of page writes)
      - MON$PAGE_FETCHES (number of page fetches)
      - MON$PAGE_MARKS (number of page marks)

    MON$RECORD_STATS (record-level statistics)
      - MON$STAT_ID (statistics ID)
      - MON$STAT_GROUP (statistics group)
          0: database
          1: attachment
          2: transaction
          3: statement
          4: call
      - MON$RECORD_SEQ_READS (number of records read sequentially)
      - MON$RECORD_IDX_READS (number of records read via an index)
      - MON$RECORD_INSERTS (number of inserted records)
      - MON$RECORD_UPDATES (number of updated records)
      - MON$RECORD_DELETES (number of deleted records)
      - MON$RECORD_BACKOUTS (number of backed out records)
      - MON$RECORD_PURGES (number of purged records)
      - MON$RECORD_EXPUNGES (number of expunged records)

  Notes:
    1) Textual descriptions of all "state" and "mode" values can be found
       in the system table RDB$TYPES

    2) For table MON$ATTACHMENTS:
      - columns MON$REMOTE_PID and MON$REMOTE_PROCESS contains non-NULL values
        only if the client library has version 2.1 or higher
      - column MON$REMOTE_PROCESS can contain a non-pathname value
        if an application has specified a custom process name via DPB

    3) For table MON$STATEMENTS:
      - column MON$SQL_TEXT contains NULL for GDML statements
      - columns MON$TRANSACTION_ID and MON$TIMESTAMP contain valid values
        for active statements only

    4) For table MON$CALL_STACK:
      - column MON$STATEMENT_ID groups call stacks by the top-level DSQL statement
        that initiated the call chain. This ID represents an active statement
        record in the table MON$STATEMENTS.
      - columns MON$SOURCE_LINE and MON$SOURCE_COLUMN contain line/column information
        related to the PSQL statement being currently executed

  Example(s):
    1) Retrieve IDs of all CS processes loading CPU at the moment
        SELECT MON$SERVER_PID
        FROM MON$ATTACHMENTS
        WHERE MON$ATTACHMENT_ID <> CURRENT_CONNECTION
          AND MON$STATE = 1

    2) Retrieve information about client applications
        SELECT MON$USER, MON$REMOTE_ADDRESS, MON$REMOTE_PID, MON$TIMESTAMP
        FROM MON$ATTACHMENTS
        WHERE MON$ATTACHMENT_ID <> CURRENT_CONNECTION

    3) Get isolation level of the current transaction
        SELECT MON$ISOLATION_MODE
        FROM MON$TRANSACTIONS
        WHERE MON$TRANSACTION_ID = CURRENT_TRANSACTION

    4) Get statements that are currently active
        SELECT ATT.MON$USER, ATT.MON$REMOTE_ADDRESS, STMT.MON$SQL_TEXT, STMT.MON$TIMESTAMP
        FROM MON$ATTACHMENTS ATT
          JOIN MON$STATEMENTS STMT ON ATT.MON$ATTACHMENT_ID = STMT.MON$ATTACHMENT_ID
        WHERE ATT.MON$ATTACHMENT_ID <> CURRENT_CONNECTION
          AND STMT.MON$STATE = 1

    5) Retrieve call stacks for all connections
        WITH RECURSIVE
          HEAD AS
        (
          SELECT CALL.MON$STATEMENT_ID, CALL.MON$CALL_ID, CALL.MON$OBJECT_NAME, CALL.MON$OBJECT_TYPE
          FROM MON$CALL_STACK CALL
          WHERE CALL.MON$CALLER_ID IS NULL
          UNION ALL
          SELECT CALL.MON$STATEMENT_ID, CALL.MON$CALL_ID, CALL.MON$OBJECT_NAME, CALL.MON$OBJECT_TYPE
          FROM MON$CALL_STACK CALL
            JOIN HEAD ON CALL.MON$CALLER_ID = HEAD.MON$CALL_ID
        )
        SELECT MON$ATTACHMENT_ID, MON$OBJECT_NAME, MON$OBJECT_TYPE
        FROM HEAD
          JOIN MON$STATEMENTS STMT ON STMT.MON$STATEMENT_ID = HEAD.MON$STATEMENT_ID
        WHERE STMT.MON$ATTACHMENT_ID <> CURRENT_CONNECTION
