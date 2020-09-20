package main

import (
	"fmt"
	"io/ioutil"
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
	text, err := ioutil.ReadFile("../unsorted.csv")

	if err != nil {
		panic(err)
	}

	strs := strings.Split(string(text), ",")
	nums := []float64{}

	for i := 0; i < len(strs); i++ {
		num, err := strconv.ParseFloat(strs[i], 64)

		if err != nil {
			panic(err)
		}

		nums = append(nums, num)
	}

	start := time.Now()
	quicksort(nums)
	end := time.Now()

	elapsed := end.Sub(start)

	fmt.Println("Finished quicksorting", len(nums), "numbers in", elapsed)
}
