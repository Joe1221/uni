package graph;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.util.LinkedList;
import java.util.Scanner;
import java.util.Arrays;
import java.util.Queue;

public class OffsetArray {
	public int n;
	public int m;
	// Vertex data
	private int[] offset;
	private int[] dfsnum;
	private int dfscounter;
	private int[] compnum;
	private int compcounter;
	private int[] dist;
	// Edge data
	private int[] target;
	private int[] cost;
	// Edge classification: 1=tree, 2=forward, 3=backward, 4=cross
	private int[] classification;
	
	public int get_num_reachable_vertices (int vertex) {
		this.depth_first_search(vertex);
		return this.dfscounter;
	}
	
	public int[] get_distances (int vertex) {
		breadth_first_search(vertex);
		return this.dist;
	}
	
	public void breadth_first_search (int vertex) {
		Queue<Integer> bfsqueue = new LinkedList<Integer>();
		
		dist = new int[n];
		for (int i = 0; i < n; i++)
			dist[i] = -1;
		bfsqueue.offer(vertex);
		dist[vertex] = 0;
		while (!bfsqueue.isEmpty()) {
			int v = bfsqueue.poll();
			for (int i = offset[v]; i < offset[v + 1]; i++) {
				if (dist[target[i]] == -1) {					
					dist[target[i]] = dist[v] + 1;
					bfsqueue.offer(target[i]);
				}
			}
		}
	}
	
	
	public void depth_first_search (int vertex) {
		this.dfsnum = new int[n];
		this.dfscounter = 0;
		this.compnum = new int[n];
		this.compcounter = 0;
		this.classification = new int[m];
		this.dfs(vertex); 
	}
	
	private void dfs (int vertex) {
		dfsnum[vertex] = dfscounter++;
		for (int i = this.offset[vertex]; i < this.offset[vertex + 1]; i++) {
			if (dfsnum[target[i]] == 0) {
				this.classification[i] = 1;			// Tree edge
				this.dfs(target[i]);
			} else{
				if (dfsnum[vertex] <= dfsnum[target[i]]) {
					this.classification[i] = 2;		// Forward edge
				} else {
					if (compnum[vertex] < compnum[target[i]]) {
						this.classification[i] = 3;	// Backward edge
					} else {
						this.classification[i] = 4;	// Cross edge
					}
				}
			}
		}
		this.compnum[vertex] = this.compcounter++;
	}	
	
	public void read_from_file (String filename) throws FileNotFoundException {
		Scanner s = new Scanner(new BufferedReader(new FileReader(filename)));
		
		this.n = s.nextInt();
		this.m = s.nextInt();
		s.nextLine(); // Finish line
		
		for (int i = 0; i < this.n; i++) {
			// do something with vertex data
			s.nextLine();			
		}
		
		// initialize arrays
		this.offset = new int[this.n+1];
		this.target = new int[this.m];
		this.cost = new int[this.m];
		
		// counter for offset array
		int[] edge_counter = new int[this.n];
		for (int i = 0; i < this.m; i++) {
			// read edge data
			edge_counter[s.nextInt()]++;
			this.target[i] = s.nextInt();
			this.cost[i] = s.nextInt();
		}
		// fill offset array
		for (int i = 1; i <= this.n ; i++) {
			this.offset[i] = this.offset[i-1] + edge_counter[i-1];			
		}
	}
	
	public void print () {
		System.out.println(Arrays.toString(this.classification));
	}
}
