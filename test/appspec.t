#!/usr/bin/env bash

source test/setup

use Test::More tests 11
use JSON

set +e

tempfile="test/appspec.temp"

JSON.load "$(< test/appspec-tests.json)" TESTDATA
#echo $TESTDATA
keys=$(JSON.keys '/' TESTDATA)

for i in $keys; do
    test=$(JSON.object "/$i" TESTDATA)
    _args=$(JSON.keys '/args' test)
    args=""
    for j in $_args; do
        arg=$(JSON.get -s "/args/$j" test)
        args+=" $arg"
    done
    stdout=$(JSON.object '/stdout' test)
    testexitcode=$(JSON.get -s '/exit' test)


    out=$(bin/myappbash $args 2>$tempfile)
    exitcode=$?
    err=$(< $tempfile)
    echo "CMD >>$args<< exit:$exitcode"
#    echo "stdout: >>$out<<"
#    echo "stderr: >>$err<<"
    is $exitcode $testexitcode "(args=$args) exitcode=$testexitcode"
done

rm "$tempfile"
