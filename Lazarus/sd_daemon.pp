
unit sd_daemon;
interface



{
  Automatically converted by H2Pas 1.0.0 from sd-daemon.h
  The following command line parameters were used:
    -d
    sd-daemon.h
}

uses
 types;

    Type

uint16_t = word;
uint32_t = dword;
uint64_t = qword;
size_t = qword;
pid_t = integer;

    Pchar  = ^char;
    Plongint  = ^longint;
    Puint64_t  = ^uint64_t;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  {-*- Mode: C; c-basic-offset: 8; indent-tabs-mode: nil -*- }
{$ifndef foosddaemonhfoo}
{$define foosddaemonhfoo}  
  {**
    This file is part of systemd.
  
    Copyright 2013 Lennart Poettering
  
    systemd is free software; you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation; either version 2.1 of the License, or
    (at your option) any later version.
  
    systemd is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.
  
    You should have received a copy of the GNU Lesser General Public License
    along with systemd; If not, see <http://www.gnu.org/licenses/>.
  ** }
//{$include <sys/types.h>}
//{$include <inttypes.h>}
//{$include "_sd-common.h"}
(* error 
_SD_BEGIN_DECLARATIONS;
in declaration at line 30 *)
    {
      The following functionality is provided:
    
      - Support for logging with log levels on stderr
      - File descriptor passing for socket-based activation
      - Daemon startup and status notification
      - Detection of systemd boots
    
      See sd-daemon(3) for more information.
     }
    {
      Log levels for usage on stderr:
    
              fprintf(stderr, SD_NOTICE "Hello World!\n");
    
      This is similar to printk() usage in the kernel.
     }
    { system is unusable  }

    const
      SD_EMERG = '<0>';      
    { action must be taken immediately  }
      SD_ALERT = '<1>';      
    { critical conditions  }
      SD_CRIT = '<2>';      
    { error conditions  }
      SD_ERR = '<3>';      
    { warning conditions  }
      SD_WARNING = '<4>';      
    { normal but significant condition  }
      SD_NOTICE = '<5>';      
    { informational  }
      SD_INFO = '<6>';      
    { debug-level messages  }
      SD_DEBUG = '<7>';      
    { The first passed file descriptor is fd 3  }
      SD_LISTEN_FDS_START = 3;      
    {
      Returns how many file descriptors have been passed, or a negative
      errno code on failure. Optionally, removes the $LISTEN_FDS and
      $LISTEN_PID file descriptors from the environment (recommended, but
      problematic in threaded environments). If r is the return value of
      this function you'll find the file descriptors passed as fds
      SD_LISTEN_FDS_START to SD_LISTEN_FDS_START+r-1. Returns a negative
      errno style error code on failure. This function call ensures that
      the FD_CLOEXEC flag is set for the passed file descriptors, to make
      sure they are not passed on to child processes. If FD_CLOEXEC shall
      not be set, the caller needs to unset it after this call for all file
      descriptors that are used.
    
      See sd_listen_fds(3) for more information.
     }

    function sd_listen_fds(unset_environment:longint):longint;cdecl;external;

    function sd_listen_fds_with_names(unset_environment:longint; names:PPPchar):longint;cdecl;external;

    {
      Helper call for identifying a passed file descriptor. Returns 1 if
      the file descriptor is a FIFO in the file system stored under the
      specified path, 0 otherwise. If path is NULL a path name check will
      not be done and the call only verifies if the file descriptor
      refers to a FIFO. Returns a negative errno style error code on
      failure.
    
      See sd_is_fifo(3) for more information.
     }
(* Const before type ignored *)
    function sd_is_fifo(fd:longint; path:Pchar):longint;cdecl;external;

    {
      Helper call for identifying a passed file descriptor. Returns 1 if
      the file descriptor is a special character device on the file
      system stored under the specified path, 0 otherwise.
      If path is NULL a path name check will not be done and the call
      only verifies if the file descriptor refers to a special character.
      Returns a negative errno style error code on failure.
    
      See sd_is_special(3) for more information.
     }
(* Const before type ignored *)
    function sd_is_special(fd:longint; path:Pchar):longint;cdecl;external;

    {
      Helper call for identifying a passed file descriptor. Returns 1 if
      the file descriptor is a socket of the specified family (AF_INET,
      ...) and type (SOCK_DGRAM, SOCK_STREAM, ...), 0 otherwise. If
      family is 0 a socket family check will not be done. If type is 0 a
      socket type check will not be done and the call only verifies if
      the file descriptor refers to a socket. If listening is > 0 it is
      verified that the socket is in listening mode. (i.e. listen() has
      been called) If listening is == 0 it is verified that the socket is
      not in listening mode. If listening is < 0 no listening mode check
      is done. Returns a negative errno style error code on failure.
    
      See sd_is_socket(3) for more information.
     }
    function sd_is_socket(fd:longint; family:longint; _type:longint; listening:longint):longint;cdecl;external;

    {
      Helper call for identifying a passed file descriptor. Returns 1 if
      the file descriptor is an Internet socket, of the specified family
      (either AF_INET or AF_INET6) and the specified type (SOCK_DGRAM,
      SOCK_STREAM, ...), 0 otherwise. If version is 0 a protocol version
      check is not done. If type is 0 a socket type check will not be
      done. If port is 0 a socket port check will not be done. The
      listening flag is used the same way as in sd_is_socket(). Returns a
      negative errno style error code on failure.
    
      See sd_is_socket_inet(3) for more information.
     }
    function sd_is_socket_inet(fd:longint; family:longint; _type:longint; listening:longint; port:uint16_t):longint;cdecl;external;

    {
      Helper call for identifying a passed file descriptor. Returns 1 if
      the file descriptor is an AF_UNIX socket of the specified type
      (SOCK_DGRAM, SOCK_STREAM, ...) and path, 0 otherwise. If type is 0
      a socket type check will not be done. If path is NULL a socket path
      check will not be done. For normal AF_UNIX sockets set length to
      0. For abstract namespace sockets set length to the length of the
      socket name (including the initial 0 byte), and pass the full
      socket path in path (including the initial 0 byte). The listening
      flag is used the same way as in sd_is_socket(). Returns a negative
      errno style error code on failure.
    
      See sd_is_socket_unix(3) for more information.
     }
(* Const before type ignored *)
    function sd_is_socket_unix(fd:longint; _type:longint; listening:longint; path:Pchar; length:size_t):longint;cdecl;external;

    {
      Helper call for identifying a passed file descriptor. Returns 1 if
      the file descriptor is a POSIX Message Queue of the specified name,
      0 otherwise. If path is NULL a message queue name check is not
      done. Returns a negative errno style error code on failure.
    
      See sd_is_mq(3) for more information.
     }
(* Const before type ignored *)
    function sd_is_mq(fd:longint; path:Pchar):longint;cdecl;external;

    {
      Informs systemd about changed daemon state. This takes a number of
      newline separated environment-style variable assignments in a
      string. The following variables are known:
    
         READY=1      Tells systemd that daemon startup is finished (only
                      relevant for services of Type=notify). The passed
                      argument is a boolean "1" or "0". Since there is
                      little value in signaling non-readiness the only
                      value daemons should send is "READY=1".
    
         STATUS=...   Passes a single-line status string back to systemd
                      that describes the daemon state. This is free-form
                      and can be used for various purposes: general state
                      feedback, fsck-like programs could pass completion
                      percentages and failing programs could pass a human
                      readable error message. Example: "STATUS=Completed
                      66% of file system check..."
    
         ERRNO=...    If a daemon fails, the errno-style error code,
                      formatted as string. Example: "ERRNO=2" for ENOENT.
    
         BUSERROR=... If a daemon fails, the D-Bus error-style error
                      code. Example: "BUSERROR=org.freedesktop.DBus.Error.TimedOut"
    
         MAINPID=...  The main pid of a daemon, in case systemd did not
                      fork off the process itself. Example: "MAINPID=4711"
    
         WATCHDOG=1   Tells systemd to update the watchdog timestamp.
                      Services using this feature should do this in
                      regular intervals. A watchdog framework can use the
                      timestamps to detect failed services. Also see
                      sd_watchdog_enabled() below.
    
         FDSTORE=1    Store the file descriptors passed along with the
                      message in the per-service file descriptor store,
                      and pass them to the main process again on next
                      invocation. This variable is only supported with
                      sd_pid_notify_with_fds().
    
      Daemons can choose to send additional variables. However, it is
      recommended to prefix variable names not listed above with X_.
    
      Returns a negative errno-style error code on failure. Returns > 0
      if systemd could be notified, 0 if it couldn't possibly because
      systemd is not running.
    
      Example: When a daemon finished starting up, it could issue this
      call to notify systemd about it:
    
         sd_notify(0, "READY=1");
    
      See sd_notifyf() for more complete examples.
    
      See sd_notify(3) for more information.
     }
(* Const before type ignored *)
    function sd_notify(unset_environment:longint; state:Pchar):longint;cdecl;external;

    {
      Similar to sd_notify() but takes a format string.
    
      Example 1: A daemon could send the following after initialization:
    
         sd_notifyf(0, "READY=1\n"
                       "STATUS=Processing requests...\n"
                       "MAINPID=%lu",
                       (unsigned long) getpid());
    
      Example 2: A daemon could send the following shortly before
      exiting, on failure:
    
         sd_notifyf(0, "STATUS=Failed to start up: %s\n"
                       "ERRNO=%i",
                       strerror(errno),
                       errno);
    
      See sd_notifyf(3) for more information.
     }
(* Const before type ignored *)
(* error 
int sd_notifyf(int unset_environment, const char *format, ...) _sd_printf_(2,3);
(* error 
int sd_notifyf(int unset_environment, const char *format, ...) _sd_printf_(2,3);
 in declarator_list *)
 in declarator_list *)
    {
      Similar to sd_notify(), but send the message on behalf of another
      process, if the appropriate permissions are available.
     }
(* Const before type ignored *)
    function sd_pid_notify(pid:pid_t; unset_environment:longint; state:Pchar):longint;cdecl;external;

    {
      Similar to sd_notifyf(), but send the message on behalf of another
      process, if the appropriate permissions are available.
     }
(* Const before type ignored *)
(* error 
int sd_pid_notifyf(pid_t pid, int unset_environment, const char *format, ...) _sd_printf_(3,4);
(* error 
int sd_pid_notifyf(pid_t pid, int unset_environment, const char *format, ...) _sd_printf_(3,4);
 in declarator_list *)
 in declarator_list *)
    {
      Similar to sd_pid_notify(), but also passes the specified fd array
      to the service manager for storage. This is particularly useful for
      FDSTORE=1 messages.
     }
(* Const before type ignored *)
(* Const before type ignored *)
    function sd_pid_notify_with_fds(pid:pid_t; unset_environment:longint; state:Pchar; fds:Plongint; n_fds:dword):longint;cdecl;external;

    {
      Returns > 0 if the system was booted with systemd. Returns < 0 on
      error. Returns 0 if the system was not booted with systemd. Note
      that all of the functions above handle non-systemd boots just
      fine. You should NOT protect them with a call to this function. Also
      note that this function checks whether the system, not the user
      session is controlled by systemd. However the functions above work
      for both user and system services.
    
      See sd_booted(3) for more information.
     }
    function sd_booted:longint;cdecl;external;

    {
      Returns > 0 if the service manager expects watchdog keep-alive
      events to be sent regularly via sd_notify(0, "WATCHDOG=1"). Returns
      0 if it does not expect this. If the usec argument is non-NULL
      returns the watchdog timeout in µs after which the service manager
      will act on a process that has not sent a watchdog keep alive
      message. This function is useful to implement services that
      recognize automatically if they are being run under supervision of
      systemd with WatchdogSec= set. It is recommended for clients to
      generate keep-alive pings via sd_notify(0, "WATCHDOG=1") every half
      of the returned time.
    
      See sd_watchdog_enabled(3) for more information.
     }
    function sd_watchdog_enabled(unset_environment:longint; usec:Puint64_t):longint;cdecl;external;

(* error 
_SD_END_DECLARATIONS;
in declaration at line 289 *)
{$endif}

implementation

{$linklib systemd}

end.
