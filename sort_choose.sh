#!/bin/bash

# Bubble Sort
bubble_sort() {
    arr=("${@}")
    n=${#arr[@]}
    for ((i = 0; i < n; i++)); do
        for ((j = 0; j < n - i - 1; j++)); do
            if (( arr[j] > arr[j + 1] )); then
                temp=${arr[j]}
                arr[j]=${arr[j + 1]}
                arr[j + 1]=$temp
            fi
        done
    done
    echo "${arr[@]}"
}

# Insertion Sort
insertion_sort() {
    arr=("${@}")
    for ((i = 1; i < ${#arr[@]}; i++)); do
        key=${arr[i]}
        j=$((i - 1))
        while ((j >= 0 && arr[j] > key)); do
            arr[j + 1]=${arr[j]}
            ((j--))
        done
        arr[j + 1]=$key
    done
    echo "${arr[@]}"
}

# Selection Sort
selection_sort() {
    arr=("${@}")
    n=${#arr[@]}
    for ((i = 0; i < n - 1; i++)); do
        min=$i
        for ((j = i + 1; j < n; j++)); do
            if (( arr[j] < arr[min] )); then
                min=$j
            fi
        done
        temp=${arr[i]}
        arr[i]=${arr[min]}
        arr[min]=$temp
    done
    echo "${arr[@]}"
}

# Merge Sort
merge_sort() {
    arr=("$@")
    if (( ${#arr[@]} <= 1 )); then
        echo "${arr[@]}"
        return
    fi

    mid=$(( ${#arr[@]} / 2 ))
    left=("${arr[@]:0:mid}")
    right=("${arr[@]:mid}")

    left_sorted=($(merge_sort "${left[@]}"))
    right_sorted=($(merge_sort "${right[@]}"))

    echo "$(merge "${left_sorted[@]}" - "${right_sorted[@]}")"
}

# Merge helper
merge() {
    local left=()
    local right=()
    local merged=()

    while [[ "$1" != "-" ]]; do left+=("$1"); shift; done
    shift # remove "-"
    while (( "$#" )); do right+=("$1"); shift; done

    while (( ${#left[@]} && ${#right[@]} )); do
        if (( ${left[0]} <= ${right[0]} )); then
            merged+=("${left[0]}")
            left=("${left[@]:1}")
        else
            merged+=("${right[0]}")
            right=("${right[@]:1}")
        fi
    done

    merged+=("${left[@]}" "${right[@]}")
    echo "${merged[@]}"
}

# Quick Sort
quick_sort() {
    arr=("$@")
    if (( ${#arr[@]} <= 1 )); then
        echo "${arr[@]}"
        return
    fi

    pivot=${arr[0]}
    left=()
    right=()

    for ((i=1; i<${#arr[@]}; i++)); do
        if (( arr[i] < pivot )); then
            left+=("${arr[i]}")
        else
            right+=("${arr[i]}")
        fi
    done

    echo "$(quick_sort "${left[@]}") $pivot $(quick_sort "${right[@]}")"
}

# ---- Main Program ----

read -p "Enter integers separated by space: " -a numbers

echo "Choose Sorting Algorithm:"
echo "1) Bubble Sort"
echo "2) Insertion Sort"
echo "3) Selection Sort"
echo "4) Merge Sort"
echo "5) Quick Sort"
read -p "Enter choice [1-5]: " algo_choice

# Call appropriate function
case $algo_choice in
    1) sorted=($(bubble_sort "${numbers[@]}")) ;;
    2) sorted=($(insertion_sort "${numbers[@]}")) ;;
    3) sorted=($(selection_sort "${numbers[@]}")) ;;
    4) sorted=($(merge_sort "${numbers[@]}")) ;;
    5) sorted=($(quick_sort "${numbers[@]}")) ;;
    *) echo "Invalid sorting algorithm choice"; exit 1 ;;
esac

echo "Sorted Result (Ascending): ${sorted[*]}"
