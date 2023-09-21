// Mellau Márk-Máté , 523/1
// Labor 4 , 2-es feladat
// mmim2055

#include <iostream>
#include <vector>
#include <queue>
#include <fstream>

const char* input = "Lab4_2.in";

using namespace std;

int LabelToID(int label) {
	return label - 1;
}

int IDToLabel(int ID) {
	return ID + 1;
}

void ReadGraph(int& s, int& n, int& m, vector<vector<pair<int, int>>>& graph) {
	ifstream f(input);
	if (f.fail()) {
		cout << "ERROR: Input file does not exists !";
		return;
	}
	f >> n >> m >> s;
	s = LabelToID(s);
	graph.resize(n);
	for (int i = 0; i < m; i++) {
		int u, v, value;
		f >> u >> v >> value;
		graph[LabelToID(u)].push_back(make_pair(LabelToID(v), value));
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

int main()
{
	int n, m, s;
	vector<vector<pair<int, int>>> graph;
	ReadGraph(s, n, m, graph);
	int* distance = NULL;
	int* parent = NULL;

	if (SPFA(s, n, graph, distance, parent) == 0)
	{
		for (int i = 0; i < s; i++) {
			PrinShortestPaths(i, distance, parent);
		}

		for (int i = s + 1; i < n; i++) {
			PrinShortestPaths(i, distance, parent);
		}
	}
	else {
		cout << "\nVan negativ kor a grafban\n\n"; 
	}

	delete[] distance;
	delete[] parent;

	return 0;
}
