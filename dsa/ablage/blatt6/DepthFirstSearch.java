package graph;

import java.io.FileNotFoundException;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class DepthFirstSearch {
	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		DepthFirstSearch tmp = new DepthFirstSearch ();
		
		OffsetArray graph = new OffsetArray();
		
		graph.read_from_file("graph.txt");
		
		// DFS, maximal erreichbare Knotenanzahl ermitteln
		TreeMap<Integer, Integer> reachables = new TreeMap<Integer, Integer>();
		for (int i = 0; i < graph.n; i++) {
			reachables.put(i, graph.get_num_reachable_vertices(i));
		}						
		System.out.println(sortByValue(reachables).toString());
		
		// BFS, Abstände ermitteln
		TreeMap<Integer, Integer> distance_map = new TreeMap<Integer, Integer>();
		int[] distances = graph.get_distances(0);
		for (int i = 0; i < graph.n; i++) {
			distance_map.put(i, distances[i]);
		}		
		System.out.println(sortByValue(distance_map).toString());
		
			
		//graph.print();

	}
	
	static Map sortByValue(Map map) {
		List list = new LinkedList(map.entrySet());
		Collections.sort(list, new Comparator() {
			public int compare(Object o1, Object o2) {
				return ((Comparable) ((Map.Entry) (o1)).getValue())
						.compareTo(((Map.Entry) (o2)).getValue());
			}
		});

		Map result = new LinkedHashMap();
		for (Iterator it = list.iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry)it.next();
			result.put(entry.getKey(), entry.getValue());
		}
		return result;
	} 
}




