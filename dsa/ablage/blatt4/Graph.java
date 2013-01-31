//package blatt04graph;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.Arrays;

/**
 * Uebung 4, Problem 4 offset-array storage of a graph.
 * 
 * @author Frank Heyen, Stephan Hilb, Fabian Hartkopf
 * 
 */
public class Graph {
	// Knotenanzahl
	public int n;
	// Kantenanzahl
	public int m;

	// [x][0] : offset
	// [x][1] : xPos
	// [x][2] : yPos
	private int[][] vertices;
	// [x][0] : source
	// [x][1] : target
	// [x][2] : cost
	private int[][] edges;
	
	private boolean[] reachable;
	private boolean[] completed;
	/**
	 * Searches for vertices that are reachable from the start-vertex.
	 * 
	 * @param startVertex
	 *            vertex from which to start the search
	 *
	 * Die erreichbaren Knoten sind in this.reachable markiert	 
	 */
	public void depthFirstSearch(int startVertex) {
		if (this.completed[startVertex])
			return;
		if (this.reachable[startVertex]) {
			System.out.println("Zyklus entdeckt!");
			return;
		}
		this.reachable[startVertex] = true;

		for (int i = vertices[startVertex][0]; i < vertices[startVertex + 1][0]; i++) {
			if (!this.reachable[this.edges[i][1]])
				depthFirstSearch(this.edges[i][1]);
		}

		this.completed[startVertex] = true;
	}

	public int[] get_reachable_from(int vertex) {
		this.reachable = new boolean[this.n];
		this.depthFirstSearch(vertex);

		int counter = 0;
		for (int i = 0; i < this.n; i++)
			if (this.reachable[i])
				counter++;
		int[] reachable = new int[counter];
		for (int i = 0,j = 0; i < this.n; i++) {
			if (this.reachable[i]){
				reachable[j] = i;
				j++;
			}
		}
		return reachable;
	}

	public void read_from_file(String path) {
		// read graph from file
		Scanner scanner = null;
		try {
			scanner = new Scanner(new File(path));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

 		this.n = scanner.nextInt();
		this.m = scanner.nextInt();
		this.reachable = new boolean[this.n];
		this.completed = new boolean[this.n];

		// array of vertices contains offset, xPos and yPos
		this.vertices = new int[this.n + 1][3];

		for (int i = 0; i < this.n; i++) {
			// offset has to be set later, -1 signifies no occurrence
			this.vertices[i][0] = -1;
			this.vertices[i][1] = scanner.nextInt();
			this.vertices[i][2] = scanner.nextInt();
		}

		// array of edges contains sourceID, targetID and cost
		this.edges = new int[this.m][3];

		for (int i = 0; i < this.m; i++) {
			this.edges[i][0] = scanner.nextInt();
			this.edges[i][1] = scanner.nextInt();
			this.edges[i][2] = scanner.nextInt();
		}


		// Reimplementiert, weil die frühere Methode Knoten übersprungen hätte, die keine ausgehenden Ecken haben
		
		int[] counter = new int[this.n + 1];
		for (int i = 0; i < this.m; i++)
			counter[this.edges[i][0]]++;
		int j = 0;
		for (int i = 0; i <= this.n; i++) {
			this.vertices[i][0] = j;
			j += counter[i];
		}
		
		scanner.close();
	}

	public void print() {
		// testing
		System.out.println("edges (index | source | target | cost)");
		for (int i = 0; i < 25; i++) {
			System.out.printf("%03d | %12d | %12d | %12d \n", i, this.edges[i][0],
					this.edges[i][1], this.edges[i][2]);
		}
		System.out.println("\nvertices (index | offset | xPos | yPos)");
		for (int i = 0; i < 10; i++) {
			System.out.printf("%03d | %12d | %12d | %12d \n", i,
					this.vertices[i][0], this.vertices[i][1], this.vertices[i][2]);
		}
		for (int i = this.n-20; i <= this.n; i++) {
			System.out.printf("%03d | %12d | %12d | %12d \n", i,
					this.vertices[i][0], this.vertices[i][1], this.vertices[i][2]);
		}
		System.out.println(this.m);

	}
	
	
	/**
	 * Reads graph from a file and performs depth first search on it.
	 * 
	 * @param args
	 *            no arguments are regarded
	 */
	public static void main(String[] args) {

		String path = "../graph.txt";
		
		Graph graph = new Graph();

		graph.read_from_file(path);

		graph.print();

		int[][] reachable = new int[graph.n][2];
		int[][] reachables = new int[graph.n][graph.m];

		for (int i = 0; i < graph.n; i++) {
			int[] tmp = graph.get_reachable_from(i);
			reachables[i] = tmp;
			reachable[i][0] = i;
			reachable[i][1] = tmp.length;
		}
		
		Arrays.sort(reachable, new java.util.Comparator<int[]>() {
			public int compare(int[] a, int[] b) {
				return -(a[1] - b[1]);
			}
		});
		Arrays.sort(reachables, new java.util.Comparator<int[]>() {
			public int compare(int[] a, int[] b) {
				return -(a.length - b.length);
			}
		});
		
		for (int i = 0; i < 10; i++) {
			System.out.println(reachable[i][0] + ": " + reachables[i].length);
			System.out.println(Arrays.toString(reachables[i]));
		}

	}


}
