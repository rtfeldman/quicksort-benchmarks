import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.io.IOException;
import java.util.stream.Collectors;
import static java.util.stream.Collectors.toList;

public class Quicksort {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("This program takes 2 arguments: the file of unsorted comma-separated numbers, and the file of sorted numbers.");
            System.exit(1);
        }

        Path unsortedFile = Paths.get(args[0]);
        Path sortedFile = Paths.get(args[1]);
        Charset charset = StandardCharsets.UTF_8;

        try {
            String text = String.join("", Files.readAllLines(unsortedFile, charset));
            List<String> numStrings = Arrays.asList(text.split(","));
            double[] nums = new double[numStrings.size()];

            for (int i=0; i < nums.length; i++) {
                nums[i] = Double.parseDouble(numStrings.get(i));
            }

            long startTimeNs = System.nanoTime();
            quicksort(nums);
            long endTimeNs = System.nanoTime();
	        System.out.printf("Finished quicksorting %d numbers in %.3fms\n", nums.length , (endTimeNs - startTimeNs)/1e6);

            text = String.join("", Files.readAllLines(sortedFile, charset));
            List<String> sortedNumStrings = Arrays.asList(text.split(","));

            if (nums.length != sortedNumStrings.size()) {
              System.out.println("Quicksort produced sorted numbers that were different in length from the sorted CSV!");
              System.exit(1);
            }

            for (int i=0; i < nums.length; i++) {
                if (nums[i] != Double.parseDouble(sortedNumStrings.get(i))) {
                  System.out.println("Quicksort did not produce the expected sorted numbers!");
                  System.exit(1);
                }
            }
        } catch (IOException ex) {
            System.out.println("IOException: " + ex);
            System.exit(1);
        }
    }

    private static void quicksort(double[] arr) {
        quicksortHelp(arr, 0, arr.length - 1);
    }

    private static void quicksortHelp(double[] arr, int low, int high) {
        if (low < high) {
            int partitionIndex = partition(arr, high, low, high);

            quicksortHelp(arr, low, partitionIndex - 1);
            quicksortHelp(arr, partitionIndex + 1, high);
        }
    }

    private static int partition(double[] arr, int pivotIndex, int low, int high) {
        int partitionIndex = low;

        for (int i = low; i < high; i++) {
            if (arr[i] < arr[pivotIndex]) {
                swap(arr, i, partitionIndex);
                partitionIndex++;
            }
        }

        swap(arr, high, partitionIndex);

        return partitionIndex;
    }

    private static void swap(double[] arr, int i, int j) {
        double old = arr[i];

        arr[i] = arr[j];
        arr[j] = old;
    }
}
