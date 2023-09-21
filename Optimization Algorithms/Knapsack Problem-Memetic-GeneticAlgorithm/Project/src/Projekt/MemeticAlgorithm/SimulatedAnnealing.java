package Projekt.MemeticAlgorithm;

import Projekt.ClassicGeneticAlgorithm.Individual;
import Projekt.Item;

import java.awt.image.AreaAveragingScaleFilter;
import java.util.ArrayList;
import java.util.Random;

public class SimulatedAnnealing {
    private double startingTemperature;

    private double minTemperature;

    private int maxIteration;

    //private double probGeneModification;

    private double alpha;

    private ArrayList<Item> items;

    private double knapsackSize;

    public SimulatedAnnealing(double knapsackSize, ArrayList<Item> items) {
        this.items = items;
        this.knapsackSize = knapsackSize;
    }

    public void setKnapsackProblemParameters(ArrayList<Item> items, double knapsackSize){
        this.items = items;
        this.knapsackSize = knapsackSize;
    }

    public void setAnnealingParameters(double startingTemperature, double minTemperature, double alpha, int maxIteration){
        this.startingTemperature = startingTemperature;
        this.minTemperature = minTemperature;
        this.maxIteration = maxIteration;
        //this.probGeneModification = 2.5/Math.pow(10, Math.max(Math.floor( (double) items.size()/100),1));
        this.alpha = alpha;
    }

    private ArrayList<Boolean> Modify(ArrayList<Boolean> x){
        Random random = new Random();
        ArrayList<Boolean> newX = new ArrayList<>(x);
        int index = random.nextInt(0,items.size() - 1);
        newX.set(index, !x.get(index));
        /*
        for (Boolean aBoolean : x) {
            if (random.nextDouble(0, 1) < probGeneModification) {
                newX.add(!aBoolean);
            } else {
                newX.add(aBoolean);
            }
        */

        return newX;
    }

    private double Fitness(ArrayList<Boolean> x){
        double valueSum = 0;
        double weightSum = 0;
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

    private double Anneal(double t0, int k, double alpha){
        return t0/(1 + alpha * k);
    }

    public Individual PerformSimulatedAnnealing(Individual individual){
        double t;
        double t0 = startingTemperature;
        ArrayList<Boolean> s = individual.getX();
        ArrayList<Boolean> best = new ArrayList<>(s);
        int k =0;
        boolean c = true;
        Random random = new Random();
        ArrayList<Boolean> s1;
        ArrayList<Boolean> w;
        while(c){
            k++;
            s1 = new ArrayList<>(s);
            w = Modify(s1);
            double r = random.nextDouble(0,1);
            if(Fitness(w) > Fitness(s) || (Fitness(w) !=0.0 && r < Math.pow(Math.ulp(0.1),(Fitness(w) - Fitness(s))/t0))){
                s = new ArrayList<>(w);
            }
            t = Anneal(t0, k, alpha);

            if(Fitness(s) > Fitness(best)){
                best = new ArrayList<>(s);
                //System.out.println(k +  " " + Fitness(s) + "\n");
            }

            if(t <= minTemperature || k>= maxIteration){
                c = false;
            }
            s1.clear();
            w.clear();
        }

        return new Individual(best);
    }
}
