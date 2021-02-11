#!/bin/bash

arr1=("Hello" "World")
arr2=("Nice" "To" "Meet" "You")

arr1+=( ${arr2[@]} )

for i in ${arr1[@]};
    do
        echo $i
    done
