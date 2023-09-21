import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class Main {

    public static ArrayList<ISBN> GetISBNs(String file) throws IOException {
        ArrayList<ISBN> ISBNs = new ArrayList<>();
        BufferedReader reader;
        reader = new BufferedReader(new FileReader(file));
        String line = reader.readLine();

        while (line != null) {
            ArrayList<Integer> numbers = new ArrayList<>();
            for(int i=0; i<line.length() - 1; i++){
                if(Character.isDigit(line.charAt(i))){
                    numbers.add(Integer.parseInt(String.valueOf(line.charAt(i))));
                }
            }
            if(line.charAt(line.length() -1 ) == 'X'){
                numbers.add(10);
            } else if (Character.isDigit(line.charAt(line.length() -1))){
                numbers.add(Integer.parseInt(String.valueOf(line.charAt(line.length() - 1 ))));
            }
            ISBNs.add(new ISBN(numbers));
            line = reader.readLine();
        }
        return ISBNs;
    }
    public static void main(String[] args) {
        try {
            ArrayList<ISBN> ISBNs = GetISBNs("src/input.txt");
            for(ISBN isbn: ISBNs){
                // if -1 is returned, the ISBN is correct
                if(isbn.isValidISBN() == -1){
                    System.out.println("HELYES! ");
                } else {
                    // else the correct digit is printed on display
                    int correctSymbol = isbn.isValidISBN();
                    if(correctSymbol == 10){
                        System.out.println("Helytelen. Helyesen: X");
                    } else {
                        System.out.println("Helytelen. Helyesen: " + correctSymbol);
                    }
                }
            }
        } catch (Exception e){
            System.out.println(e.getMessage());
            System.exit(-1);
        }
    }
}