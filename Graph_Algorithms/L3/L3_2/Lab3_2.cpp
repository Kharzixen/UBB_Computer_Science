//Mellau Mark-Mate , 523/1
//mmim2055
//Labor 3 / 2-es feladat


#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>

using namespace std; 

const char* input = "Lab3_2.in"; 

class Vertex {
public:
	int node1; 
	int node2; 
	int value; 
	Vertex(int u, int v, int value){
		node1 = u; 
		node2 = v; 
		this->value = value; 
	}
};

class UnionFind {
private:
	int* repr; 
	int* nrOfNodes; 

	int Find(int u) {
		if (u != repr[u]) u = Find(repr[u]); 
		return u; 
	}

	void Union(int u , int v) {
		if (nrOfNodes[u] >= nrOfNodes[v]) {
			repr[u] = repr[v]; 
			nrOfNodes[u] += nrOfNodes[v]; 
		}
		else {
			repr[v] = repr[u]; 
			nrOfNodes[v] += nrOfNodes[u];
		}
	}
public:

	UnionFind(int n) {
		repr = new int[n]; 
		nrOfNodes = new int[n]; 
		for (int i = 0; i < n; i++) {
			repr[i] = i; 
			nrOfNodes[i] = 1; 
		}
	}

	bool IsAvailable(int u, int v) {
		return Find(u) == Find(v); 
	}

	void Connect(int u, int v) {
		int x = Find(u); 
		int y = Find(v); 
		if (x != y) Union(x, y);
	}
	
	~UnionFind()
	{
		delete[] repr; 
		delete[] nrOfNodes; 
	}
};

int LabelToID(int label) {
	return label - 1;
}

int IDToLabel(int id) {
	return id + 1;
}

void ReadGraph(int &n , int &m , vector<Vertex> &vertices) {
	ifstream f(input); 
	f >> n >> m; 
	for (int i = 0; i < m; i++) {
		int u, v, value; 
		f >> u >> v >> value;
		vertices.push_back(Vertex(LabelToID(u), LabelToID(v), value));
	}

}

void MSTKruskal(int n, vector<Vertex> vertices, int &mstValue , vector<pair<int , int>> &mst) {
	UnionFind uf(n);
	mstValue = 0;
	for (vector<Vertex>::iterator i = vertices.begin(); i < vertices.end(); i++) {
		if (uf.IsAvailable((*i).node1, (*i).node2) == 0) {
			mstValue += (*i).value;
			mst.push_back(make_pair((*i).node1, (*i).node2));
			uf.Connect((*i).node1, (*i).node2);
		}
	}
}

void PrintMST(int mstValue, vector<pair<int, int>> mst) {
	cout << "MST value: " << mstValue << endl << "MST vertices: " << endl ; 
	for (vector<pair<int, int>>::iterator i = mst.begin(); i < mst.end(); i++) {
		cout << IDToLabel((*i).first) << " " << IDToLabel((*i).second) << endl;
	}
}


int main()
{
	int n, m; 
	vector<Vertex> vertices; 
	ReadGraph(n , m , vertices); 

	sort(vertices.begin(), vertices.end(), 
		[](const Vertex& a , const Vertex&b) {
			return a.value < b.value; 
		}
	); 

	vector<pair<int, int>> mst; 
	int mstValue = 0; 

	MSTKruskal(n, vertices, mstValue, mst); 

	PrintMST(mstValue, mst); 

	return 0; 
}
