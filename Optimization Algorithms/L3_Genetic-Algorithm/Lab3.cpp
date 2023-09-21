#include <iostream>
#include <vector>
#include <cmath>
#include <ctime>
#include <algorithm>
#include <fstream>

using namespace std;

int populationSize = 100;
int maxIteration = 500;
double probCross = 0.8;
double probMutation = 0.06;

double x_min = -5;
double x_max = 5;

class Individual {
public:
    vector<double> x;
    int rank;
    double crowdingDistance = 0;
    int domination_count;
    vector<int> dominates;
    
    Individual( vector<double> x) {
        this->x = x;
        rank = 0;
        domination_count = 0;
    }

    bool operator < (const Individual& other) {
        return crowdingDistance < other.crowdingDistance;
    }
};


double Schaffer1(vector<double> x) {
    return pow(x.front(), 2);
}

double Schaffer2(vector<double> x) {
    return pow((x.front() - 2), 2);
}

double Kursawe1(vector<double> x) {
    double sum = 0;
    for (int i = 0; i < 2; i++) {
        sum += -10 * pow(numeric_limits<double>::epsilon(), -0.2 * sqrt(pow(x[i], 2) + pow(x[i + 1], 2)));
    }
    return sum;
}

double Kursawe2(vector<double> x) {
    double sum = 0;
    for (int i = 0; i < 3; i++) {
        sum += pow(abs(x[i]), 0.8) + 5 * sin(pow(x[i], 3));
    }
    return sum;
}

double GetRandBetween(double fMin, double fMax)
{
    double f = (double)rand() / RAND_MAX;
    return fMin + f * (fMax - fMin);
}

bool Equals(Individual individual1, Individual individual2) {
    return (individual1.x == individual2.x);
}

bool isInPopulation(Individual i, vector<Individual> population) {
    for (Individual aux : population) {
        if (Equals(aux, i)) {
            return true;
        }
    }
    return false;
}

vector<Individual> GetInitialPopulation(double x_min, double x_max, int populationSize, int dim) {
    vector<Individual> population;
    while(population.size() != populationSize) {
        vector<double> genes;
        for (int j = 0; j < dim; j++) {
            double aux = GetRandBetween(x_min, x_max);
            genes.push_back(aux);
        }
        Individual i = Individual(genes);
        if (!isInPopulation(i, population)){
            population.push_back(Individual(genes));
        }

        if (populationSize == population.size()) {
            break;
        }
    }
    return population;
}

bool Dominates(Individual p, Individual q) {
    pair<double, double> pRes, qRes;
    pRes.first = Kursawe1(p.x);
    qRes.first = Kursawe1(q.x);
    pRes.second = Kursawe2(p.x);
    qRes.second = Kursawe2(q.x);

    return ((pRes.first <= qRes.first && pRes.second <= qRes.second) && (pRes.first < qRes.first || pRes.second < qRes.second));
}

pair<double, double> GetCoordinates(Individual p) {
    pair<double, double> pRes;
    pRes.first = Kursawe1(p.x);
    pRes.second = Kursawe2(p.x);
    return pRes;
}

Individual TournamentSelection(vector<Individual> &parents) {
    int i = rand() % parents.size();
    int j = rand() % parents.size();
    while(i == j) {
        j = rand() % parents.size();
    }
    Individual best = parents[i];
    if (parents[j].rank < best.rank || (parents[j].rank == best.rank && parents[j].crowdingDistance > best.crowdingDistance)) {
        return parents[j];
    }

    return best;
}

pair<Individual, Individual> Cross(Individual parent1, Individual parent2) {
    double alpha = GetRandBetween(0, 1);
    vector<double> gene;
    //child1
    for (int i = 0; i < parent1.x.size(); i++) {
        double x = alpha * (parent1.x[i]) + (1 - alpha) * parent2.x[i];
        gene.push_back(x);
    }
    Individual i1 = Individual(gene);

    gene.clear();
    //child2
    for (int i = 0; i < parent1.x.size(); i++) {
        double x = (1-alpha) * (parent1.x[i]) + (alpha) * parent2.x[i];
        gene.push_back(x);
    }
    Individual i2 = Individual(gene);

    return make_pair(i1, i2);

}

void Mutation(Individual& i) {
    double mutationSpace = 0.1;
    for (int j = 0; j < i.x.size(); j++) {
        if (GetRandBetween(0, 1) < probMutation) {
            double mutation = GetRandBetween(mutationSpace*x_min, mutationSpace*x_max);
            double aux = i.x[j] + mutation;
            while (aux < x_min || aux > x_max) {
                double mutation = GetRandBetween(mutationSpace * x_min, mutationSpace * x_max);
                aux = i.x[j] + mutation;
            }
            i.x[j] = aux;
        }
    }

}

vector<Individual> GetNextGeneration(vector<Individual> &parents) {
    vector<Individual> nextGeneration;
    while (nextGeneration.size() < parents.size()) {
        Individual p1 = TournamentSelection(parents);
        Individual p2 = TournamentSelection(parents);
        while (Equals(p1, p2)) {
            p2 = TournamentSelection(parents);
        }
        //cross + mutation
        if (GetRandBetween(0, 1) < probCross) {
            pair<Individual, Individual> children = Cross(p1, p2);
            Mutation(children.first);
            Mutation(children.second);
            if (!isInPopulation(children.first, nextGeneration) && !isInPopulation(children.first, parents)) {
                nextGeneration.push_back(children.first);
            }
            if (!isInPopulation(children.second, nextGeneration) && !isInPopulation(children.second, parents)) {
                nextGeneration.push_back(children.second);
            }
        }
        else {
            pair<Individual, Individual> children = make_pair(p1, p2);
            Mutation(children.first);
            Mutation(children.second);

            //elettartam eseten kiveheto
            if (!isInPopulation(children.first, nextGeneration) && !isInPopulation(children.first, parents)) {
                nextGeneration.push_back(children.first);
            }
            if (!isInPopulation(children.second, nextGeneration) && !isInPopulation(children.second, parents)) {
                nextGeneration.push_back(children.second);
            }
        }
    }
    return nextGeneration;
}

int NonDominatedSort(vector<Individual>& population) {
    vector<Individual> front;
    int curr_rank = 1;
    for(int i=0; i<population.size(); i++){
        for(int j=0; j<population.size(); j++){
            if (i==j) {
                continue;
            }

            if (Dominates(population[i], population[j])) {
                population[i].dominates.push_back(j);
            }
            else {
                if (Dominates(population[j], population[i])) {
                    population[i].domination_count += 1;
                }
            }
        }

        if (population[i].domination_count == 0) {
            population[i].rank = curr_rank;
            front.push_back(population[i]);
        }
    }

    while (front.size() != 0) {
        curr_rank++;
        vector<Individual> nextFront;
        for (int i = 0; i < front.size(); i++) {
            for (int j = 0; j < front[i].dominates.size(); j++) {
                int curr = front[i].dominates[j];
                population[curr].domination_count--;
                if (population[curr].domination_count == 0 && population[curr].rank == 0) {
                    population[curr].rank = curr_rank;
                    nextFront.push_back(population[curr]);
                }
            }
        }
        front = nextFront;
    }
    return curr_rank;
}

void SortByCoordinate(vector<Individual> &population, int dim) {
    for (int i = 0; i < population.size(); i++) {
        for (int j = 0; j < population.size(); j++) {
            if (dim == 1) {
                if (GetCoordinates(population[i]).first < GetCoordinates(population[j]).first) {
                    Individual tmp = population[i];
                    population[i] = population[j];
                    population[j] = tmp;
                }
            }
            else if (dim == 2) {
                if (GetCoordinates(population[i]).second < GetCoordinates(population[j]).second) {
                    Individual tmp = population[i];
                    population[i] = population[j];
                    population[j] = tmp;
                }
            }
        }
    }
}

void CalculateCrowdDistance(vector<Individual>& population) {
    SortByCoordinate(population, 1);
    population[0].crowdingDistance = INFINITY;
    population[population.size() - 1].crowdingDistance = INFINITY;
    for (int i = 1; i < population.size()-1; i++) {
        double distance = GetCoordinates(population[i + 1]).first - GetCoordinates(population[i - 1]).first;
        population[i].crowdingDistance += distance / (GetCoordinates(population[population.size() - 1]).first - GetCoordinates(population[0]).first);
    }

    SortByCoordinate(population, 2);
    population[0].crowdingDistance = INFINITY;
    population[population.size() - 1].crowdingDistance = INFINITY;
    for (int i = 1; i < population.size() - 1; i++) {
        double distance = GetCoordinates(population[i + 1]).second - GetCoordinates(population[i - 1]).second;
        population[i].crowdingDistance += distance / (GetCoordinates(population[population.size() - 1]).second - GetCoordinates(population[0]).second);
    }
}

int main()
{
    srand(time(0));


    vector<Individual> parents = GetInitialPopulation(x_min, x_max, populationSize, 3);
    vector<Individual> children;
    vector<vector<Individual>> individualsByFront;
    for (int i = 0; i < maxIteration; i++) {
        cout << i << endl;
        vector<Individual> allPopulation = parents;
        for (Individual& i : children) {
            allPopulation.push_back(i);
        }
        int maxRank = NonDominatedSort(allPopulation);
        CalculateCrowdDistance(allPopulation);
        parents.clear();

        individualsByFront.clear();
        individualsByFront.resize(maxRank + 1);
        for(Individual i: allPopulation){
            individualsByFront[i.rank].push_back(i);
        }
        for (int j = 1; j <= maxRank; j++) {
            sort(individualsByFront[j].begin(), individualsByFront[j].end());
        }


        while (parents.size() != populationSize) {
            if (parents.size() == populationSize) {
                break;
            }
            for (int j = 1; j <= maxRank; j++) {
                if (parents.size() == populationSize) {
                    break;
                }
                for (Individual ind : individualsByFront[j]) {
                    ind.rank = 0;
                    ind.domination_count = 0;
                    ind.dominates.clear();
                    parents.push_back(ind);                   
                    if (parents.size() == populationSize) {
                        break;
                    }
                }
            }
        }

        children = GetNextGeneration(parents);
    }

    ofstream f("output2.txt");
    
    for (int i = 0; i < children.size(); i++) {
        f << GetCoordinates(children[i]).first << " " << GetCoordinates(children[i]).second << endl;
    }
    return 0;
}
