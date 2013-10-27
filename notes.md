# Outline

X 1. Generate SQL
X 2. Write SQL
3. Run SQL from infile
4. Record results to outfile
5. Parse results
6. Generate SQL INSERT statements 
7. Write SQL INSERT to file
8. Run SQL INSERT from file



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

|               |          Year           |         Quarter         |          Month          |
|      Day      | Started | Done | Killed | Started | Done | Killed | Started | Done | Killed |
|:-------------:|:-------:|:----:|:------:|:-------:|:----:|:------:|:-------:|:----:|:------:|
|  2013-10-22   |   132   |  77  |   43   |   132   |  77  |   43   |   65    |  72  |   26   |