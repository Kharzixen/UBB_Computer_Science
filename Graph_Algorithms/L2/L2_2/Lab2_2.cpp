//Mellau Mark-Mate , 523/1
//mmim2055
//labor 2 , 2-es feladat 

#include <iostream>
#include <fstream>
#include <vector>
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

vector<vector<int>> GetAdjListFromFile(int& n, int& m , int &startID , int &k) {
    ifstream f(input);
    f >> n >> m;
    f >> startID >> k;
    startID = LabelToID(startID); 
    vector<vector<int>> graph;
    graph.resize(n);
    int node1, node2;
    for (int i = 0; i < m; i++) {
        f >> node1 >> node2;
        graph[LabelToID(node1)].push_back(LabelToID(node2));
    }
    return graph;
}

vector<int> BFS_k(int startID, int k ,  int n, vector<vector<int>> graph) {
    if (startID<0 or startID>n)
        throw "ERROR: Incorrect starting node !";

    vector<int> KacquaintanceList;
    bool* visited = new bool[n] {0};
    int* lvl = new int[n] {0}; 
    queue<int> q;
    q.push(startID);

    while (!q.empty()) {
        int curr = q.front();
        q.pop();

        if (lvl[curr] > k)
            break;

        if (!visited[curr]) {
            visited[curr] = 1;
            if (lvl[curr] == k) {
                KacquaintanceList.push_back(curr);
            }
        }

        for (vector<int>::iterator it = graph[curr].begin(); it < graph[curr].end(); it++) {
            if (!visited[*it])
            {
                q.push(*it);
               if((lvl[*it] == 0 || lvl[*it] > lvl[curr]+1) && *it != 0) 
                   lvl[*it] = lvl[curr] + 1; 
            }
            
        }

    }

    delete[] visited;
    delete[] lvl; 
    return KacquaintanceList;
}

void PrintBfs_kList(vector<int> list) {
    cout << "\nK-ad rendu ismerosok: ";
    for (vector<int>::iterator it = list.begin(); it < list.end(); it++) {
        cout << IDToLabel(*it) << " ";
    }
    cout << endl;
}

int main() {
    int n, m, startID, k; 
    vector<vector<int>> graph = GetAdjListFromFile(n, m, startID, k); 
    PrintBfs_kList( BFS_k(startID, k, n,  graph)); 

    return 0; 
}
