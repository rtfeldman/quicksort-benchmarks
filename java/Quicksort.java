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
            List<Double> nums = new ArrayList<Double>();

            for (String textNum : Arrays.asList(text.split(","))) {
                nums.add(Double.parseDouble(textNum));
            }

            long startTimeNs = System.nanoTime();
            quicksort(nums);
            long endTimeNs = System.nanoTime();

            text = String.join("", Files.readAllLines(sortedFile, charset));
            List<Double> sortedNums = new ArrayList<Double>();

            for (String textNum : Arrays.asList(text.split(","))) {
                sortedNums.add(Double.parseDouble(textNum));
            }

            System.out.println("Sorted in: " + (endTimeNs - startTimeNs) + " ns");
        } catch (IOException ex) {
            System.out.println("IOException: " + ex);
            System.exit(1);
        }
    }

    private static void quicksort(List<Double> arr) {
        quicksortHelp(arr, 0, arr.size() - 1);
    }

    private static void quicksortHelp(List<Double> arr, int low, int high) {
        if (low < high) {
            int partitionIndex = partition(arr, high, low, high);

            quicksortHelp(arr, low, partitionIndex - 1);
            quicksortHelp(arr, partitionIndex + 1, high);
        }
    }

    private static int partition(List<Double> arr, int pivotIndex, int low, int high) {
        int partitionIndex = low;

        for (int i = low; i < high; i++) {
            if (arr.get(i) < arr.get(pivotIndex)) {
                swap(arr, i, partitionIndex);
                partitionIndex++;
            }
        }

        swap(arr, high, partitionIndex);

        return partitionIndex;
    }

    private static void swap(List<Double> arr, int i, int j) {
        double old = arr.get(i);

        arr.set(i, arr.get(j));
        arr.set(j, old);
    }
}
