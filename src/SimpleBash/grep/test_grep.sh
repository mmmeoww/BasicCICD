#!/bin/bash

test_grep () {
  COUNTER=$((COUNTER + 1))
  grep $@ > test1.txt
  ./s21_grep $@ > test2.txt
  diff -q test1.txt test2.txt > /dev/null
  if [ $? -eq 0 ]; then
      SUCCESS=$((SUCCESS + 1))
      echo "$COUNTER - [SUCCES] with $@"
  else
      FAIL=$((FAIL + 1))
      echo "$COUNTER - [FAIL] with $@"
      sleep 1
  fi
}

COUNTER=0
SUCCESS=0
FAIL=0

log="test3.txt"
VALGRIND="valgrind -q --leak-check=full --log-file=$log ./s21_grep"

FLAGS="-i -v -e -c -l -n -h -s -o -lol"
F_FLAG="-f"

NO_EXIST="no_exist.txt"
FILES="../examples/example0.txt ../examples/example1.txt ../examples/example2.txt ../examples/test_0_grep.txt ../examples/example"
FILES1="../examples/example1.txt ../examples/example ../examples/0.txt"
FILES_PATTERN="no_exist.txt ../examples/arg.txt"
PATTERNS="a de fa he e pro"
PATTERNS1="in it c Seg lan"

for file in $FILES; do
    for pattern in $PATTERNS; do
        test_grep "$pattern $file"
        for flag in $FLAGS; do
            test_grep "$flag $pattern $file"
        done
    done    
done
for file_pattern in $FILES_PATTERN; do
    for file in $FILES; do
        test_grep "-f $file_pattern $file"
    done
done 
for file_pattern in $FILES_PATTERN; do
    for file in $FILES; do
        for flag in $FLAGS; do
            test_grep "$flag -f $file_pattern $file"
        done
    done
done 
for pattern in $PATTERNS; do
    for pattern1 in $PATTERNS1; do
        test_grep "-e $pattern -e $pattern1 $file"
    done
done 
for pattern in $PATTERNS; do 
    test_grep "$pattern $NO_EXIST"
done
for pattern in $PATTERNS; do
    for file in $FILES; do
        for file1 in $FILES1; do
            if [ $file != $file1 ]; then            
                test_grep "-o $pattern $file $file1"
            fi
        done
    done
done 

for flag in $FLAGS; do
    for pattern in $PATTERNS; do
        for file in $FILES; do        
                        test_grep "$flag $pattern $file" 
        done
    done
done

echo "ALL: $COUNTER"
echo "SUCCESS = $SUCCESS"
echo "FAILS = $FAIL"

rm -rf test1.txt test2.txt test3.txt

if [ $FAIL -ne 0 ]; then
    echo "Integration tests failed!"
    exit 1 
else
    echo "All tests passed!"
fi