import java.io.FileReader;
import java.io.BufferedReader;
import java.util.Scanner;
import java.io.IOException;
//import java.util.Arrays;
import java.util.Random;

public class Quicksort {
	private Random generator = new Random();
	
	public int[] sort (int[] A, int a, int b) {
		if (b - a <= 0)
			return A;

		int p = a + this.generator.nextInt(b - a + 1);
		p = partition(A, a, b, p);

		sort(A, a, p - 1);
		sort(A, p + 1, b);
		return A;
	}
	
	// In-place rearrangieren von einem Teilbereich von A in drei Bereiche, um lästige variable-sized Arrays zu vermeiden
	public int partition (int[] A, int a, int b, int p) {
		int p_value = A[p];
		swap(A, p, b);
		int offset = a;
		for (int i = a; i < b; i++) {
			if (A[i] < p_value) {
				swap(A, i, offset);
				offset++;
			}
		}
		swap(A, b, offset);
		return offset;
	}
	
	// Array wird per-reference übermittelt
	public void swap (int[] A, int i, int j) {
		int tmp = A[i];
		A[i] = A[j];
		A[j] = tmp;
	}


	public static void main (String[] args) throws IOException {
		int n = Integer.parseInt(args[1]);
		int[] A = new int[n];

		Scanner s = new Scanner(new BufferedReader(new FileReader(args[0])));
		
		int i = 0;
		while (i < n) {
			A[i] = s.nextInt();
			i++;
		}
		Quicksort sorter = new Quicksort();

		A = sorter.sort(A, 0, A.length - 1);

		//System.out.println(java.util.Arrays.toString(A));
	}
}
