package Projekt.ClassicGeneticAlgorithm;

import java.util.ArrayList;

public class Individual {
    private ArrayList<Boolean> x;

    public Individual(ArrayList<Boolean> x) {
        this.x = x;
    }

    public ArrayList<Boolean> getX() {
        return x;
    }

    public void setX(ArrayList<Boolean> x) {
        this.x = x;
    }
}
