import java.io.FileReader;
import java.io.BufferedReader;
import java.util.Scanner;
import java.io.IOException;

public class GraphOffsetArray {
	int[] source;
	int[] target;
	int[] cost;
	int[] offset;

	public 
	
	public static void main (String[] args) throws IOException {
		int n = Integer.parseInt(args[1]);
		int[] A = new int[n];

		Scanner s = new Scanner(new BufferedReader(new FileReader(args[0])));
		
		int i = 0;
		while (i < n) {
			A[i] = s.nextInt();
			i++;
		}
		
		Heapsort sorter = new Heapsort();

		A = sorter.sort(A);
		//System.out.println(java.util.Arrays.toString(A));
	}
}
