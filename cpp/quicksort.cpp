#include <algorithm>
#include <chrono>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>
using namespace std;

void swap(vector<double> &arr, ptrdiff_t i, ptrdiff_t j) {
  long long old = arr[i];

  arr[i] = arr[j];
  arr[j] = old;
}

ptrdiff_t partition(vector<double> &arr, ptrdiff_t pivot_index, ptrdiff_t low,
                    ptrdiff_t high) {
  ptrdiff_t partition_index = low;

  for (ptrdiff_t i = low; i < high; i++) {
    if (arr[i] < arr[pivot_index]) {
      swap(arr, i, partition_index);
      partition_index++;
    }
  }

  swap(arr, high, partition_index);

  return partition_index;
}

void quicksort_help(vector<double> &arr, ptrdiff_t low, ptrdiff_t high) {
  if (low < high) {
    ptrdiff_t partition_index = partition(arr, high, low, high);

    quicksort_help(arr, low, partition_index - 1);
    quicksort_help(arr, partition_index + 1, high);
  }
}

void quicksort(vector<double> &arr) { quicksort_help(arr, 0, arr.size() - 1); }

int main(int argc, char **argv) {
  if (argc < 3) {
    std::cout << "This program takes 2 arguments: the file of unsorted "
                 "comma-separated numbers, and the file of sorted numbers."
              << std::endl;
    return 1;
  }
  ifstream unsorted_file(argv[1]);
  vector<double> nums;

  if (unsorted_file.is_open()) {
    string text;
    getline(unsorted_file, text);

    unsorted_file.close();

    std::stringstream ss(text);
    std::string token;

    while (std::getline(ss, token, ',') && nums.size() < 1000000) {
      nums.push_back(stod(token));
    }

    std::chrono::high_resolution_clock::time_point start_time =
        std::chrono::high_resolution_clock::now();
    quicksort(nums);
    std::chrono::high_resolution_clock::time_point end_time =
        std::chrono::high_resolution_clock::now();

    std::cout << "Finished quicksorting " << nums.size() << " numbers in "
              << std::fixed << std::setprecision(3)
              << std::chrono::duration_cast<std::chrono::nanoseconds>(
                     end_time - start_time)
                         .count() /
                     1e6
              << "ms" << std::endl;
  } else
    cout << "Unable to open unsorted file";

  ifstream sorted_file(argv[2]);
  vector<double> sorted_nums;
  if (sorted_file.is_open()) {
    string text;
    getline(sorted_file, text);

    sorted_file.close();

    std::stringstream ss(text);
    std::string token;

    while (std::getline(ss, token, ',') && sorted_nums.size() < 1000000) {
      sorted_nums.push_back(stod(token));
    }
    if (sorted_nums != nums) {
      std::cout << "Quicksort did not produce the expected sorted numbers!"
                << std::endl;
    }
  } else
    cout << "Unable to open sorted file";

  return 0;
}
