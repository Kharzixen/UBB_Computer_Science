//Mellau Márk-Máté , 523/1
//Labor 2 , 3-as feladat


#include <iostream>
#include <fstream>
#include <vector>
#include <stack>

using namespace std;

//input file
const char* input = "graph.in";

int LabelToID(int label) {
    return label - 1;
}

int IDToLabel(int id) {
    return id + 1;
}

vector<vector<int>> GetAdjListFromFile(int& n, int& m) {
    ifstream f(input);
    f >> n >> m;
    vector<vector<int>> graph;
    graph.resize(n);
    int node1, node2;
    for (int i = 0; i < m; i++) {
        f >> node1 >> node2;
        graph[LabelToID(node1)].push_back(LabelToID(node2));
    }
    return graph;
}

bool DFSCycle(int startID, int n, vector<vector<int>> graph) {

    if (startID<0 or startID>n)
        throw "ERROR: Incorrect starting node !";

    //-1 feher
    //0 szurke
    //1 fekete

    int* color = new int[n] {-1}; 
    for (int i = 0; i < n; i++)
        color[i] = -1; 

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
                else if (color[*it] == 0) {
                    return true;
                }
            }
        }
        else if (color[curr] == 0) {
            stack.pop();
            color[curr] = 1;
        }
        else stack.pop(); 
    }

    delete[] color; 
    return false; 
}

int main() {
    int n, m; 
    vector<vector<int>>graph = GetAdjListFromFile(n, m); 
    if (DFSCycle(LabelToID(1) , n , graph)) cout << "igen";
    else cout << "nem"; 
    return 0; 
}