# C++ Quicksort Benchmark

To run from this directory:

```
$ clang++ -O3 quicksort.cpp -o quicksort && ./quicksort ../unsorted.csv ../sorted.csv
```

At the end, it will print how many milliseconds the quicksort function took
to sort the 1 million numbers in `unsorted.csv`.
