package Projekt.ClassicGeneticAlgorithm;

import Projekt.Item;

import java.util.ArrayList;

public class RunGAClass {
    private int populationSize;
    private double probMutation;
    private ArrayList<Item> items;
    private double knapsackSize;
    private int maxIteration;

    private boolean debugParameter;

    public RunGAClass(double knapsackSize, ArrayList<Item> items) {
        this.knapsackSize = knapsackSize;
        this.items = items;
    }

    public void setProblemParameters( double knapsackSize, ArrayList<Item> items){
        this.knapsackSize = knapsackSize;
        this.items = items;
    }

    public void setDebugParameter(boolean debugParameter){
        this.debugParameter = debugParameter;
    }

    public void setGeneticParameters(int populationSize, int maxIteration, double probMutation){
        this.probMutation = probMutation;
        this.populationSize = populationSize;
        this.maxIteration = maxIteration;
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
        GeneticAlgorithm ga = new GeneticAlgorithm(populationSize, items.size(),  probMutation, items, knapsackSize);
        ArrayList<Individual> population = ga.Mutation(ga.GetInitialPopulation());
        double prevFitness = 0;
        int count = 0;
        for (int i = 0; i < maxIteration; i++) {
            if(debugParameter){
                System.out.println("Iteration: " + (i+1) );
            }
            ArrayList<Individual> children = ga.Mutation(ga.GetChildren(population));
            population.addAll(children);
            population.sort((i1, i2) -> (int) (ga.Fitness(i2) - ga.Fitness(i1)));

            ArrayList<Individual> newParents = new ArrayList<>();

            for(int j=0; j<populationSize; j++){
                newParents.add(population.get(j));
            }

            population = newParents;
            int currBestFitness = (int) ga.Fitness(population.get(0));
            int avgFitness = (int) ga.GetAverageFitness(population);

            if( (currBestFitness - avgFitness) == 0 || (currBestFitness - avgFitness) == 1){
                population = ga.HardMutation(population);
            }

            if(debugParameter) {
                System.out.println("Current best fitness: " + currBestFitness);
                System.out.println("Average fitness: " + avgFitness + "\n");
            }

        }
        population.sort((i1, i2) -> (int) (ga.Fitness(i2) - ga.Fitness(i1)));
        return population.get(0);
    }
}
