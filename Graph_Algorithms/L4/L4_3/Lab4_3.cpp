// Mellau Márk-Máté , 523/1
// Labor 4 , 3-es feladat
// mmim2055

#include <iostream>
#include <vector>
#include <set>
#include <fstream>
#include <queue>

const char* input = "Lab4_3.in";

using namespace std;

int LabelToID(int label) {
	return label - 1;
}

int IDToLabel(int ID) {
	return ID + 1;
}

void ReadGraph(int& n, int& m, vector<vector<pair<int, int>>>& graph) {
	ifstream f(input);
	if (f.fail()) {
		cout << "ERROR: Input file does not exists !";
		return;
	}
	f >> n >> m ;
	graph.resize(n);
	for (int i = 0; i < m; i++) {
		int u, v, value;
		f >> u >> v >> value;
		graph[LabelToID(u)].push_back(make_pair(LabelToID(v), value));
	}
}

void Dijkstra(int startID, int n, vector<vector<pair<int, int>>>& graph, int*& distance, int*& parent) {

	distance = new int[n];
	parent = new int[n];
	for (int i = 0; i < n; i++) {
		distance[i] = INT_MAX;
		parent[i] = -1;
	}

	set<pair<int, int>> unknown;
	distance[startID] = 0;
	unknown.insert(make_pair(0, startID));
	while (!unknown.empty()) {
		pair <int, int> u = *(unknown.begin());
		unknown.erase(u);
		int nearestNode = u.second;
		for (int i = 0; i < graph[nearestNode].size(); i++) {
			int k = graph[nearestNode][i].first;
			if (distance[k] > distance[nearestNode] + graph[nearestNode][i].second) {
				distance[k] = distance[nearestNode] + graph[nearestNode][i].second;
				parent[k] = nearestNode;
				unknown.insert(make_pair(distance[k], k));
			}
		}
	}
}

int SPFA(int startID, int n, vector<vector<pair<int, int>>>& graph, int*& distance, int*& parent) {

	queue<int> q;
	q.push(startID);

	bool* inQueue = new bool[n];
	int* updated = new int[n];			//how many times a node has been updated
	distance = new int[n];
	parent = new int[n];
	for (int i = 0; i < n; i++) {
		distance[i] = INT_MAX;
		parent[i] = -1;
		inQueue[i] = false;
		updated[i] = 0;
	}
	distance[startID] = 0;
	inQueue[startID] = true;
	int u;
	while (!q.empty()) {
		u = q.front();
		q.pop();
		inQueue[u] = false;
		for (int i = 0; i < graph[u].size(); i++) {
			int v = graph[u][i].first;
			int value = graph[u][i].second;
			if (distance[v] > distance[u] + value) {
				distance[v] = distance[u] + value;
				parent[v] = u;
				if (!inQueue[v]) {
					q.push(v);
					inQueue[v] = true;
					updated[v] += 1;
					if (updated[v] >= n) {
						delete[] inQueue;
						delete[] updated;
						return -1;
					}
				}
			}

		}
	}

	delete[] inQueue;
	delete[] updated;
	return 0;

}

void PrinShortestPaths(int node, int* distance, int* parent) {
	if (parent[node] == -1) {
		cout << "Length of the shortest path to " << IDToLabel(node) << ": *can't reach it*" << endl;
		cout << "Shortest Path to node " << IDToLabel(node) << ": *can't reach it*" << endl;
		cout << endl;
	}
	else {
		vector<int> path;
		int x = node;
		path.push_back(x);
		while (parent[x] != -1) {
			x = parent[x];
			path.push_back(x);
		}

		cout << "Length of the shortest path to " << IDToLabel(node) << ": " << distance[node] << endl;
		cout << "Shortest Path to node " << IDToLabel(node) << ":  ";
		for (int i = path.size() - 1; i >= 0; i--) {
			cout << IDToLabel(path[i]) << " ";
		}
		cout << endl << endl;

	}
}

int Johnson(int n, int m, vector<vector<pair<int, int>>> graph) {
	int* distance; 
	int* parent; 

	graph.resize(n + 1); 
	for (int i = 0; i < n; i++) {
		graph[n].push_back(make_pair(i, 0)); 
	}
	int retval = SPFA(n, n + 1, graph, distance, parent);
	if (retval == -1) {
		cout << "\nA graf tartalmaz negativ kort \n\n"; 
		return -1;
	}

	for (int i = 0; i < n + 1; i++) {
		for (int j = 0; j < graph[i].size(); j++) {
			graph[i][j].second = graph[i][j].second + distance[i] - distance[j]; 
		}
	}
	graph.pop_back(); 

	for (int i = 0; i < n; i++) {
		Dijkstra(i, n, graph, distance, parent);

		cout << "\n\nShortest Paths from: " << IDToLabel(i) <<endl<<endl; 
		for (int k = 0; k < i; k++) {
			PrinShortestPaths(k, distance, parent);
		}

		for (int k = i + 1; k < n; k++) {
			PrinShortestPaths(k, distance, parent);
		}
		cout << endl; 
	}
}

int main() {
	int n,  m; 

	vector<vector<pair<int, int>>> graph; 

	ReadGraph(n, m, graph); 

	Johnson(n, m, graph); 

	return 0; 
}