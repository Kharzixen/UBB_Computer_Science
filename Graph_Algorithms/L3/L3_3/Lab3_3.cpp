//Mellau Mark-Mate , 523/1
//mmim2055
//Laboe 3 / 3-as feladat 

#include <iostream>
#include <fstream>
#include <vector> 
#include <stack>

using namespace std;

const char* input = "Lab3_3.in"; 

int nrOfComponents = 0;
int* components;

int LabelToID(int label) {
    return label - 1;
}

int IDToLabel(int id) {
    return id + 1;
}

void ReadGraph(int& n, int& m , vector<vector<int>> &graph) {
    ifstream f(input);
    f >> n >> m;
    graph.resize(n);
    for (int i = 0; i < m; i++) {
        int node1, node2;
        f >> node1 >> node2;
        graph[LabelToID(node1)].push_back(LabelToID(node2));
    }
}

void DFS_SCC(int currNode, vector<vector<int>> &graph ,  int &time , int* &discovered , int*& low , bool* &onnAStack , stack<int> &notAssigned) {
    
    time++; 
    discovered[currNode] = time; 
    low[currNode] = time; 
    onnAStack[currNode] = true; 
    notAssigned.push(currNode); 

    for (vector<int>::iterator i = graph[currNode].begin(); i < graph[currNode].end(); i++) {
        int w = (*i); 
        if (discovered[w] == -1) {
            DFS_SCC(w, graph , time, discovered, low, onnAStack, notAssigned); 
            low[currNode] = min(low[currNode], low[w]); 
        }
        else {
            if (discovered[w] < discovered[currNode] && onnAStack[w]) {
                low[currNode] = min(low[currNode], discovered[w]); 
            }
        }
    }

    if (low[currNode] == discovered[currNode]) {
        nrOfComponents++;  
        while (!notAssigned.empty() && discovered[notAssigned.top()] >= discovered[currNode]) {
            components[notAssigned.top()] = nrOfComponents;
            onnAStack[notAssigned.top()] = false;
            notAssigned.pop(); 
        }
    }
    
}

void PrintSCC(int n){
    for (int i = 1; i <= nrOfComponents; i++) {
        cout << i << ": "; 
        for (int j = 0; j < n; j++) {
            if (components[j] == i) {
                cout << IDToLabel(j) << " "; 
            }
        }
        cout << endl;
    }

}

int main()
{
    int n, m; 
    vector<vector<int>> graph;  
    ReadGraph(n, m, graph); 
    int* discovered = new int[n]; 
    int* low = new int[n]; 
    bool* onnAStack = new bool[n]; 
    components = new int[n];
    stack<int> notAssigned; 
    int time = 0; 

    for (int i = 0; i < n; i++) {
        components[i] = 0; 
        discovered[i] = -1; 
        low[i] = -1; 
        onnAStack[i] = false; 
    }
   
    DFS_SCC(0, graph, time, discovered, low, onnAStack, notAssigned); 

    PrintSCC(n); 

    return 0; 
}

