package Projekt.MemeticAlgorithm;

import Projekt.ClassicGeneticAlgorithm.Individual;
import Projekt.Item;

import java.util.ArrayList;
import java.util.Random;

public class MultiMemeticAlgorithm {
    private final int populationSize;

    private final int length;
    private final double probOfTrue;

    private final double probMutation;

    private final ArrayList<Item> items;
    private final double sackSize;

    public MultiMemeticAlgorithm(int populationSize, int length, double probMutation, ArrayList<Item> items, double sackSize) {
        double probOfTrue1;
        this.populationSize = populationSize;
        this.length = length;
        this.probMutation = probMutation;
        this.items = items;
        this.sackSize = sackSize;

        probOfTrue1 = Math.max(5/Math.pow(10, Math.max(Math.floor( (double) length/100),1)), 0.005);
        if(probOfTrue1 == 0.5){
            probOfTrue1 = 0.005;
        }
        probOfTrue = probOfTrue1;
    }

    public Boolean IsInPopulation(ArrayList<Individual> population, Individual individual) {
        for (Individual i : population) {
            if (i.getX() == individual.getX()) {
                return true;
            }
        }
        return false;
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

        if (weightSum > sackSize) {
            return 0d;
        } else {
            return valueSum;
        }
    }

    public double GetAverageFitness(ArrayList<Individual> population){
        double averageFitness = 0;
        double populationSize = population.size();
        for (Individual i : population) {
            averageFitness += Fitness(i)/populationSize;
        }
        return averageFitness;
    }

    public ArrayList<Individual> GetInitialPopulation() {
        ArrayList<Individual> population = new ArrayList<>();
        int i = 0;
        while (i < populationSize) {
            ArrayList<Boolean> x = new ArrayList<>();
            Random random = new Random(); //java.util.Random
            for (int j = 0; j < length; j++) {
                double prob = random.nextDouble(0, 1);
                if (prob < probOfTrue) {
                    x.add(true);
                } else {
                    x.add(false);
                }
            }

            Individual individual = new Individual(x);
            if (Fitness(individual) != 0) {
                population.add(individual);
                i++;
            }
        }
        return population;
    }

    public ArrayList<Individual> Cross(Individual i1, Individual i2) {
        ArrayList<Individual> children = new ArrayList<>();
        Random random = new Random();
        int ind = random.nextInt(0, (length - 1) / 2);
        ArrayList<Boolean> x1 = new ArrayList<>();
        ArrayList<Boolean> x2 = new ArrayList<>();
        for (int i = 0; i < ind; i++) {
            x1.add(i1.getX().get(i));
            x2.add(i2.getX().get(i));
        }
        for (int i = ind; i < length; i++) {
            x1.add(i2.getX().get(i));
            x2.add(i1.getX().get(i));
        }
        children.add(new Individual(x1));
        children.add(new Individual(x2));

        return children;
    }

    public ArrayList<Individual> GetChildren(ArrayList<Individual> population) {
        Random random = new Random();
        ArrayList<Individual> children = new ArrayList<>();
        int i = 0;
        while (i < populationSize) {
            int index1 = random.nextInt(0, populationSize - 1);
            int index2 = random.nextInt(0, populationSize - 1);
            while (index1 == index2) {
                index2 = random.nextInt(0, populationSize - 1);
            }

            ArrayList<Individual> offSprings = Cross(population.get(index1), population.get(index2));
            if (Fitness(offSprings.get(0)) != 0 && !IsInPopulation(population, offSprings.get(1))) {
                children.add(offSprings.get(0));
                //System.out.println(i + " " + Fitness(offSprings.get(1)) +  " " + Fitness(population.get(index1)));
                i++;
                if(i== populationSize -1){
                    break;
                }
            }

            if (Fitness(offSprings.get(1)) != 0 && !IsInPopulation(population, offSprings.get(1))) {
                children.add(offSprings.get(1));
                i++;
                if(i== populationSize -1){
                    break;
                }
                //System.out.println(i + " " + Fitness(offSprings.get(1)) + " " + Fitness(population.get(index2)));
            }

        }
        return children;
    }

    public ArrayList<Individual> Mutation(ArrayList<Individual> population) {
        ArrayList<Individual> populationAfterMutation = new ArrayList<>();
        Random random = new Random();
        for (Individual individual : population) {
            if (random.nextDouble(0d, 1d) < probMutation) {
                double probGeneMutation = random.nextDouble(0,0.5);
                ArrayList<Boolean> x = new ArrayList<Boolean>();
                for (int i = 0; i < length; i++) {
                    if (random.nextDouble(0,1) < probGeneMutation) {
                        x.add(!individual.getX().get(i));
                    } else {
                        x.add(individual.getX().get(i));
                    }
                }
                populationAfterMutation.add(new Individual(x));
            } else {
                populationAfterMutation.add(individual);
            }
        }
        return populationAfterMutation;
    }

    public ArrayList<Individual> HardMutation(ArrayList<Individual> population) {
        ArrayList<Individual> populationAfterMutation = new ArrayList<>();
        Random random = new Random();

        populationAfterMutation.add(population.get(0));
        populationAfterMutation.add(population.get(1));

        for(int i=2; i<population.size()/10; i++) {
            Individual individual = population.get(i);
            if (random.nextDouble(0, 1) < 0.5) {
                while (true) {
                    ArrayList<Boolean> x = new ArrayList<>();
                    for (int j = 0; j < length; j++) {
                        double prob = random.nextDouble(0, 1);
                        if (prob < probOfTrue) {
                            x.add(true);
                        } else {
                            x.add(false);
                        }
                    }

                    individual.setX(x);
                    if (Fitness(individual) != 0) {
                        populationAfterMutation.add(individual);
                        break;
                    }
                }
            } else {
                populationAfterMutation.add(individual);
            }
        }

        for(int i=population.size()/10; i<population.size(); i++){
            Individual individual = population.get(i);
            while (true) {
                ArrayList<Boolean> x = new ArrayList<>();
                for (int j = 0; j < length; j++) {
                    double prob = random.nextDouble(0, 1);
                    if (prob < probOfTrue) {
                        x.add(true);
                    } else {
                        x.add(false);
                    }
                }

                individual.setX(x);
                if (Fitness(individual) != 0) {
                    populationAfterMutation.add(individual);
                    break;
                }
            }
            populationAfterMutation.add(individual);
        }
        return populationAfterMutation;
    }
}
