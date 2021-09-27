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

template<class T>
void swap(std::vector<T>& arr, size_t i1, size_t i2)
{
  T buff = arr[i1];
  arr[i1] = arr[i2];
  arr[i2] = buff;
}

template<class T>
size_t partition(std::vector<T>& arr, size_t lo, size_t hi, size_t pi)
{
  swap(arr, pi, hi);
  T pv = arr[hi];
  size_t si=lo;
  for (size_t i=lo; i<hi; ++i) {
    if (arr[i] < pv) {
      swap(arr, i, si++);
    }
  }
  swap(arr, si, hi);
  return si;
}

template<class T>
void qsort(std::vector<T>& arr, size_t lo, size_t hi)
{
  size_t n = hi-lo+1;
  if (n < 2)
    return;
  size_t pi = partition(arr, lo, hi, lo + (hi-lo)/2);
  qsort(arr, lo,   pi-1);
  qsort(arr, pi+1, hi);
}

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
    qsort(nums, 0, nums.size() - 1);
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
