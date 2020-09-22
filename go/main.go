package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"reflect"
	"strconv"
	"strings"
	"time"
)

func quicksort(arr []float64) {
	quicksortHelp(arr, 0, len(arr)-1)
}

func quicksortHelp(arr []float64, low int, high int) {
	if low < high {
		var partitionIndex int = partition(arr, high, low, high)

		quicksortHelp(arr, low, partitionIndex-1)
		quicksortHelp(arr, partitionIndex+1, high)
	}
}

func partition(arr []float64, pivotIndex int, low int, high int) int {
	var partitionIndex int = low

	for i := low; i < high; i++ {
		if arr[i] < arr[pivotIndex] {
			swap(arr, i, partitionIndex)
			partitionIndex++
		}
	}

	swap(arr, high, partitionIndex)

	return partitionIndex
}

func swap(arr []float64, i int, j int) {
	var old float64 = arr[i]

	arr[i] = arr[j]
	arr[j] = old
}

func main() {
	args := os.Args
	if len(args) < 3 {
		fmt.Println("This program takes 2 arguments: the file of unsorted comma-separated numbers, and the file of sorted numbers.")
		os.Exit(1)
	}

	unsortedText, err := ioutil.ReadFile(args[1])
	if err != nil {
		panic(err)
	}

	strs := strings.Split(string(unsortedText), ",")
	var nums []float64
	for i := 0; i < len(strs); i++ {
		num, err := strconv.ParseFloat(strs[i], 64)
		if err != nil {
			panic(err)
		}
		nums = append(nums, num)
	}

	start := time.Now()
	quicksort(nums)
	elapsed := time.Since(start)

	fmt.Printf("Finished quicksorting %d numbers in %.3fms\n", len(nums), float64(elapsed.Nanoseconds())/1e6)

	sortedText, err := ioutil.ReadFile(args[2])
	if err != nil {
		panic(err)
	}
	strs = strings.Split(string(sortedText), ",")
	var sortedNums []float64
	for i := 0; i < len(strs); i++ {
		num, err := strconv.ParseFloat(strs[i], 64)
		if err != nil {
			panic(err)
		}
		sortedNums = append(sortedNums, num)
	}

	if !reflect.DeepEqual(nums, sortedNums) {
		fmt.Println("Quicksort did not produce the expected sorted numbers!")
	}
}
