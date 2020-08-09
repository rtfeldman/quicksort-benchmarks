const fs = require("fs");

function quicksort(arr) {
  return quicksortHelp(arr, 0, arr.length - 1);
}

function quicksortHelp(arr, low, high) {
  if (low < high) {
    const partitionIndex = partition(arr, high, low, high);

    quicksortHelp(arr, low, partitionIndex - 1);
    quicksortHelp(arr, partitionIndex + 1, high);
  }

  return arr;
}

function partition(arr, pivotIndex, low, high) {
  let partitionIndex = low;

  for (let i = low; i < high; i++) {
    if (arr[i] < arr[pivotIndex]) {
      swap(arr, i, partitionIndex);
      partitionIndex++;
    }
  }

  swap(arr, high, partitionIndex);

  return partitionIndex;
}

function swap(arr, i, j) {
  const old = arr[i];

  arr[i] = arr[j];
  arr[j] = old;
}

let filename = process.argv[2];

if (filename == null) {
  console.log(
    "This script takes 1 argument: the file of comma-separated numbers."
  );

  process.exit();
}

let nums = fs
  .readFileSync(filename, { encoding: "utf8" })
  .split(",")
  .map(BigInt);

console.log("Unsorted:", nums);

const startNs = process.hrtime.bigint();
quicksort(nums);
const endNs = process.hrtime.bigint();

console.log("Sorted:", nums);
console.log("Total time spent in the quicksort function: " + (endNs - startNs) + " ns");
