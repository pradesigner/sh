#!/usr/bin/env zsh
# does pgrestore from existing pgdump files with clean

DIR=/home/pradmin/backups

dbGlobal=$(ls $DIR/pgglobals*)
cat $dbGlobal | gunzip | psql

for dbFile in $DIR/pgdump*; do
    dbName=${${dbFile#*_}%_*}
    dropdb $dbName
    createdb -T template0 $dbName
    pg_restore -d $dbName $dbFile
done

