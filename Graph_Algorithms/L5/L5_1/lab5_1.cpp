//Mellau Márk-Máté , 523/1
//mmim2055
//Labor 5 , 1-es feladat


#include <iostream>
#include <vector>
#include <fstream>
#include <queue>

using namespace std; 

const char* input = "lab5_1.in";
const char* output = "lab5_1.out";

vector<vector<pair<int, int>>> flowMatrix;

int LabelToID(int node) {
    return node - 1; 
}

int IDToLabel(int nodeID) {
    return nodeID + 1; 
}

void ReadGraph(int& n, int& s, int& t, vector<vector<int>>& graph) {
    ifstream f(input);
    f >> n >> s >> t;
    s = LabelToID(s); 
    t = LabelToID(t);
    graph.resize(n);
    flowMatrix.resize(n); 
    for (int i = 0; i < n; i++) {
        flowMatrix[i].resize(n); 
    }

    int u, v, value; 
    while (!f.eof()) {
        f >> u >> v >> value; 
        u = LabelToID(u); 
        v = LabelToID(v);
        //undirected graph -> we can go back to previous node for correction 
        // (??)
        graph[u].push_back(v); 
        graph[v].push_back(u); 
        flowMatrix[u][v].first = value;     //maximum capacity of (u,v) vertex 
        flowMatrix[u][v].second = 0;        //used capacity of (u,v) vertex
    }

}

int flowOnPath(int* parent, int s, int t) {

    int minCapacity = INT_MAX; 

    if (parent[t] == -1) {
        return -1; 
    }

    //calculating the flow of the path , which is the min capacity 
    int u = t;
    while (u != s) {
        int v = u; 
        u = parent[u]; 
        if (minCapacity > (flowMatrix[u][v].first - flowMatrix[u][v].second)) {
            minCapacity = flowMatrix[u][v].first - flowMatrix[u][v].second; 
        }
    }

    //updateing the "graph"
    u = t; 
    while (u != s) {
        int v = u; 
        u = parent[u]; 
        flowMatrix[u][v].second += minCapacity; 
        flowMatrix[v][u].second -= minCapacity; 
    }

    return minCapacity;
}

int bfsRetFlow(int n, int s, int t, vector<vector<int>> graph) {
    int* parent; 
    bool* visited; 

    parent = new int[n]; 
    visited = new bool[n]; 

    for (int i = 0; i < n; i++) {
        parent[i] = -1; 
        visited[i] = false; 
    }

    queue<int> q; 
    q.push(s); 
    visited[s] = true; 
    while (!q.empty()) {
        int u = q.front(); 
        for (int i = 0; i < graph[u].size(); i++) {
            int v = graph[u][i]; 
            if ((flowMatrix[u][v].first - flowMatrix[u][v].second) > 0 && !visited[v]) {
                visited[v] = true; 
                parent[v] = u; 
                if (v == t) {
                    return flowOnPath(parent, s, t); 
                }
                q.push(v); 
            }
        }
        q.pop(); 
    }
    delete[] parent; 
    delete[] visited; 

    return -1; 
}
vector<vector<int>> GetMinimumCut(int n , int s , vector<vector<int>> graph) {
    bool* visited;
    vector<vector<int>> minCut; 

    //minCut[0] - left of the cut
    //minCut[1] - rigth of the cut

    minCut.resize(2);

    visited = new bool[n];

    for (int i = 0; i < n; i++) {
        visited[i] = false;
    }

    queue<int> q;
    q.push(s);
    visited[s] = true;
    minCut[0].push_back(s);
    while (!q.empty()) {
        int u = q.front();
        for (int i = 0; i < graph[u].size(); i++) {
            int v = graph[u][i];
            if ((flowMatrix[u][v].first - flowMatrix[u][v].second) > 0 && !visited[v]) {
                visited[v] = true;
                q.push(v);
                minCut[0].push_back(v);
            }
        }
        q.pop();
    }

    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            minCut[1].push_back(i);
        }
    }
    delete[] visited;
    return minCut;
}

void PrintFlowMinCut(vector<vector<int>> minCut, int maxFlow) {
    ofstream f(output);
    f << maxFlow << endl; 
    for (int i = 0; i < minCut[0].size(); i++) {
        f << IDToLabel(minCut[0][i]) << " ";
    }
    f << "; "; 
    for (int i = 0; i < minCut[1].size(); i++) {
        f << IDToLabel(minCut[1][i]) << " ";
    }
}

int main()
{
    vector<vector<int>> graph; 
    vector<vector<int>> minCut; 
    int n, s, t;
    ReadGraph(n, s, t, graph); 

    int maxFlow = 0, currFlow = bfsRetFlow(n, s, t, graph); 
    while (currFlow != -1) {
        maxFlow += currFlow;
        currFlow = bfsRetFlow(n, s, t, graph);
    }
    
    minCut = GetMinimumCut(n, s ,graph); 

    PrintFlowMinCut(minCut, maxFlow);

    return 0; 
}


