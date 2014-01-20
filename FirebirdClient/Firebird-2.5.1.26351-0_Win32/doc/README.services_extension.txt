Services API enhancements in Firebird v2.
-----------------------------------------

1) Services API extension for new shutdown modes.
(Alex Peshkov, peshkoff@mail.ru, 2008)

New DB shutdown modes can now be set using services. A number of new 
isc_spb_prp_* constants should be used for it.

isc_spb_prp_shutdown_mode and isc_spb_prp_online_mode are used to perform
database shutdown/online operation. They have a single byte parameter, 
setting new shutdown mode: isc_spb_prp_sm_normal, isc_spb_prp_sm_multi,
isc_spb_prp_sm_single and isc_spb_prp_sm_full. They exactly match gfix's
shutdown modes. When performing shutdown operation, you must specify
also type of shutdown: one of isc_spb_prp_force_shutdown, 
isc_spb_prp_attachments_shutdown or isc_spb_prp_transactions_shutdown. 
They have single int (4-byte) parameter, specifying timeout for desired
operation.
Please note that old-styled parameters are also supported and should be
used to enter default shutdown (currently 'multi') and online ('normal') 
modes.

Samples of use of new parameters in fbsvcmgr utility (supposing login and 
password are set using some other method):
 Shutdown database to single-user maintenance mode:
  fbsvcmgr service_mgr action_properties dbname employee prp_shutdown_mode prp_sm_single prp_force_shutdown 0
 After it enable multi-user maintenance:
  fbsvcmgr service_mgr action_properties dbname employee prp_online_mode prp_sm_multi
 After it go to full shutdown mode, disabling new attachments during 60 seconds:
  fbsvcmgr service_mgr action_properties dbname employee prp_shutdown_mode prp_sm_full prp_attachments_shutdown 60
 Return to normal state:
  fbsvcmgr service_mgr action_properties dbname employee prp_online_mode prp_sm_normal

2) Services API extension - nbackup support.
(Alex Peshkov, peshkoff@mail.ru, 2008)

Nbackup performs two logical groups of operations - locking/unlocking database 
and backup/restore it. It doesn't make sense duplicating locking/unlocking in 
services, cause that functionality is present remotely in much better (from any 
point of view) in SQL language interface (ALTER DATABASE). But backup and restore 
must be run on localhost and the only way to access them is nbackup utility.
Therefore expanding services API with this functionalty is very useful.

The following actions were added:
isc_action_svc_nbak - incremental nbackup,
isc_action_svc_nrest - incremental database restore.
The following parameters were added:
isc_spb_nbk_level - backup level (integer),
isc_spb_nbk_file - backup file name (string),
isc_spb_nbk_no_triggers - do not run DB triggers (option).

Samples of use of new parameters in fbsvcmgr utility (supposing login and
password are set using some other method):
 Create backup level 0:
  fbsvcmgr service_mgr action_nbak dbname employee nbk_file e.nb0 nbk_level 0
 Create backup level 1:
  fbsvcmgr service_mgr action_nbak dbname employee nbk_file e.nb1 nbk_level 1
 Restore database from this files:
  fbsvcmgr service_mgr action_nrest dbname e.fdb nbk_file e.nb0 nbk_file e.nb1


3) Services API extension - trace support.
(Khorsun Vlad, hvlad@users.sourceforge.net, 2009)

	There are five new services and corresponding actions to manage by user
trace sessions :

Start user trace session :
	action
		isc_action_svc_trace_start    

	parameter(s)
		isc_spb_trc_name : trace session name, string, optional
		isc_spb_trc_cfg  : trace session configuration, string, mandatory

	output
		text message with status of operation :
			- Trace session ID NNN started
			- Can not start trace session. There are no trace plugins loaded
		contents of trace session in text format


Stop trace session
	action
		isc_action_svc_trace_stop     

	parameter(s)
		isc_spb_trc_id : trace session ID, integer, mandatory

	output
		text message with status of operation :
			- Trace session ID NNN stopped
			- No permissions to stop other user trace session
			- Trace session ID NNN not found


Suspend trace session
	action
		isc_action_svc_trace_suspend  

	parameter(s)
		isc_spb_trc_id : trace session ID, integer, mandatory

	output
		text message with status of operation :
			- Trace session ID NNN paused
			- No permissions to change other user trace session
			- Trace session ID NNN not found

Resume trace session
	action
		isc_action_svc_trace_resume   

	parameter(s)
		isc_spb_trc_id : trace session ID, integer, mandatory

	output
		text message with status of operation :
			- Trace session ID NNN resumed
			- No permissions to change other user trace session
			- Trace session ID NNN not found

List of existing trace sessions
	action
		isc_action_svc_trace_list     

	parameter(s)
		none

	output
		text messages with list and state of trace sessions
			- Session ID: <number>
			-   name:  <string>
			-   user:  <string>
			-   date:  YYYY-MM-DD HH:NN:SS
			-   flags: <string>
		
		"name" is trace session name and not printed if empty.
		"user" is creator user name
		"date" is session start date and time
		"flags" is comma delimited set of
			session's run state : "active" or "suspend"
			if creator user is administrator : "admin"
			if the session was created by the engine itself : "system"
			kind of session : "audit" or "trace"
			if user session log file is full : "log full"


	Output of every service is obtained as usually using isc_service_query call
with isc_info_svc_line or isc_info_svc_to_eof information items.

See also README.trace_services