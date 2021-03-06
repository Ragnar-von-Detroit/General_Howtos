# Domino

* provides multiple services
    * database server
    * routing server
    * speaks NRPC (notes remote procedure call) and SMTP (simple mail transport protocol)
    * web server (http, IMAP, POP3, LDAP)
* can run as a cluster
* runs on multiple plattforms (windows, linux, aix, solars, as/400, z/os and zlinux)

# List of server commands

Each command supports a call with "/?" to output help/man page for that command.

| command | description |
| --- | --- |
| broadcast | sends message to a user, to users of a database or to users of a server |
| dbcache disable | disables cache to ease up getting exclusive access to a file (results in high I/O and low overfall performance) |
| dbcache flush | closes all databases that are currently handled by the cache |
| dbcache show | lists all databasese currently handled by the cache |
| drop <"username"|ALL> [<"username"> ...] | closes session for provided user names or for all if ALL is uses |
| exit | shutdown the server (use broadcast to informe the users upfront) |
| help | lists commands and brief description |
| keymgmt create <nek|credstore> <"nekname"> | creates a credential store |
| keymgmt export crestore <"filename"> <"servername"> | exports a copy of the current credstore.nsf |
| keymgmt import  credstore <"filename"> | copies all documents from the given credential store and adds them to the existing credstore.nsf |
| load <"pgoramname"> | loads a server add-in programm and starts it |
| platform <time|reset|reset interval enable|reset interval disable|pause|resume> <argument> | controls the platform statistics data from the console |
| pull <"servername"> [<"databasename">] | forces a one time and one way replication from the specified server |
| push <"servername"> [<"databasename">] | forces a one time and one way replication to the specified server |
| quit | shutdown the server (use broadcast to informe the users upfront) |
| replicate <"servername"> [<"databasename">] | forces a one time replication between the two servers |
| restart port <"portname"> | disables transactions or messages for the specified port for a shot amount of time |
| restart server | restarts the server (use broadcast to informe the users upfront) |
| restart task <"taskname"> | restarts a specified server task |
| route <"servername"> | initiates mail routing with the specified server |
| save noteid <"noteid"> | saves a specified document id as dxl |
| set configuration <"setting"> | adds or changes setting in the notes.ini |
| set rules | reloads servers mail rules |
| set scos <"databasename"> <active|inactive> | enables or disables a mail database to be shared |
| set secure <"current password"> [<"new password">] | sets, updates or removes a cli password (removing is done by setting the current password again |
| set statistics <"statistics name"> | resets a statistic |
| set systemtime | sets domino time to operation system time |
| show agents <"databasename"> [-v] | lists all agents for this database |
| show ai | lists history of the expansion factor and the availability index (ai) |
| show allports | lists the configuration of all enabled and disabled ports |
| show cluster | lists cluster name cache |
| show configuration [<"setting">] | lists settings from the notes.ini |
| show directory [<-"argument">] | lists all database files in the server path |
| show diskspace [<"location">] | lists free disk space |
| show heartbeat | checks if the server is responding |
| show idvaults | lists configuration information for id vaults and removes id vaults that are marked for deletion |
| show jvm | lists jvm version string |
| show memory | lists free memory and swap |
| show monitors | lists used memory used by monitors |
| show opendatabases | lists open databases including informations |
| show performance | lists per minute user/transaction values |
| show port <"portname"> | displays traffic, error statistics and resoueses used on the network adapter card or communications port |
| show schedule [<"servername/taskname/destination">] | shows next time the server task will run |
| show scos [All] | lists single copy object store (shared mail) informations and reloads the shared mail configuration |
| show server | lists server status information |
| show stat <"statisticname"> | lists server statistic for given name |
| show stat daos <"statisticname"> | lists statistics of the domino attachment object service |
| show stat mail | lists messaging statistics |
| show stat platform <network|logicaldisk|memory|pagingfile|plattform|process|system> | list indivitual and comulative statistis for all servers connected to the provided statistic group |
| show stat vm | lists performance of physical and virtual memory |
| show tasks | lists active server tasks |
| show transaction | lists information for each NRPC transaction |
| show users | lists all open session users |
| show xdir | lists information for each directory uses for name resolution |
| start consolelog | enables console log file output |
| start port <"portname"> | enables transactions or messages for provided port |
| stop consolelog | disables console log file output |
| stop port <"portname"> | disables transactions or messages for provided port |
| sucache refresh | forces dynamic reloading of the smart upgrade configuration system and displays status |
| sucache show | lists current status of servers smart upgrade cache |

# Links

* [HCL Domino 11.0 documentation - hcltechsw.com](https://help.hcltechsw.com/domino/11.0.0/index.html) - 2020-02-03
* [List of server commands and syntax (domino 9.0.1) - ibm.com](https://www.ibm.com/support/knowledgecenter/en/SSKTMJ_9.0.1/admin/admn_servercommandsyntax_c.html) - 2020-02-03
