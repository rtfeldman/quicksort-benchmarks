const fs = require("fs");
const assert = require("assert").strict;

function quicksort(arr) {
  quicksortHelp(arr, 0, arr.length - 1);
}

function quicksortHelp(arr, low, high) {
  if (low < high) {
    const partitionIndex = partition(arr, high, low, high);

    quicksortHelp(arr, low, partitionIndex - 1);
    quicksortHelp(arr, partitionIndex + 1, high);
  }
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

let unsortedFilename = process.argv[2];
let sortedFilename = process.argv[3];

if (unsortedFilename == null || sortedFilename == null) {
  console.log(
    "This program takes 2 arguments: the file of unsorted comma-separated numbers, and the file of sorted numbers."
  );

  process.exit();
}

let nums = fs
  .readFileSync(unsortedFilename, { encoding: "utf8" })
  .split(",")
  .map(BigInt);

console.log("Unsorted:", nums);

const startNs = process.hrtime.bigint();
quicksort(nums);
const endNs = process.hrtime.bigint();

console.log("Sorted:", nums);

let sorted = fs
  .readFileSync(sortedFilename, { encoding: "utf8" })
  .split(",")
  .map(BigInt);

assert.deepEqual(
  nums,
  sorted,
  "Quicksort did not produce the expected sorted numbers!"
);

console.log(
  "Total time spent in the quicksort function: " + (endNs - startNs) + " ns"
);
