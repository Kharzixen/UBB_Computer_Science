// Mellau Márk-Máté , 523/1
// Labor 4 , 1-es feladat
// mmim2055

#include <iostream>
#include <vector>
#include <set>
#include <fstream>

const char* input = "Lab4_1.in"; 

using namespace std;

int LabelToID(int label) {
	return label - 1;
}

int IDToLabel(int ID) {
	return ID + 1;
}

void ReadGraph(int &s , int& n, int& m, vector<vector<pair<int, int>>>& graph) {
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

void Dijkstra(int startID, int n, vector<vector<pair<int, int>>>& graph , int* & distance , int* & parent) {

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

		cout << "Length of the shortest path to " << IDToLabel(node) << ": "<< distance[node] << endl;
		cout << "Shortest Path to node " << IDToLabel(node) << ":  " ;
		for (int i = path.size() - 1; i >= 0; i--) {
			cout << IDToLabel(path[i]) << " "; 
		}
		cout << endl << endl ; 

	}
}

int main()
{
	int n, m , s;
	vector<vector<pair<int, int>>> graph;
	ReadGraph(s , n, m, graph);
	int* distance = NULL;
	int* parent = NULL; 

	Dijkstra(s, n, graph, distance, parent); 

	for (int i = 0; i < s; i++) {
		PrinShortestPaths(i, distance, parent);
	}

	for (int i = s+1 ; i < n; i++) {
		PrinShortestPaths(i, distance, parent);
	}

	delete[] distance; 
	delete[] parent;

	return 0; 
}
