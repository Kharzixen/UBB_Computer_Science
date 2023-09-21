#include <iostream>
#include <vector>
#include <random>

int n = 5;
int populationSize = 20;

double x_min = -2;
double x_max = 2;

double eps = 0.01;

using namespace std;

double Rosenbrock(vector<double> x) {
    double fx = 0;
    for (int i = 0; i < n - 1; i++) {
        fx += (100 * pow((x[i + 1] - pow(x[i], 2)), 2) + pow((x[i] - 1), 2));
    }
    return fx;
}

class Individual {
public:
    vector<double> x;
    double sigma;
    Individual(vector<double> x) {
        this->x = x;
        sigma = 1;
    }

    bool operator < (const Individual& other) {
        return Rosenbrock(this -> x) < Rosenbrock(other.x);
    }
};

double GetRandBetween(double fMin, double fMax)
{
    double f = (double)rand() / RAND_MAX;
    return fMin + f * (fMax - fMin);
}

vector<Individual> InitializePopulation() {
    vector<Individual> population;
    for (int k = 0; k < populationSize; k++) {
        vector<double> x;
        for (int i = 0; i < n; i++) {
            x.push_back(GetRandBetween(x_min, x_max));
        }
        population.push_back(Individual(x));
    }
    return population;
}

vector<double> Modify(vector<double> x) {
    vector<double> w;
    for (int i = 0; i < n; i++) {
        double aux = x[i];
        bool c = rand() % 2;
        if (c) {
            aux += eps;
        }
        else {
            aux -= eps;
        }

        if (aux <= -2) {
            aux = -1.8;
        }
        else if (aux >= 2) {
            aux = 1.8;
        }

        w.push_back(aux);
    }
    return w;
}

double Anneal(double t0, int k, double alpha) {
    return t0 / (1 + alpha * k);

}

void SimulatedAnnealing(double temperature, int maxIteration, double alpha, Individual &individual) {
    double t = temperature;
    double t0 = temperature;
    vector<double> s = individual.x;
    vector<double> best = s;
    int k = 0;
    bool c = true;
    vector<double> s1;
    vector<double> w;
    while (c) {
        k++;
        //cout << k << " " << t << " " << Rosenbrock(best) << endl;
        s1 = s;
        w = Modify(s1);
        double r = GetRandBetween(0, 1);
        if (Rosenbrock(w) > Rosenbrock(s) or r < pow(numeric_limits<double>::epsilon(), (Rosenbrock(w) - Rosenbrock(s))/t0)) {
            s = w;
        }
        t = Anneal(t0, k, alpha);
        if (Rosenbrock(s) < Rosenbrock(best)) {
            best = s;
        }

        if (t <= 0.02 || k >= maxIteration) {
            c = 0;

        }
        s1.clear();
        w.clear();
    }
    individual.x = best;
}

Individual EvolutionStrategy(vector<Individual> population, int maxIteration, int lambda) {
    std::default_random_engine generator;
    std::normal_distribution<double> distribution(0.0, 1.0);

    vector<Individual> children;
    double tau = 1 / pow(n, 1 / 2);
    for (int it = 0; it < maxIteration; it++) {
        cout << "Current iteration: " << it << endl;
        for (int i = 0; i < populationSize; i++) {
            for (int l = 0; l < lambda; l++) {
                Individual aux = Individual(population[i].x);
                aux.sigma = population[i].sigma * pow(numeric_limits<double>::epsilon(), tau * distribution(generator));
                for (int j = 0; j < n; j++) {
                    aux.x[j] = population[i].x[j] + aux.sigma * distribution(generator);
                }
                children.push_back(aux);
            }
        }
        for (int i = 0; i < children.size(); i++) {
            population.push_back(children[i]);
        }
        sort(population.begin(), population.end());
        vector<Individual> newPopulation;
        for (int i = 0; i < populationSize; i++) {
            newPopulation.push_back(population[i]);
        }
        population = newPopulation;
        children.clear();
    }
    sort(population.begin(), population.end());
    return population[0];
}

int main()
{
    srand(time(0));
    vector<Individual> population = InitializePopulation();
    double initialFitness = Rosenbrock(population[0].x);
    cout << "\n---------- Simulated Annealing ----------\n\n";
    for (int i = 0; i < populationSize; i++) {
        cout << "Inidividual: " << i+1 << endl;
        SimulatedAnnealing(5000, 100000, 1, population[i]);
    }

    cout << "\n---------- Evolution Strategy ----------\n\n";
    Individual best = EvolutionStrategy(population, 50000, 3);
    cout << "\nFirst individual fitness value: " << initialFitness << endl;
    cout << "\nBest individual of the last generation: " << Rosenbrock(best.x) << endl;
}
