//Mellau Márk-Máté , 523/1
//Labor 2 , 1-es feladat


#include <iostream>
#include <fstream>
#include <vector>
#include <stack>
#include <queue>

using namespace std; 

//input file
const char* input = "graph.in"; 

int LabelToID(int label) {
    return label - 1; 
}

int IDToLabel(int id) {
    return id + 1; 
}

vector<vector<int>> GetAdjListFromFile(int &n , int &m) {
    ifstream f(input); 
    f >> n >> m; 
    vector<vector<int>> graph; 
    graph.resize(n); 
    int node1, node2; 
    for (int i = 0; i < m; i++) {
        f >> node1 >> node2; 
        graph[LabelToID(node1)].push_back(LabelToID(node2)); 
        graph[LabelToID(node2)].push_back(LabelToID(node1));
    }
    return graph; 
}

vector<int> DFS(int startID , int n, vector<vector<int>> graph) {

    if (startID<0 or startID>n)
        throw "ERROR: Incorrect starting node !";

    vector<int> dfsList; 
    bool* visited = new bool[n] {0}; 
    stack<int> stack; 
    stack.push(startID);

    while (!stack.empty()) {
        int curr = stack.top(); 
        stack.pop(); 

        if (!visited[curr]) {
            dfsList.push_back(curr);
            visited[curr] = 1;
        }

        for (vector<int>::reverse_iterator it = graph[curr].rbegin(); it < graph[curr].rend(); it++) {
            if (!visited[*it])
                stack.push(*it);
        }
    }

    delete[] visited; 
    return dfsList; 
}

vector<int> BFS(int startID, int n, vector<vector<int>> graph) {
    if (startID<0 or startID>n)
        throw "ERROR: Incorrect starting node !";

    vector<int> bfsList;
    bool* visited = new bool[n] {0};
    queue<int> q;
    q.push(startID);

    while (!q.empty()) {
        int curr = q.front();
        q.pop();

        if (!visited[curr]) {
            bfsList.push_back(curr);
            visited[curr] = 1;
        }

        for (vector<int>::iterator it = graph[curr].begin(); it < graph[curr].end(); it++) {
            if (!visited[*it])
                q.push(*it);
        }
    }

    delete[] visited;
    return bfsList;
}

void PrintBfsList(vector<int> bfsList) {
    cout << "\nSzelessegi bejaras: "; 
    for (vector<int>::iterator it = bfsList.begin(); it < bfsList.end(); it++) {
        cout << IDToLabel(*it)<<" ";
    }
    cout << endl; 
}

void PrintDfsList(vector<int> dfsList) {
    cout << "\nMelysegi bejaras: ";
    for (vector<int>::iterator it = dfsList.begin(); it < dfsList.end(); it++) {
        cout << IDToLabel(*it)<<" ";
    }
    cout << endl;
}


int main()
{
    int n, m; 
    vector<vector<int>> graph = GetAdjListFromFile(n, m); 
    vector<int> dfsList = DFS(LabelToID(1), n, graph); 
    vector<int> bfsList = BFS(LabelToID(1), n, graph); 

    PrintDfsList(dfsList); 
    PrintBfsList(bfsList); 

}

