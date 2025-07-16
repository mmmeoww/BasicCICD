#!/bin/bash

FLAGS="-b -e -n -s -t -E -T --number --number-nonblank --squeeze-blank"
BIG_FLAG="-benstET"
FILES="../examples/all_sym_160.txt ../examples/example0.txt ../examples/example1.txt ../examples/example2.txt ../examples/example ../examples/test_0_grep.txt ../examples/0.txt"

SUCCESS=0
FAIL=0

if [ ! -f ./s21_cat ]; then
    echo "./s21_cat is not compiled!"
    echo "please run: make s21_cat"
    exit 1
else
    for flag in $FLAGS; do
        echo "./s21_cat $flag ../examples/*:"
        echo -n " TEST - "
        cat $flag ../examples/* > test1.txt
        ./s21_cat $flag ../examples/* > test2.txt
        diff -q test1.txt test2.txt > /dev/null
        if [ $? -eq 0 ]; then
            SUCCESS=$((SUCCESS + 1))
            echo "[PASS]"
        else
            FAIL=$((FAIL + 1))
            echo "[FAIL]"
        fi
    done
    echo


    for file in $FILES; do
        echo "./s21_cat -x $file:"
        cat -x $file > test1.txt
        ./s21_cat -x $file > test2.txt
        diff -q test1.txt test2.txt > /dev/null
        if [ $? -eq 0 ]; then
            SUCCESS=$((SUCCESS + 1))
            echo " TEST - [PASS]"
        else
            FAIL=$((FAIL + 1))
            echo " TEST - [FAIL]"
        fi
    done
    echo

    cat -x ne.txt > test1.txt
    ./s21_cat -x ne.txt > test2.txt
    diff -q test1.txt test2.txt > /dev/null
    if [ $? -eq 0 ]; then
        SUCCESS=$((SUCCESS + 1))
        echo " TEST - [PASS]"
    else
        FAIL=$((FAIL + 1))
        echo " TEST - [FAIL]"
    fi

    for file in $FILES; do
        echo "./s21_cat $file:"
        echo -n " TEST - "
        cat $file > test1.txt
        ./s21_cat $file > test2.txt
        diff -q test1.txt test2.txt > /dev/null
        if [ $? -eq 0 ]; then
            SUCCESS=$((SUCCESS + 1))
            echo "[PASS]"
        else
            FAIL=$((FAIL + 1))
            echo "[FAIL]"
        fi

        for flag in $FLAGS; do
            echo "./s21_cat $flag $file:"
            echo -n " TEST - "
            cat $flag $file > test1.txt
            ./s21_cat $flag $file > test2.txt
            diff -q test1.txt test2.txt > /dev/null
            if [ $? -eq 0 ]; then
                SUCCESS=$((SUCCESS + 1))
                echo "[PASS]"
            else
                FAIL=$((FAIL + 1))
                echo "[FAIL]"
            fi
        done
    done

    for file in $FILES; do
        echo "./s21_cat $BIG_FLAG $file:"
        echo -n " TEST - "
        cat $BIG_FLAG $file > test1.txt
        ./s21_cat $BIG_FLAG $file > test2.txt
        diff -q test1.txt test2.txt > /dev/null
        if [ $? -eq 0 ]; then
            SUCCESS=$((SUCCESS + 1))
            echo "[PASS]"
        else
            FAIL=$((FAIL + 1))
            echo "[FAIL]"
        fi
    done

    echo "./s21_cat $BIG_FLAG ../examples/*:"
    echo -n " TEST - "
    cat $BIG_FLAG ../examples/* > test1.txt
    ./s21_cat $BIG_FLAG ../examples/* > test2.txt
    diff -q test1.txt test2.txt > /dev/null
    if [ $? -eq 0 ]; then
        SUCCESS=$((SUCCESS + 1))
        echo "[PASS]"
    else
        FAIL=$((FAIL + 1))
        echo "[FAIL]"
    fi
fi

echo "SUCCESS = $SUCCESS"
echo "FAILS = $FAIL"

rm -rf test1.txt test2.txt test3.txt

if [ $FAIL -ne 0 ]; then
    echo "Integration tests failed!"
    exit 1 
else
    echo "All tests passed!"
fi