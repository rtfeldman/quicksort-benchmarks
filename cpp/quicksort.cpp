#include <iostream>
#include <fstream>
#include <vector>
#include <chrono>
#include <string>
#include <sstream>
#include <algorithm>
#include <iterator>
using namespace std;

void swap(vector<long long> &arr, ptrdiff_t i, ptrdiff_t j) {
    long long old = arr[i];

    arr[i] = arr[j];
    arr[j] = old;
}

ptrdiff_t partition(vector<long long> &arr, ptrdiff_t pivot_index, ptrdiff_t low, ptrdiff_t high) {
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

void quicksort_help(vector<long long> &arr, ptrdiff_t low, ptrdiff_t high) {
    if (low < high) {
        ptrdiff_t partition_index = partition(arr, high, low, high);

        quicksort_help(arr, low, partition_index - 1);
        quicksort_help(arr, partition_index + 1, high);
    }
}

void quicksort(vector<long long> &arr) {
    quicksort_help(arr, 0, arr.size() - 1);
}

int main ()
{
  string text;
  ifstream file ("../unsorted.csv");

  if (file.is_open())
  {
      vector<long long> nums;

      getline(file, text);

      file.close();

      std::stringstream ss(text);
      std::string token;

      while (std::getline(ss, token, ',') && nums.size() < 1000000) {
          nums.push_back(atol(token.c_str()));
      }

      cout << "Quicksorting " << nums.size() << " numbers..." << endl;

      std::chrono::high_resolution_clock::time_point start_time = std::chrono::high_resolution_clock::now();
      quicksort(nums);
      std::chrono::high_resolution_clock::time_point end_time = std::chrono::high_resolution_clock::now();

      std::cout << "Spent " << std::chrono::duration_cast<std::chrono::nanoseconds>(end_time - start_time).count() << " ns in quicksort function\n" << endl;

  }
  else cout << "Unable to open file";

  return 0;
}
