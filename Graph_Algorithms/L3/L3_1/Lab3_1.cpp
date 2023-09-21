//Mellau Mark-Mate , 523/1
//mmim2055
//523/1 , Labor 3/1-es feladat

#include <iostream>
#include <fstream>
#include <fstream> 
#include <vector>
#include <queue>

#define inf INT_MAX

const char* input = "Lab3_1.in"; 

using namespace std; 

int LabelToID(int label) {
	return label - 1; 
}

int IDToLabel(int ID) {
	return ID + 1; 
}

void ReadGraph(int& n, int& m , vector<vector<pair<int , int>>> &graph){
	ifstream f(input); 
	if (f.fail()) {
		cout << "ERROR: Input file does not exists !"; 
		return; 
	}
	f >> n >> m; 
	graph.resize(n); 
	for (int i = 0; i < m; i++) {
		int u, v, value; 
		f >> u >> v >> value; 
		graph[LabelToID(u)].push_back(make_pair(LabelToID(v), value)); 
		graph[LabelToID(v)].push_back(make_pair(LabelToID(u), value));
	}
}

void WriteGraph(int n, vector<vector<pair<int, int>>> graph) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < graph[i].size(); j++) {
			cout << graph[i][j].first << " ";
		}
		cout << endl;
	}
}

void printVertices(int n , int* mst) {
	cout << "Vertices of mst: " << endl; 
	for (int i = 0; i < n; i++)
	{
		if (mst[i] != -1) cout << min(IDToLabel(mst[i]) , IDToLabel(i)) << " " << max(IDToLabel(mst[i]),IDToLabel(i)) << endl;
	}
}

int* MST_Prim(int s, int n, vector<vector<pair<int, int>>> graph, int& mstvalue) {
	priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> notIncluded;
	int* distance = new int[n];
	int* parent = new int[n];
	bool* inTree = new bool[n];

	for (int i = 0; i < n; i++) {
		distance[i] = inf;
		parent[i] = -1;
		inTree[i] = 0;
	}

	distance[s] = 0;
	notIncluded.push(make_pair(0, s));

	while (!notIncluded.empty()) {
		int u = notIncluded.top().second;
		notIncluded.pop();

		if (u != s) {
			inTree[u] = 1;
			inTree[parent[u]] = 1;
		}

		for (vector<pair<int, int>>::iterator i = graph[u].begin(); i < graph[u].end(); i++) {
			int v = (*i).first;
			int value = (*i).second;
			if (!inTree[v] && distance[v] > value) {
				distance[v] = (*i).second;
				parent[v] = u;
				notIncluded.push(make_pair(value, v));
			}
		}

	}

	mstvalue = 0;
	for (int i = 0; i < n; i++) {
		mstvalue += distance[i];
	}
	delete[] distance;
	delete[] inTree;
	return parent;
}

int main()
{
	int n = 0, m = 0;

	vector<vector<pair<int, int>>> graph; 

	ReadGraph(n, m, graph);

	//WriteGraph(n, graph);

	int mstvalue = 0; 
	int*mst = MST_Prim(0, n, graph , mstvalue); 

	cout << "MST value: " << mstvalue <<endl ; 
	printVertices(n , mst); 
	return 0; 

}
