#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <iomanip>
#include <ctime>
#include <map>
#include <queue>
#include <cmath>

using namespace std;

class Point {
public:
    int nr;
    int x;
    int y;

    Point(int a, int b, int c) {
        nr = a;
        x = b;
        y = c;
    }
};

double EuclideanDistance(int x1, int y1, int x2, int y2) {
    return sqrt(pow((x2 - x1),2) + pow((y2 - y1),2));
}

vector<vector<double>> ReadData(string input, int& size) {
    vector<vector<double>> distanceMatrix;
    ifstream f;
    string delimiter = " ";
    string token;

    f.open(input);
    string line;
    int S = 0;
    vector<Point> points;

    while (!f.eof()) {
        S++;
        getline(f,line);
        int pos = 0;
        vector<int> partsOfPoint;
        while ((pos = static_cast<int>(line.find(delimiter))) != string::npos) {
            token = line.substr(0, pos);
            partsOfPoint.push_back(stoi(token));
            line.erase(0, pos + delimiter.length());
        }
        partsOfPoint.push_back(stoi(line));
        Point p = Point(partsOfPoint[0], partsOfPoint[1], partsOfPoint[2]);
        points.push_back(p);
    }

    distanceMatrix.resize(S + 2);
    for (int i = 0; i <= S; i++) {
        distanceMatrix[i].resize(S + 2);
    }
    
    for (int i = 1; i <= S; i++) {
        for (int j = 1; j <= S; j++) {
            if (i != j) {
                distanceMatrix[i][j] = EuclideanDistance(points[i-1].x, points[i-1].y, points[j-1].x, points[j-1].y);
            }
            else {
                distanceMatrix[i][j] = 0;
            }
        }
    }

    f.close();
    size = S;
    return distanceMatrix;
}

vector<int> GetInitialSolution(int size) {
    //greedy maybe
    vector<int> solution;
    for (int i = 1; i <= size; i++) {
        solution.push_back(i);
    }
    return solution;
}

double Fitness(vector<int> solution, vector<vector<double>> &distanceMatrix) {
    double fitness = 0;
    for (int i = 1; i < solution.size(); i++) {
        fitness += distanceMatrix[solution[i - 1]][solution[i]];
    }
    fitness += distanceMatrix[solution[solution.size()-1]][solution.size() - 2];
    return fitness;
}

vector<int> ExecuteSimulatedAnnealingAlgorithm(vector<int> initialSolution, vector<vector<double>> distanceMatrix, long long maxIteration,long double temperature, double alpha) {
    cout << "------Execute Simulated Annealing... ------\n" << endl << endl;
    vector<int> currentSolution = initialSolution;
    vector<int> bestSolution = initialSolution;
    double fitness =  Fitness(currentSolution, distanceMatrix);
    int iteration = 0;
    long double currTemperature = temperature;
    int size = currentSolution.size();
    while (iteration <= maxIteration && currTemperature >= 0.002) {
        if (iteration % (maxIteration / 5) == 0) {
            cout << "Current temperature = " << currTemperature << " " << "Current iteration = " << iteration << endl;
        }
        iteration++; 
        vector<int> candidate = currentSolution;
        int i = rand() % size;
        int j = rand() % size + 1;
        if (i > j) {
            swap(i, j);
        }
        reverse(candidate.begin() + i, candidate.begin() + j);
        if (Fitness(candidate, distanceMatrix) < Fitness(currentSolution, distanceMatrix)) {
            currentSolution = candidate;
            if (Fitness(candidate, distanceMatrix) < Fitness(bestSolution, distanceMatrix)) {
                bestSolution = candidate;
            }
        }
        else {
            double r = ((double)rand() / (RAND_MAX)) + 1;
            double probability = numeric_limits<double>::epsilon();
            probability = pow(probability, (Fitness(candidate, distanceMatrix) - Fitness(currentSolution, distanceMatrix) / currTemperature));
        }
        currTemperature = temperature/(1 + alpha * iteration);
    }
    cout << "\n\n------Annealing terminated------\n\n";
    return bestSolution;
}

// ACO global minimum search

double TransitionFunction(int r, int s, int nrOfNodes ,vector<bool> &visited, vector<vector<pair<double, double>>> &pheromonMatrix, double beta) {
    long double sum = 0;
    for (int i = 1; i <= nrOfNodes; i++) {
        if (!visited[i]) {
            sum += (pheromonMatrix[r][i].first * pow(1 / (pheromonMatrix[r][i].second), beta));
        }
    }
    return (pheromonMatrix[r][s].first * pow(1 / (pheromonMatrix[r][s].second), beta)) / (sum);
    

}

vector<int> ACOAlgorithm(int nrOfAnts, int size, int maxIter, vector<vector<double>>& distanceMatrix) {
    cout << "\n------ Executing AS Optimalization... ------\n\n";
    
    double alpha = 0.5;
    vector<vector<pair<double, double>>> pheromonMatrix;
    pheromonMatrix.resize(size + 1);
    //initialized pheromon map
    for (int i = 0; i <= size; i++) {
        pheromonMatrix[i].resize(size + 1);
        for (int j = 0; j <= size; j++) {
            pheromonMatrix[i][j] = make_pair(100, distanceMatrix[i][j]);
        }
    }
    
    vector<int> startingCity;
    startingCity.resize(nrOfAnts);
    vector<bool> antAssigned;
    antAssigned.resize(size + 1);
    for (int antID = 0; antID < nrOfAnts; antID++) {
        int city = rand() % size + 1;
        while (!antAssigned[city]) {
            startingCity[antID] = city;
            antAssigned[city] = true;
        }
    }

    for (int iter = 0; iter < maxIter; iter++) {
        vector<vector<int>> allPaths;
        vector<double> pathFitness;

        //all ants create a path
        for (int antID = 0; antID < nrOfAnts; antID++) {
            cout << "Iteration: " << iter << " " <<"AntID: "<<antID<< endl;
            //path of current ant
            vector<int> path;
            //visited vector
            vector<bool> visited;
            visited.resize(size + 1);
            queue<int> q;
            q.push(startingCity[antID]);
            while (!q.empty()) {
                int currCity = q.front();
                q.pop();
                path.push_back(currCity);
                visited[currCity] = true;
                //next city:
                priority_queue <pair<double, int>, vector<pair<double, int>>, greater<pair<double, int>> > pq;
                for (int next = 1; next <= size; next++) {
                    if (!visited[next]) {
                        pq.push(make_pair(TransitionFunction(currCity, next, size, visited, pheromonMatrix, 2), next));
                    }
                }
                if (!pq.empty()) {
                    double random = (double) rand() / RAND_MAX;
                    double sum = 0;
                    pair<double, int> curr;
                    while (random > sum) {
                        curr = pq.top();
                        pq.pop();
                        sum += curr.first;
                    }
                    q.push(curr.second);
                }
            }
            allPaths.push_back(path);
            pathFitness.push_back(Fitness(path, distanceMatrix));
        }

        for (int i = 0; i <= size; i++) {
            for (int j = 0; j <= size; j++) {
                pheromonMatrix[i][j].first *= alpha;
            }
        }

        for (vector<int> path : allPaths) {
            for (int i = 1; i < path.size(); i++) {
                pheromonMatrix[path[i]][path[i - 1]].first += 1 / Fitness(path, distanceMatrix);
                pheromonMatrix[path[i-1]][path[i]].first += 1 / Fitness(path, distanceMatrix);
            }
        }

    }


    vector<int> path;
    //visited vector
    vector<bool> visited;
    //one last traversal for path
    int antID = 0;
    //visited vector
    path.clear();
    visited.clear();
    queue<int> q;
    visited.resize(size + 1);
    q.push(startingCity[antID]);
    while (!q.empty()) {
        int currCity = q.front();
        q.pop();
        path.push_back(currCity);
        visited[currCity] = true;
        //next city:
        priority_queue<pair<double, int>> pq;
        for (int next = 1; next <= size; next++) {
            if (!visited[next]) {
                pq.push(make_pair(TransitionFunction(currCity, next, size, visited, pheromonMatrix, 10), next));
            }
        }
        if (!pq.empty()) {
            q.push(pq.top().second);
        }
    }
    cout << "\n------ AS Optimalization terminated! ------\n\n";
    return path;
}
  

int main()
{
    srand(time(0));
    int size = 0;
    vector<vector<double>> distanceMatrix = ReadData("input.txt", size);
    
    vector<int> initialSolution = GetInitialSolution(size);
    vector<int> annealingBest = ExecuteSimulatedAnnealingAlgorithm(initialSolution, distanceMatrix, 10000,3000, 0.99);
    cout <<"Initial solution's fitness value: " << setprecision(10) << Fitness(initialSolution, distanceMatrix) << endl;
    cout <<"Annealing best solution's fitness value: " << setprecision(10) << Fitness(annealingBest, distanceMatrix) << endl;
    cout << "\n\n\n";
    vector<int> bestACO = ACOAlgorithm(20, size,100, distanceMatrix);

    cout << "Solution's fitness value with ACO:" << Fitness(bestACO, distanceMatrix)<<endl<<endl;

}
