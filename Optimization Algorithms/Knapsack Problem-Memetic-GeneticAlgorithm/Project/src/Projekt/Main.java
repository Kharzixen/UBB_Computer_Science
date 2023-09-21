package Projekt;

import Projekt.ClassicGeneticAlgorithm.Individual;
import Projekt.ClassicGeneticAlgorithm.RunGAClass;
import Projekt.MemeticAlgorithm.RunMultiMemeticGAClass;

import java.io.*;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Scanner;

public class Main {

    static int nrOfTest = 6;
    static double knapsackSize;

    static int populationSizeMultiplierMGA = 2;
    static int generationMultiplierMGA = 3;
    static int populationSizeMultiplierCGA = 5;
    static int generationMultiplierCGA = 100;

    public static ArrayList<Item> GetListOfItems(String path) throws FileNotFoundException {
        ArrayList<Item> items = new ArrayList<>();
        File myObj = new File(path);
        Scanner myReader = new Scanner(myObj);

        //knapsack size from file
        if (myReader.hasNextLine()) {
            String data = myReader.nextLine();
            knapsackSize = Double.parseDouble(data);
            myReader.nextLine();
        }

        //items from file
        while (myReader.hasNextLine()) {
            String data = myReader.nextLine();
            String[] parts = data.split(" ");
            Item item = new Item(Double.parseDouble(parts[0]), Double.parseDouble(parts[1]));
            items.add(item);
        }
        myReader.close();
        return items;
    }

    public static double GetOptimum(String path) throws FileNotFoundException {
        File myObj = new File(path);
        Scanner myReader = new Scanner(myObj);

        //knapsack size from file
        if (myReader.hasNextLine()) {
            String data = myReader.nextLine();
            return Double.parseDouble(data);
        }
        return -1;
    }

    public static void PerformParameterTuningCGA(int numberOfExperiments, double optimum, RunGAClass runObject, String outputFileName, ArrayList<Integer> populationSizes, ArrayList<Integer> maxIterationNumbers, ArrayList<Double> probMutationNumbers) {
        try {
            FileWriter fileWriter = new FileWriter("ParameterStatistics/" + outputFileName);
            int parameterSet = 0;
            for (int populationSize : populationSizes) {
                for (int maxIteration : maxIterationNumbers) {
                    for (double probMutationNumber : probMutationNumbers) {
                        parameterSet++;
                        fileWriter.write("\n------ ParameterSet nr. " + parameterSet + " ------\n");
                        fileWriter.write("  Population Size: " + populationSize + "\n");
                        fileWriter.write("  Max Iteration : " + maxIteration + "\n");
                        fileWriter.write("  Probability of mutation: " + probMutationNumber + "\n\n");
                        System.out.println("\n------ ParameterSet nr. " + parameterSet + " ------\n");
                        System.out.println("  Population Size: " + populationSize + "\n");
                        System.out.println("  Max Iteration : " + maxIteration + "\n");
                        System.out.println("  Probability of mutation: " + probMutationNumber + "\n\n");
                        double avgFitness = 0;
                        double avgPercentage = 0;
                        for (int i = 0; i < numberOfExperiments; i++) {
                            runObject.setGeneticParameters(populationSize, maxIteration, probMutationNumber);
                            runObject.setDebugParameter(false);
                            Individual individual = runObject.RunGeneticAlgorithm();
                            fileWriter.write("      Run nr. " + (i + 1) + ": FitnessValue = " + runObject.GetFitnessOfIndividual(individual) + "\n");
                            System.out.println("      Run nr. " + (i + 1) + ": FitnessValue = " + runObject.GetFitnessOfIndividual(individual) + "\n");
                            avgFitness += runObject.GetFitnessOfIndividual(individual) / numberOfExperiments;
                            avgPercentage += (1 - runObject.GetFitnessOfIndividual(individual) / optimum) / numberOfExperiments;
                        }
                        fileWriter.write("\n------ Conclusion ------\n");
                        fileWriter.write("(*) Average Fitness value: " + avgFitness + "\n");
                        fileWriter.write("(*) Average variance: " + avgPercentage + "\n");
                        fileWriter.write("\n\n");
                        System.out.println("\n------ Conclusion ------\n");
                        System.out.println("(*) Average Fitness value: " + avgFitness + "\n");
                        System.out.println("(*) Average variance: " + avgPercentage + "\n");
                        System.out.println("\n\n");
                    }
                }
            }
            fileWriter.close();
        } catch (IOException e) {
            System.out.println("IO output occurred.");
            e.printStackTrace();
        }

    }

    public static void ParameterTuningCGA(int numberOfExperiments, RunGAClass runObj, double optimum) {
        ArrayList<Integer> populationSizes = new ArrayList<>();
        populationSizes.add(200);
        populationSizes.add(300);
        populationSizes.add(500);

        ArrayList<Integer> maxIterationNumbers = new ArrayList<>();
        maxIterationNumbers.add(7000);
        maxIterationNumbers.add(10000);
        maxIterationNumbers.add(15000);
        maxIterationNumbers.add(20000);

        ArrayList<Double> probMutationNumbers = new ArrayList<>();
        probMutationNumbers.add(0.1);
        probMutationNumbers.add(0.15);
        probMutationNumbers.add(0.2);
        probMutationNumbers.add(0.3);

        PerformParameterTuningCGA( numberOfExperiments , optimum, runObj, "statistics2.txt", populationSizes, maxIterationNumbers, probMutationNumbers);

    }

    public static void PerformParameterTuningMGA(int numberOfExperiments, int numberOfLocalSearches, double optimum, RunMultiMemeticGAClass runObject, String outputFileName, ArrayList<Integer> populationSizes, ArrayList<Integer> maxIterationNumbers, ArrayList<Double> probMutationNumbers){
        try {
            FileWriter fileWriter = new FileWriter("ParameterStatistics/" + outputFileName);
            int parameterSet = 0;
            for (int populationSize : populationSizes) {
                for (int maxIteration : maxIterationNumbers) {
                    for (double probMutationNumber : probMutationNumbers) {
                        parameterSet++;
                        fileWriter.write("\n------ ParameterSet nr. " + parameterSet + " ------\n");
                        fileWriter.write("  Population Size: " + populationSize + "\n");
                        fileWriter.write("  Max Iteration : " + maxIteration + "\n");
                        fileWriter.write("  Probability of mutation: " + probMutationNumber + "\n\n");
                        System.out.println("\n------ ParameterSet nr. " + parameterSet + " ------\n");
                        System.out.println("  Population Size: " + populationSize + "\n");
                        System.out.println("  Max Iteration : " + maxIteration + "\n");
                        System.out.println("  Probability of mutation: " + probMutationNumber + "\n\n");
                        double avgFitness = 0;
                        double avgPercentage = 0;
                        for (int i = 0; i < numberOfExperiments; i++) {
                            runObject.setGeneticParameters(populationSize, maxIteration, probMutationNumber, numberOfLocalSearches);
                            runObject.setDebugParameter(false);
                            Individual individual = runObject.RunGeneticAlgorithm();
                            fileWriter.write("      Run nr. " + (i + 1) + ": FitnessValue = " + runObject.GetFitnessOfIndividual(individual) + "\n");
                            System.out.println("      Run nr. " + (i + 1) + ": FitnessValue = " + runObject.GetFitnessOfIndividual(individual) + "\n");
                            avgFitness += runObject.GetFitnessOfIndividual(individual) / numberOfExperiments;
                            avgPercentage += (1 - runObject.GetFitnessOfIndividual(individual) / optimum) / numberOfExperiments;
                        }
                        fileWriter.write("\n------ Conclusion ------\n");
                        fileWriter.write("(*) Average Fitness value: " + avgFitness + "\n");
                        fileWriter.write("(*) Average variance: " + avgPercentage + "\n");
                        fileWriter.write("\n\n");
                        System.out.println("\n------ Conclusion ------\n");
                        System.out.println("(*) Average Fitness value: " + avgFitness + "\n");
                        System.out.println("(*) Average variance: " + avgPercentage + "\n");
                        System.out.println("\n\n");
                    }
                }
            }
            fileWriter.close();
        } catch (IOException e) {
            System.out.println("IO output occurred.");
            e.printStackTrace();
        }
    }

    public static void ParameterTuningMGA(int numberOfExperiments, int numberOfLocalSearches, RunMultiMemeticGAClass runObj, double optimum){

        ArrayList<Integer> populationSizes = new ArrayList<>();
        populationSizes.add(50);
        populationSizes.add(100);
        populationSizes.add(150);

        ArrayList<Integer> maxIterationNumbers = new ArrayList<>();
        maxIterationNumbers.add(20);
        maxIterationNumbers.add(40);
        maxIterationNumbers.add(60);
        maxIterationNumbers.add(100);

        ArrayList<Double> probMutationNumbers = new ArrayList<>();
        probMutationNumbers.add(0.15);
        probMutationNumbers.add(0.2);
        probMutationNumbers.add(0.25);
        probMutationNumbers.add(0.3);

        PerformParameterTuningMGA(numberOfExperiments, numberOfLocalSearches, optimum, runObj, "statistics1.txt",populationSizes, maxIterationNumbers, probMutationNumbers );
    }

    public static void TestCGA(String outputFile, int nrOfExperiments, double optimum, int populationSize, int maxIteration, double probMutation, boolean debug, ArrayList<Item> items){
        try {
            FileWriter fileWriter = new FileWriter("TestOutputs/" + outputFile);
            RunGAClass runObjectCGA = new RunGAClass(knapsackSize, items);
            runObjectCGA.setGeneticParameters(populationSize, maxIteration, probMutation);
            runObjectCGA.setDebugParameter(debug);
            System.out.println("---- Test CGA ----");
            System.out.println("    optimum: " + optimum);
            System.out.println("    maxIteration: " + maxIteration);
            System.out.println("    populationSize: " + populationSize);
            System.out.println("    probMutation: " + probMutation);
            System.out.println();

            fileWriter.write("---- Test CGA ----\n");
            fileWriter.write("    optimum: " + optimum + "\n");
            fileWriter.write("    maxIteration: " + maxIteration + "\n");
            fileWriter.write("    populationSize: " + populationSize + "\n");
            fileWriter.write("    probMutation: " + probMutation + "\n");
            fileWriter.write("\n");

            double meanFitness = 0;
            double meanVariance = 0;
            Instant start = Instant.now();
            for(int i=1; i<=nrOfExperiments; i++){
                Individual ind = runObjectCGA.RunGeneticAlgorithm();
                double fitness = runObjectCGA.GetFitnessOfIndividual(ind);
                System.out.println("Run no. " + i + ": Fitness: " + fitness + " -- Variance: " + (1-fitness/optimum)*100 + "%" );
                fileWriter.write("Run no. " + i + ": Fitness: " + fitness + " -- Variance: " + (1-fitness/optimum)*100 + "%\n");
                meanFitness += fitness/nrOfExperiments;
                meanVariance += (1-fitness/optimum)*100/nrOfExperiments;
            }
            Instant end = Instant.now();

            System.out.println();
            System.out.println("---- Conclusion ----");
            System.out.println("    Mean Fitness: " + meanFitness);
            System.out.println("    Mean Variance: " + meanVariance);
            System.out.println("    Runtime: " + Duration.between(start, end));
            System.out.println();

            fileWriter.write("\n");
            fileWriter.write("---- Conclusion ----\n");
            fileWriter.write("    Mean Fitness: " + meanFitness + "\n");
            fileWriter.write("    Mean Variance: " + meanVariance + "\n");
            fileWriter.write("    Runtime: " + Duration.between(start, end) + "\n");
            fileWriter.write("\n");
            fileWriter.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public static void TestMGA(String outputFile, int nrOfExperiments, double optimum, int populationSize, int maxIteration, double probMutation, int nrOfLocalSearches, boolean debug, ArrayList<Item> items){
        try {
            FileWriter fileWriter = new FileWriter("TestOutputs/" + outputFile);
            RunMultiMemeticGAClass runObjectCGA = new RunMultiMemeticGAClass(knapsackSize, items);
            runObjectCGA.setGeneticParameters(populationSize, maxIteration, probMutation, nrOfLocalSearches);
            runObjectCGA.setDebugParameter(debug);
            System.out.println("---- Test MGA ---- ");
            System.out.println("    optimum: " + optimum);
            System.out.println("    maxIteration: " + maxIteration);
            System.out.println("    populationSize: " + populationSize);
            System.out.println("    probMutation: " + probMutation);
            System.out.println();

            fileWriter.write("---- Test CGA ----\n");
            fileWriter.write("    optimum: " + optimum + "\n");
            fileWriter.write("    maxIteration: " + maxIteration + "\n");
            fileWriter.write("    populationSize: " + populationSize + "\n");
            fileWriter.write("    probMutation: " + probMutation + "\n");
            fileWriter.write("\n");

            double meanFitness = 0;
            double meanVariance = 0;
            Instant start = Instant.now();
            for(int i=1; i<=nrOfExperiments; i++){
                Individual ind = runObjectCGA.RunGeneticAlgorithm();
                double fitness = runObjectCGA.GetFitnessOfIndividual(ind);
                System.out.println("Run no. " + i + ": Fitness: " + fitness + " -- Variance: " + (1 - fitness/optimum)*100 + "%" );
                fileWriter.write("Run no. " + i + ": Fitness: " + fitness + " -- Variance: " + (1-fitness/optimum)*100 + "%\n");
                meanFitness += fitness/nrOfExperiments;
                meanVariance += (1-fitness/optimum)*100/nrOfExperiments;
            }
            Instant end = Instant.now();

            System.out.println();
            System.out.println("---- Conclusion ----");
            System.out.println("    Mean Fitness: " + meanFitness);
            System.out.println("    Mean Variance: " + meanVariance);
            System.out.println("    Runtime: " + Duration.between(start, end));
            System.out.println();

            fileWriter.write("\n");
            fileWriter.write("---- Conclusion ----\n");
            fileWriter.write("    Mean Fitness: " + meanFitness + "\n");
            fileWriter.write("    Mean Variance: " + meanVariance + "\n");
            fileWriter.write("    Runtime: " + Duration.between(start, end) + "\n");
            fileWriter.write("\n");
            fileWriter.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }


    }

    public static void CompareGeneticAlgorithms(int nrOfExperiments) {
        ArrayList<Integer> populationSize = new ArrayList<>();
        populationSize.add(0);
        populationSize.add(10);
        populationSize.add(10);
        populationSize.add(50);
        populationSize.add(100);
        populationSize.add(200);
        populationSize.add(300);

        ArrayList<Integer> nrsOfGeneration = new ArrayList<>();
        nrsOfGeneration.add(0);
        nrsOfGeneration.add(15);
        nrsOfGeneration.add(15);
        nrsOfGeneration.add(30);
        nrsOfGeneration.add(50);
        nrsOfGeneration.add(100);
        nrsOfGeneration.add(120);

        for (int i = 1; i <= nrOfTest; i++) {
            try {
                try (FileWriter fileWriter = new FileWriter("Comparisons/output" + i + ".txt")) {
                    ArrayList<Item> items = GetListOfItems("tests/input" + i + ".txt");
                    double optimum = GetOptimum("optimumFiles/optimum" + i + ".txt");
                    System.out.println("Test Case nr. " + i + "!\nCurrent optimum: " + optimum + "\n\n    MemeticAlgorithm:");
                    fileWriter.write("Test Case nr. " + i + "!\nCurrent optimum: " + optimum + "\nMemeticAlgorithm:\n\n");

                    RunMultiMemeticGAClass runObject = new RunMultiMemeticGAClass(knapsackSize, items);
                    runObject.setGeneticParameters(populationSizeMultiplierMGA * populationSize.get(i), generationMultiplierMGA * nrsOfGeneration.get(i), 0.2, 10);
                    runObject.setDebugParameter(false);
                    for (int j = 0; j < nrOfExperiments; j++) {
                        Individual ind = runObject.RunGeneticAlgorithm();
                        System.out.print("    Experiment nr. " + (j + 1) + ": Estimated optimum: " + runObject.GetFitnessOfIndividual(ind));
                        System.out.println(" -- Optimum: " + optimum + ". Variance: " + (1 - runObject.GetFitnessOfIndividual(ind) / optimum) * 100 + "%");
                        fileWriter.write("Experiment nr. " + (j + 1) + ": Estimated optimum: " + runObject.GetFitnessOfIndividual(ind));
                        fileWriter.write(" -- Optimum: " + optimum + ". Variance: " + (1 - runObject.GetFitnessOfIndividual(ind) / optimum) * 100 + "%\n");
                    }

                    System.out.println();

                    System.out.println("\n\n    Classic Genetic Algorithm:");
                    fileWriter.write("\nClassic Genetic Algorithm:\n\n");

                    RunGAClass runObject1 = new RunGAClass(knapsackSize, items);
                    runObject1.setGeneticParameters(populationSizeMultiplierCGA * populationSize.get(i), generationMultiplierCGA * nrsOfGeneration.get(i), 0.2);
                    runObject1.setDebugParameter(false);
                    for (int j = 0; j < nrOfExperiments; j++) {
                        Individual ind = runObject1.RunGeneticAlgorithm();
                        System.out.print("    Experiment nr. " + (j + 1) + ": Estimated optimum:" + runObject.GetFitnessOfIndividual(ind));
                        System.out.println(" -- Optimum: " + optimum + ". Variance: " + (1 - runObject.GetFitnessOfIndividual(ind) / optimum) * 100 + "%");
                        fileWriter.write("Experiment nr. " + (j + 1) + ": Estimated optimum:" + runObject.GetFitnessOfIndividual(ind));
                        fileWriter.write(" -- Optimum: " + optimum + ". Variance: " + (1 - runObject.GetFitnessOfIndividual(ind) / optimum) * 100 + "%\n");
                    }

                    System.out.println();
                }

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {

        /*
         *
         *TODO:
         *   DOCUMENTATION !!!
         *
         */

        //CompareGeneticAlgorithms(10);

        ArrayList<Item> items;
        double optimum;
        try {
            items = GetListOfItems("Tests/input6.txt");
            optimum = GetOptimum("OptimumFiles/optimum6.txt");
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        }

        //RunGAClass runObjectCGA = new RunGAClass(knapsackSize, items);
        //ParameterTuningCGA(10, runObjectCGA, optimum );

        //RunMultiMemeticGAClass runObjectMGA = new RunMultiMemeticGAClass(knapsackSize, items);
        //ParameterTuningMGA(10, 10, runObjectMGA, optimum);

        //TestCGA("output4_cga.txt", 5, optimum, 250, 30000, 0.2, false, items);
        TestMGA("output6_mga.txt", 5, optimum, 180, 400, 0.2, 8, true, items);
    }
}