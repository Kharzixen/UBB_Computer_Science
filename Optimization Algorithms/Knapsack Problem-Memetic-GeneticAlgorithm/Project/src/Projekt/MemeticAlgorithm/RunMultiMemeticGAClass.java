package Projekt.MemeticAlgorithm;

import Projekt.ClassicGeneticAlgorithm.GeneticAlgorithm;
import Projekt.ClassicGeneticAlgorithm.Individual;
import Projekt.Item;

import java.util.ArrayList;
import java.util.Random;

public class RunMultiMemeticGAClass {
    private int populationSize;
    private double probMutation;
    private ArrayList<Item> items;
    private double knapsackSize;
    private int maxIteration;

    private int numberOfLocalSearches;

    private boolean debugParameter;

    public RunMultiMemeticGAClass(double knapsackSize, ArrayList<Item> items) {
        this.knapsackSize = knapsackSize;
        this.items = items;
    }

    public void setParameters( int knapsackSize, ArrayList<Item> items){
        this.knapsackSize = knapsackSize;
        this.items = items;
    }

    public void setDebugParameter(boolean debugParameter){
        this.debugParameter = debugParameter;
    }

    public void setGeneticParameters(int populationSize, int maxIteration, double probMutation, int numberOfLocalSearches){
        this.probMutation = probMutation;
        this.populationSize = populationSize;
        this.maxIteration = maxIteration;
        this.numberOfLocalSearches = numberOfLocalSearches;
    }

    public double GetFitnessOfIndividual(Individual individual){
        double valueSum = 0;
        double weightSum = 0;
        ArrayList<Boolean> x = individual.getX();
        for (int i = 0; i < x.size(); i++) {
            if (x.get(i)) {
                valueSum += items.get(i).getValue();
                weightSum += items.get(i).getWeight();
            }
        }

        if (weightSum > knapsackSize) {
            return 0d;
        } else {
            return valueSum;
        }
    }

    public Individual RunGeneticAlgorithm(){
        assert items != null;
        MultiMemeticAlgorithm mmga = new MultiMemeticAlgorithm(populationSize, items.size(),  probMutation, items, knapsackSize);
        SimulatedAnnealing sa = new SimulatedAnnealing(knapsackSize, items);
        sa.setAnnealingParameters(6000, 0.03, 1 , 20000);
        HillClimbing hc = new HillClimbing(knapsackSize, items);
        hc.setHillClimbingParameters(100000, 1000);

        int localSearchCounter = 0;
        int saCounter = 0;
        double probSA = 0.5;

        ArrayList<Individual> population = mmga.Mutation(mmga.GetInitialPopulation());
        for (int i = 0; i < maxIteration; i++) {
            if(debugParameter){
                System.out.println("Iteration: " + (i+1) );
            }
            ArrayList<Individual> children = mmga.Mutation(mmga.GetChildren(population));
            population.addAll(children);

            for(int j=0; j<numberOfLocalSearches; j++){
                /*
                Random random = new Random();
                int index = random.nextInt(0, population.size() -1);
                if(random.nextDouble(0,1) <= probSA) {
                    population.set(index, sa.PerformSimulatedAnnealing(population.get(index)));
                }
                else {
                    population.set(index, hc.PerformHillClimbingAlgorithm(population.get(index)));
                }
                */
                Random random = new Random();
                int index = random.nextInt(0, population.size() -1);
                Individual currIndividual = population.get(index);
                Individual individualAfterLS = null;
                if(random.nextDouble() < probSA) {
                    individualAfterLS = sa.PerformSimulatedAnnealing(population.get(index));
                    if(GetFitnessOfIndividual(individualAfterLS) > GetFitnessOfIndividual(population.get(index))) {
                        saCounter++;
                        population.set(index, individualAfterLS);
                    }
                } else {
                    individualAfterLS = hc.PerformHillClimbingAlgorithm(population.get(index));
                    if(GetFitnessOfIndividual(individualAfterLS) > GetFitnessOfIndividual(population.get(index))) {
                        saCounter++;
                        population.set(index, individualAfterLS);
                    }
                }
                localSearchCounter++;
                probSA = (double) saCounter/localSearchCounter;
            }

            population.sort((i1, i2) -> (int) (mmga.Fitness(i2) - mmga.Fitness(i1)));

            Random random = new Random();
            if(random.nextDouble(0,1) <= probSA) {
                population.set(0, sa.PerformSimulatedAnnealing(population.get(0)));
                population.set(0, sa.PerformSimulatedAnnealing(population.get(0)));
            }
            else {
                population.set(0, hc.PerformHillClimbingAlgorithm(population.get(0)));
                population.set(0, sa.PerformSimulatedAnnealing(population.get(0)));
            }

            ArrayList<Individual> newParents = new ArrayList<>();

            for(int j=0; j<populationSize; j++){
                newParents.add(population.get(j));
            }

            population = newParents;
            int currBestFitness = (int) mmga.Fitness(population.get(0));
            int avgFitness = (int) mmga.GetAverageFitness(population);

            if( (currBestFitness - avgFitness) == 0 || (currBestFitness - avgFitness) == 1){
                population = mmga.HardMutation(population);
            }

            if(debugParameter) {
                System.out.println("Current best fitness: " + currBestFitness);
                System.out.println("Average fitness: " + avgFitness + "\n");
            }

        }
        population.sort((i1, i2) -> (int) (mmga.Fitness(i2) - mmga.Fitness(i1)));
        return population.get(0);
    }
}
