import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class Main {

    public static ArrayList<String> getCode(String file) throws IOException {
        ArrayList<String> code = new ArrayList<>();
        BufferedReader reader;
        reader = new BufferedReader(new FileReader(file));
        String codeWord = reader.readLine();

        while (codeWord != null) {
            code.add(codeWord);
            codeWord = reader.readLine();
        }
        reader.close();

        return code;
    }

    public static int getDistance(String a, String b){
        double d = 0;
        for(int i=0; i<a.length(); i++){
            if(a.charAt(i) != b.charAt(i)){
                d++;
            }
        }
        return (int) Math.floor(d);
    }
    public static int CalcDMin(ArrayList<String> code ){
        int dMin = Integer.MAX_VALUE;
        for(int i=0; i<code.size(); i++){
            for(int j=0; j<code.size(); j++){
                if(i == j){
                    continue;
                } else {
                    int d = getDistance(code.get(i), code.get(j));
                    if(d < dMin){
                        dMin = d;
                    }
                }
            }
        }
        return dMin;
    }


    public static void main(String[] args) {
        try {
            String file = "src/inputs/input2.txt";
            ArrayList<String> code = getCode(file);
            int dMin = CalcDMin(code);
            System.out.println("Hibák észlelése: " + (dMin - 1));
            System.out.println("Hibák javítása: " + (dMin - 1)/2);


        } catch(Exception e){
            System.out.println(e.getMessage());
        }
    }
}