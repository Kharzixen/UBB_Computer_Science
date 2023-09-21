//Mellau Márk-Máté, 523/1
//mmim2055
//Lab6 , greedy módszer az elö path megkeresésére , aztán 2opt


#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <cfloat>

using namespace std;

const char* input = "Lab6.in";

vector<vector<double>> distances;

struct point {
    int x;
    int y;
};

double EuclideanDistance(point p1, point p2) {
    return sqrt((p2.x - p1.x)* (p2.x - p1.x) + (p2.y - p1.y)* (p2.y - p1.y));
}

void ReadGraph(vector<point> &cities)  {
    ifstream f(input);
    while (!f.eof()) {
        int no,x, y;
        point p;
        f >> no >> x >> y;
        p.x = x;
        p.y = y;
        cities.push_back(p);
    }
    int n = cities.size();
    distances.resize(n);
    for (int i = 0; i < n; i++) {
        distances[i].resize(n);
    }

    for (int i = 0; i < cities.size(); i++) {
        for (int j = 0; j < cities.size(); j++) {
            distances[i][j] = EuclideanDistance(cities[i], cities[j]);
        }
    }
}

void PrintDistances() {
    int n = distances.size();
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            cout << distances[i][j] << " "; 
        }
        cout << endl;
    }
}

vector<int> GreedyApproach(double& pathSum) {
    int n = distances.size();
    bool *isVisited = new bool[n];
    for (int i = 0; i < n; i++) {
        isVisited[i] = false;
    }
    vector<int> path;
    int i = 0;
    pathSum = 0;
    while (i != n-1) {
        isVisited[i] = true;
        path.push_back(i);
        float min = DBL_MAX;
        int next;
        for (int j = 0; j < n; j++) {
            if (!isVisited[j] && distances[i][j] < min) {
                min = distances[i][j];
                next = j;
            }
        }
        pathSum += min;
        i = next;
    }
    path.push_back(n - 1);
    pathSum += distances[n - 1][0];
    delete[] isVisited;
    return path;
}

double DistanceOnPath(vector<int> path, int i, int j) {
    double dist = 0;
    int prior = path[i];
    for (int k = i+1; k <= j; k++) {
        dist += distances[prior][path[k]];
        prior = path[k];
    }
    return dist;
}

vector<int> Opt2_2(double& pathSum, vector<int>& path) {
    int itr = 0;
    int n = path.size();
    bool isImprovement = true;
    vector<int> newPath;
again2:
    for (int i = 0; i < n - 2; i++) {
        for (int j = i+1; j < n - 1; j++) {
            newPath = path;
            reverse(newPath.begin() + i + 1, newPath.begin() + j +1);
            double newDistance = DistanceOnPath(newPath, 0, path.size() - 1);
            if (newDistance < pathSum) {
                path = newPath;
                pathSum = newDistance;
                goto again2;
            }
        }
    }
    return path;
}


int main()
{
    double pathSum = 0;
    vector<point> cities;
    ReadGraph(cities);

    vector<int> path = GreedyApproach(pathSum);
    cout << "Greedy path sum: " << pathSum << endl;
    cout << "\n2Opt running...\n\n";
    path = Opt2_2(pathSum, path);
    cout <<"2Opt path sum:" << pathSum <<endl<<endl;
    cout << "Path: \n";
    for (int i = 0; i < path.size(); i++) {
        cout << path[i] << " ";
    }
    return 0;
}
