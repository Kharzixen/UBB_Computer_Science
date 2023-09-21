// Mellau Márk-Máté , 523/1
// Labor 4 , 4-es feladat
// mmim2055

#include <iostream>
#include <fstream>
#include <vector>

const char* input = "Lab4_4.in";

using namespace std;

int LabelToID(int label) {
	return label - 1;
}

int IDToLabel(int ID) {
	return ID + 1;
}

void ReadGraph(int& n, int& from , int& to , int**& graph) {
	ifstream f(input);
	if (f.fail()) {
		cout << "ERROR: Input file does not exists !";
		return;
	}

	f >> n >> from >> to; 
	from = LabelToID(from); 
	to = LabelToID(to); 

	graph = new int* [n]; 
	for (int i = 0; i < n; i++) {
		graph[i] = new int[n]; 
	}

	int val; 
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			f >> val;
			graph[i][j] = val;
		}
	}
}

void RFW(int n, int** graph , int**distance , int **parent) {
	for (int i = 0; i < n; i++) {
		for (int j =0; j < n; j++) {
			if (graph[i][j] == 0) {
				distance[i][j] = INT_MAX; 
			}
			else {
				distance[i][j] = graph[i][j]; 
			}
		}
	}

	for (int i = 0; i < n; i++) {
		distance[i][i] = 0; 
	}

	for (int k = 0; k < n; k++) {
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				if (distance[i][k] == INT_MAX || distance[k][j] == INT_MAX) continue;

				if (distance[i][j] > (distance[i][k] + distance[k][j])) {
					distance[i][j] = distance[i][k] + distance[k][j]; 
					parent[i][j] = parent[i][k]; 
				}
			}
		}
	}
}

void InitParentDistance(int n,int **graph ,  int**& parent, int**& distance) {
	parent = new int* [n]; 
	distance = new int* [n]; 
	for (int i = 0; i < n; i++) {
		parent[i] = new int[n]; 
		distance[i] = new int[n]; 
	}

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			if (i == j) {
				parent[i][j] = 0; 
			}
			else if(graph[i][j] == 0) {
				parent[i][j] = -1; 
			}
			else {
				parent[i][j] = j; 
			}
		}
	}
}

void PrintDistanceMatrix(int n, int** distance) {
	cout << "\nDistance Matrix:\n\n"; 

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			if (distance[i][j] == INT_MAX) {
				cout << 0 << " "; 
			}
			else {
				cout << distance[i][j] << " "; 
			}
		}
		cout << endl; 
	}
}

void PrintPath(int from, int to, int** parent) {
	cout << "\n\nPath from " << IDToLabel(from) << " to " << IDToLabel(to) << ": ";
	vector<int> path; 
	if (parent[from][to] == -1) {
		cout << "*Path doesn't exist*\n"; 
	}
	else {
		int aux = from; 
		path.push_back(aux); 
		while (aux != to) {
			aux = parent[aux][to]; 
			path.push_back(aux); 
		}
		for (int i = 0; i < path.size(); i++) {
			cout << IDToLabel(path[i]) << " "; 
		}
	}
	cout << endl << endl; 
}
int main()
{
	int n , from , to; 
	int** graph;
	int** parent; 
	int** distance; 

	ReadGraph(n, from , to , graph);

	InitParentDistance(n, graph, parent, distance); 

	RFW(n, graph, distance, parent);

	PrintDistanceMatrix(n , distance); 

	PrintPath(from, to, parent); 

	for (int i = 1; i < n; i++) {
		delete[] graph[i]; 
		delete[] parent[i]; 
		delete[] distance[i]; 
	}

	delete[] parent; 
	delete[] distance; 
	delete[] graph; 
	return 0;
}
