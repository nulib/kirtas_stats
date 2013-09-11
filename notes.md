mysql -h hostname -u username -p dbname < test_sql.in > test_sql.out

mysql -h repository.library.northwestern.edu -u jbpmro -p jbpmdb -N < test_sql.in

What do the results from multiple select statements in test_sql.in look like?

Delimit results using status messages?
http://dev.mysql.com/doc/refman/5.7/en/mysql-batch-commands.html

Change delimiter for each result set to ease parsing?
--delimiter=str | delimiter | Set the statement delimiter
*** delimits sets, not each result

Read config file into hash and use hash values in mysql call

Collect all the select statements in a single file and run once
Parse output


# YAML

date: YYYY-MM-DD
    project: XXX
        description: XXX
            count: XXX

# SQL update

update kirtas_stats
set #{description} = #{count}
where date = YYYY-MM-DD
and project = XXX
