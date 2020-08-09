# Quicksort Benchmarks

Benchmark quicksorting 1 million 64-bit integers (found in the file `unsorted.csv`)
and time how long the quicksort function specifically takes. This is not a
terribly rigorous benchmark and shouldn't be taken very seriously. It's mainly
to see how Roc's optimizations measure up against other languages that have
first-class support for in-place mutation.

Some goals:

1. Use a straightforward quicksort implementation - like one that might appear in a textbook, not a performance-tuned one.
2. Only measure time spent in the quicksorting function itself, to eliminate differences due to VM startup times and suche
3. Read the numbers from a file, and process them as 64-bit integers, so in all languages we're working with 64-bit integers stored on the heap.
