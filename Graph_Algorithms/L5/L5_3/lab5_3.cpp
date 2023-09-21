//Mellau Márk-Máté , 523/1
//mmim2055
//Labor 5 , 3-as feladat

#include <iostream>
#include <vector>
#include <fstream>
#include <stack>

// task->csomopont modszer 

using namespace std;

const char* input = "lab5_3.in";
const char* output = "lab5_3.out";

int LabelToID(int label) {
	return label - 1; 
}

int	IDToLabel(int id) {
	return id+1;
}
void ReadGraph(int& n, int*& times, vector<vector<int>>& graph , vector<vector<int>> &tgraph)
{
	ifstream f(input);

	f >> n;
	times = new int[n];
	for (int i = 0; i < n; i++)
		f >> times[i];

	graph.resize(n );
	tgraph.resize(n); 
	int u, v, value;
	while (!f.eof()) {
		f >> u >> v;
		u = LabelToID(u);
		v = LabelToID(v);
		graph[u].push_back(v);
		tgraph[v].push_back(u); 
	}
}

void DFSTopoSort(int startID, int*& color, vector<int>& topoList, vector<vector<int>> graph) {

	if (startID < 0)
		throw "ERROR: Incorrect starting node !";
	stack<int> topo;
	stack<int> stack;
	stack.push(startID);

	while (!stack.empty()) {
		int curr = stack.top();

		if (color[curr] == -1) {
			color[curr] = 0;
			for (vector<int>::reverse_iterator it = graph[curr].rbegin(); it < graph[curr].rend(); it++) {
				if (color[*it] == -1) {
					stack.push(*it);
				}
			}
		}
		else if (color[curr] == 0) {
			stack.pop();
			color[curr] = 1;
			topo.push(curr);
		}
		else
			stack.pop();
	}

	while (!topo.empty()) {
		topoList.push_back(topo.top());
		topo.pop(); 
	}
}

void PrintOutput(int n , int* t0min, int* t1min, int* t0max, int* t1max , int* a) {
	ofstream f(output);
	for (int i = 0; i < n; i++) {
		if (t0min[i] == t0max[i] && t1min[i] == t1max[i]) {
			f << IDToLabel(i) << " ";
		}
	}
	f << endl ; 
	for (int i = 0; i < n; i++) {
		f << IDToLabel(i) << " " << a[i] << " " << t0min[i] << " " << t1min[i] << " " << t0max[i] << " " << t1max[i] << endl;
	}

}

void CPM_CSUCS(int n, int* a, vector<int> topo, vector<vector<int>> graph , vector<vector<int>> tgraph)
{
	int* t0min = new int[n] {};
	int* t1min = new int[n] {};
	int* t0max = new int[n] {};
	int* t1max = new int[n] {};

	for (int i = 0; i < n; i++) {
		t0min[i] = -1; 
		t1min[i] = -1; 
		t0max[i] = INT_MAX;
		t1max[i] = INT_MAX; 
	}

	t0min[topo[0]] = 0;
	t1min[topo[0]] = a[topo[0]];
	for (int i = 1; i < n; i++)
	{
		int u = topo[i];
		for (int j = 0; j < tgraph[u].size(); j++)
		{
			int v = tgraph[u][j];
			t0min[u] = max(t0min[u], t1min[v]);
		}
		t1min[u] = t0min[u] + a[u];
	}
	t1max[topo[n-1]] = t1min[topo[n-1]];
	t0max[topo[n-1]] = t1max[topo[n-1]] - a[topo[n-1]];


	for (int i = n - 2; i >= 0; i--)
	{
		int u = topo[i];
		for (int j = 0; j < graph[u].size(); j++)
		{
			int v = graph[u][j];
			t1max[u] = min(t1max[u], t0max[v]);
		}
		t0max[u] = t1max[u] - a[u];

	}

	PrintOutput(n, t0min, t1min, t0max, t1max, a);

	delete[] t0min, t0max, t1min, t1max;

}

int main()
{
	int n = 0, *times;
	vector<vector<int>> graph , tgraph;

	ReadGraph(n, times, graph , tgraph);

	vector<int> topo;

	int* color = new int[n] {-1};
	for (int i = 0; i < n; i++)
		color[i] = -1;

	DFSTopoSort(0, color, topo, graph);

	CPM_CSUCS(n, times, topo, graph , tgraph);

	delete[] times;
	delete[] color;

	return 0;
}

