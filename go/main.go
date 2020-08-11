package main

import "strconv"
import "io/ioutil"
import "fmt"
import "time"
import "strings"

func quicksort(arr []int64) {
    quicksortHelp(arr, 0, len(arr) - 1);
}

func quicksortHelp(arr []int64, low int, high int) {
    if low < high {
        var partitionIndex int = partition(arr, high, low, high)

        quicksortHelp(arr, low, partitionIndex - 1);
        quicksortHelp(arr, partitionIndex + 1, high);
    }
}

func partition(arr []int64, pivotIndex int, low int, high int) int {
    var partitionIndex int = low;

    for i := low; i < high; i++ {
        if arr[i] < arr[pivotIndex] {
            swap(arr, i, partitionIndex);
            partitionIndex++;
        }
    }

    swap(arr, high, partitionIndex);

    return partitionIndex;
}

func swap(arr []int64, i int, j int) {
    var old int64 = arr[i];

    arr[i] = arr[j];
    arr[j] = old;
}

func main() {
  text, err := ioutil.ReadFile("../unsorted.csv")

  if err != nil {
      panic(err)
  }

  strs := strings.Split(string(text), ",")
  nums := []int64{}

  for i := 0; i < len(strs); i++ {
    num, err := strconv.ParseInt(strs[i], 10, 64)

    if err != nil {
        panic(err)
    }

    nums = append(nums, num)
  }

  start := time.Now()
  quicksort(nums);
  end := time.Now()

  elapsed := end.Sub(start)

	fmt.Println("Finished quicksorting", len(nums), "numbers in", elapsed);
}
