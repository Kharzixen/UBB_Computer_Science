import java.util.ArrayList;

public class ISBN {

    private ArrayList<Integer> numbers;

    public ArrayList<Integer> getNumbers() {
        return numbers;
    }

    public void setNumbers(ArrayList<Integer> numbers) {
        this.numbers = numbers;
    }

    public ISBN(ArrayList<Integer> numbers) {
        this.numbers = numbers;
    }

    public int isValidISBN() {
        if (numbers.size() == 13){
            int multiplier = 9;
            long sum = 0;
            for (Integer number : numbers.subList(0, numbers.size()-1)) {
                sum += (long) multiplier * number;
                if(multiplier == 9){
                    multiplier = 7;
                } else {
                    multiplier = 9;
                }
            }
            sum = sum % 10;
            if(sum == numbers.get(numbers.size() - 1)){
                return -1;
            } else{
                return (int) sum;
            }
        } else if(numbers.size() == 10){
            int multiplier = 1;
            long sum = 0;
            for (Integer number : numbers.subList(0, numbers.size()-1)) {
                sum += (long) multiplier * number;
                multiplier++;
            }
            sum = sum % 11;
            if (sum == numbers.get(numbers.size() - 1)) {
                return -1;
            } else {
                return (int) sum;
            }
        } else {
            return -2;
        }
    }
}
