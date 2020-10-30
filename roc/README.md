# Roc Quicksort Benchmark

To run from this directory:

```
$ cd platform
$ CARGO_NET_GIT_FETCH_WITH_CLI=true cargo build --release
$ cd ..
$ roc build --optimize Quicksort.roc
$ ./app ../unsorted.csv ../sorted.csv
```

At the end, it will print how many milliseconds the quicksort function took
to sort the 1 million numbers in `unsorted.csv`.
