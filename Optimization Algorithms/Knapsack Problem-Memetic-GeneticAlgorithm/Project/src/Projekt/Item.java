package Projekt;

public class Item {
    double value;
    double weight;

    public double GetValueWeightRatio(){
        return value/weight;
    }

    public Item(double value, double weight) {
        this.value = value;
        this.weight = weight;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }
}
