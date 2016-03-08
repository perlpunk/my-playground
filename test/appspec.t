#!/usr/bin/env bash

source test/setup

use Test::More tests 11
use JSON

JSON.load "$(< test/appspec-tests.json)" TESTDATA
#echo $TESTDATA
keys=$(JSON.keys '/' TESTDATA)

for i in $keys; do
    test=$(JSON.object "/$i" TESTDATA)
#    echo "TEST: $test"
    _args=$(JSON.keys '/args' test)
#    echo "ARGS: >>$_args<<"
    args=""
    for j in $_args; do
        arg=$(JSON.get -s "/args/$j" test)
#        echo "ARG $j >>$arg<<"
        args+=" $arg"
    done
#    args="${args/$'\n'/ }"
#    echo "ARGS: >>$args<<"
#    stdout=$(JSON
    testexitcode=$(JSON.get -s '/exit' test)


    out=`bin/myapp-bash $cmds 2>&1`
#    echo "OUTPUT: >>$out<<"
    exitcode=$?
    is $exitcode $testexitcode "(args=$args) exitcode=$testexitcode"
done
