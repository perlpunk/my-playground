#!/usr/bin/env bash

source test/setup

use Test::More
use JSON

tempfile="test/appspec.temp"

JSON.load "$(< test/appspec-tests.json)" TESTDATA
# echo "$TESTDATA"
keys=($(JSON.keys '/' TESTDATA))

for k in "${keys[@]}"; do
    test=$(JSON.object "/$k" TESTDATA)
    _args=($(JSON.keys '/args' test))
    args=()
    for a in "${_args[@]}"; do
        arg=$(JSON.get -s "/args/$a" test)
        args+=("$arg")
    done
    stdout=$(JSON.object '/stdout' test)
    testexitcode=$(JSON.get -s '/exit' test)

    exitcode=0
    out=$(bin/myappbash ${args[@]} 2>$tempfile) || exitcode=$?
    err=$(< $tempfile)
#    echo "CMD >>${args[@]}<< exit:$exitcode"
#    echo "stdout: >>$out<<"
#    echo "stderr: >>$err<<"
    is "$exitcode" "$testexitcode" \
        "(args=${args[@]}) exitcode=$testexitcode"
done

rm "$tempfile"

done_testing 11
