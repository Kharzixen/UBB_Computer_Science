package Projekt.MemeticAlgorithm;

import Projekt.ClassicGeneticAlgorithm.Individual;
import Projekt.Item;

import java.util.ArrayList;
import java.util.Random;

public class HillClimbing {

    private ArrayList<Item> items;

    private double knapsackSize;

    private int maxIteration;
    private int noImprovementThreshold;

    public HillClimbing(double knapsackSize, ArrayList<Item> items) {
        this.items = items;
        this.knapsackSize = knapsackSize;
    }

    public void setKnapsackProblemParameters(ArrayList<Item> items, double knapsackSize){
        this.items = items;
        this.knapsackSize = knapsackSize;
    }

    public void setHillClimbingParameters(int maxIteration, int noImprovementThreshold){
        this.maxIteration = maxIteration;
        this.noImprovementThreshold = noImprovementThreshold;
    }

    public double Fitness(Individual individual) {
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

    private ArrayList<Individual> GetNeighbours(Individual individual){
        ArrayList<Individual> neighbours = new ArrayList<>();
        Random random = new Random();
        for(int i=0 ; i<random.nextInt(1,10); i++) {
            ArrayList<Boolean> newX = new ArrayList<>(individual.getX());
            int index = random.nextInt(0, items.size() - 1);
            newX.set(index, !individual.getX().get(index));
            neighbours.add(new Individual(newX));
        }
        return neighbours;
    }

    public Individual PerformHillClimbingAlgorithm(Individual individual){
        Individual best = individual;
        int noImprovementCounter = 0;
        for(int i=0; i<maxIteration; i++){
            ArrayList<Individual> neighbours = GetNeighbours(best);
            Individual possibleNextBest = neighbours.get(0);
            for(int j=1; j<neighbours.size(); j++){
                if(Fitness(possibleNextBest) < Fitness(neighbours.get(j))){
                    possibleNextBest = neighbours.get(j);
                }
            }
            if (Fitness(best) < Fitness(possibleNextBest)){
                best = possibleNextBest;
                noImprovementCounter = 0;
            }
            noImprovementCounter ++ ;
            if(noImprovementCounter >= noImprovementThreshold){
                break;
            }
        }
        return best;
    }

}
