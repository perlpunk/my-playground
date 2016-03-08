#!/usr/bin/env bash

source test/setup

use Test::More tests 11
use JSON

set -e

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
    stdout=$(JSON.object '/stdout' test)
    testexitcode=$(JSON.get -s '/exit' test)


#    echo "ARGS: >>$args<<"
    (out=$(bin/myapp-bash $args 2>&1) || true; echo OK )
    exitcode=$?
#    echo "CMD >>$args<< exit:$? $exitcode"
#    echo "OUTPUT: >>$out<<"
    is $exitcode $testexitcode "(args=$args) exitcode=$testexitcode"
done
