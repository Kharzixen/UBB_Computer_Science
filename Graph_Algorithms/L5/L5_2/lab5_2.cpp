//Mellau Márk-Máté , 523/1
//Labor 5 , 2-es feladat
//Push-Relabel Algorithm

#include <iostream>
#include <vector>
#include <queue>
#include <fstream>

using namespace std; 

const char* input = "lab5_2.in"; 
const char* output = "lab5_2.out"; 

vector<vector<int>> graph; 
vector<vector<int>> originalGraph; 
vector<vector<pair<int, int>>> flowMatrix; 

int LabelToID(int node) {
    return node - 1; 
}

int IDToLabel(int nodeID) {
    return nodeID + 1; 
}

void ReadGraph(int& n, int& s, int& t) {
    ifstream f(input);
    f >> n >> s >> t;
    s = LabelToID(s); 
    t = LabelToID(t);
    graph.resize(n);
    flowMatrix.resize(n); 
    originalGraph.resize(n); 
    for (int i = 0; i < n; i++) {
        flowMatrix[i].resize(n); 
        originalGraph[i].resize(n); 
    }

    int u, v, value; 
    while (!f.eof()) {
        f >> u >> v >> value; 
        u = LabelToID(u); 
        v = LabelToID(v);
        //undirected graph -> we can go back to previous node for correction 
        // (??)
        originalGraph[u][v] = 1; 
        graph[u].push_back(v); 
        graph[v].push_back(u); 
        flowMatrix[u][v].first = value;     //maximum capacity of (u,v) vertex 
        flowMatrix[u][v].second = 0;        //used capacity of (u,v) vertex
    }

}

void Init(int n , int s , int*& height, int*& x) {
    //x -> "overflow value" of a node;
    for (int i = 0; i < n; i++) {
        height[i] = 0; 
        x[i] = 0;
    }
    height[s] = n; 
    for (int i = 0; i < graph[s].size(); i++) {
        int v = graph[s][i];
        flowMatrix[s][v].second = flowMatrix[s][v].first; 
        x[v] = flowMatrix[s][v].second;  
    }
}

//pushing the overflow value trough (u,v) edge
void Push(int u, int v , int* &x , int capacity) {
    int m = min(x[u], capacity); 
    if (originalGraph[u][v] == 1) {
        flowMatrix[u][v].second += m;
    }
    else {
        flowMatrix[v][u].second -= m; 
    }
    x[u] -= m;
    x[v] += m; 

}

//increasing the height of u
void Relabel(int u , int* &height) {
    int m = INT_MAX; 
    for (int i = 0; i < graph[u].size(); i++) {
        int v = graph[u][i]; 
        m = min(m, height[v]);
    }
    height[u] = m + 1; 
}

bool isActive(int node , int* x) {
    return (x[node] > 0);
}

bool checkNeighbours(int u, int* height) {
    for (int i = 0; i < graph[u].size(); i++) {
        int v = graph[u][i]; 

        if (height[u] > height[v]) {
            return false;
        }
    }
    return true;
}

int GetMaxFlow(int n, int s, int t) {
    int* x = new int[n]; 
    int *height = new int[n]; 
    Init(n, s, height, x);

    cout << endl;

next:
    while (true) {

        for (int i = 0; i < n ; i++) {
            int u = i; 
            for (int j = 0; j < graph[u].size(); j++) {
                int v = graph[u][j];
                int capacity;

                if (originalGraph[u][v] == 1) {
                    capacity = flowMatrix[u][v].first - flowMatrix[u][v].second;
                }

                else {
                    capacity = flowMatrix[v][u].second;
                }
                if ((u != s) && (u != t) && (height[u] == (height[v] + 1)) && isActive(u, x) && capacity != 0) {
                    Push(u, v, x , capacity); 
                    goto next;      //disgusting , i know
                }
                
            }

            if (u != s && u != t && isActive(u, x) && checkNeighbours(u , height)) {
                Relabel(u, height);
                goto next;          //disgusting , i know
            }
        }
        break; 
    }

    int maxFlow = x[t]; 
    delete[] x;
    delete[] height;
    return maxFlow;
}


int main()
{
    int n, s, t;
    ReadGraph(n, s, t);

    ofstream f(output);
    f << GetMaxFlow(n, s, t);
}

