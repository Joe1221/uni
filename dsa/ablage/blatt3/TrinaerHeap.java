import java.util.Arrays;

// Implementierung als Min-Heap
public class TrinaerHeap {
	private int size;
	private int[] heap;

	private int get_parent(int index) {
		return (index - 1) / 3;
	}

	private void swap(int i, int j) {
		int tmp = this.heap[i];
		this.heap[i] = this.heap[j];
		this.heap[j] = tmp;
	}

	public TrinaerHeap(int size) {
		// Initialisiere mit fester Größe
		this.size = size;
		this.heap = new int[this.size];
	}

	public void create(int[] A) {
		this.heap = Arrays.copyOf(A, this.size);
		// Heapify von unten auf alle Elemente aufrufen
		for (int i = this.size - 1; i >= 0; i--) {
			this.heapify(i);
		}
	}

	public void insert(int value) {
		this.size++;
		// Wäre blöd, wenn wir mehr Elemente einfügen, als das Array beherbergen kann
		assert this.size <= this.heap.length;

		// Füge neues Element am Schluss an
		int i = this.size - 1;
		this.heap[i] = value;
		i = this.get_parent(i);
		
		// Rufe immer wieder heapify auf das Elternelement auf, bis das Wurzelelement
		// erreicht wurde, oder keine Vertauschung gemacht wurde
		while (heapify(i) && i != 0) {
			i = this.get_parent(i);	
		}
	}

	public int remove_min() {
		int min = this.heap[0];
		// Setze das letzte Element an den Anfang
		this.swap(0, this.size - 1);
		this.size--;
		
		// Wurzel-Heapify
		heapify(0);
		
		return min;
	}

	// Gibt false zurück, falls nichts getauscht wurde
	public boolean heapify(int parent) {
		// Hiermit stellen wir elegant sicher, dass später in der Scleife
		// nur vorhande Kindsknoten verglichen werden (der letzte Eltern-Knoten 
		// muss ja nicht 3 Stück haben und die letzten Kindsknoten garkeine)
		int child_id_max = Math.min(this.size - 1, 3 * parent + 3);

		int item_min = parent;
		// Suche das kleinste Element unter den Kind-Elementen
		for (int i = 3 * parent + 1; i <= child_id_max; i++) {
			if (heap[i] < heap[item_min])
				item_min = i;
		}
		// Gab es ein kleineres Kind-Element?
		if (item_min != parent) {
			this.swap(parent, item_min);
			this.heapify(item_min);
			return true;
		} else {
			return false;
		}
	}
}
