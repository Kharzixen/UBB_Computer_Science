import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

import static java.util.Collections.reverse;
import static java.util.Collections.sort;

public class Main {
    private static ArrayList<Node> ReadInput(String file) {
        try {
            ArrayList<Node> nodes = new ArrayList<>();
            BufferedReader br;
            String line;
            br = new BufferedReader(new FileReader(file));
            while ((line = br.readLine()) != null) {
                nodes.add(new Node(null, null, Double.parseDouble(line)));
            }
            return nodes;
            //System.out.println(nodes.size());
        } catch (IOException e) {
            System.out.println(e.getMessage());
            System.exit(-1);
            return null;
        }
    }

    private static ArrayList<Double> ReadRandomVariable(String file) {
        try {
            ArrayList<Double> probabilities = new ArrayList<>();
            BufferedReader br;
            String line;
            br = new BufferedReader(new FileReader(file));
            while ((line = br.readLine()) != null) {
                probabilities.add(Double.parseDouble(line));
            }
            return probabilities;
            //System.out.println(probabilities.size());
        } catch (IOException e) {
            System.out.println(e.getMessage());
            System.exit(-1);
            return null;
        }
    }

    private static Node GetHuffmanTree(ArrayList<Node> nodes) {
        while (nodes.size() > 1) {
            //search for the two smallest probability:
            int first = -1;
            double probFirst = 1;
            int second = -2;
            double probSecond = 1;
            for (int i = 0; i < nodes.size(); i++) {
                if (nodes.get(i).getProb() < probSecond && first != second) {
                    second = i;
                    probSecond = nodes.get(i).getProb();
                    if (probSecond < probFirst && first != second) {
                        int tmpInd = first;
                        double tmpProb = probFirst;
                        first = second;
                        probFirst = probSecond;
                        second = tmpInd;
                        probSecond = tmpProb;
                    }
                }
            }
            //get a new node from the smallest two
            Node newNode = new Node(nodes.get(first), nodes.get(second),
                    nodes.get(first).getProb() + nodes.get(second).getProb());
            newNode.setLeftEdge(0);
            newNode.setRightEdge(1);

            //remove the two nodes
            if (second > first) {
                nodes.remove(second);
                nodes.remove(first);
            } else {
                nodes.remove(first);
                nodes.remove(second);
            }
            nodes.add(newNode);
        }

        return nodes.get(0);
    }

    private static void DFSBinaryTree(Node node, Stack<String> s, Map<Double, String> res) {
        if (node.getRight() == null && node.getLeft() == null) {
            String output = "";
            for (String string : s) {
                output = output.concat(string);
            }
            res.put(node.getProb(), output);
            return;
        }

        s.push("0");
        DFSBinaryTree(node.getLeft(), s, res);
        s.pop();

        s.push("1");
        DFSBinaryTree(node.getRight(), s, res);
        s.pop();
    }

    private static Map<Double, String> GetCodeWords(Node root) {
        Map<Double, String> codeWords = new HashMap<>();
        DFSBinaryTree(root, new Stack<>(), codeWords);
        return codeWords;
    }

    private static void printCodeWords(Map<Double, String> res) {
        List<Double> keys = new ArrayList<>(res.keySet().stream().sorted().toList());
        reverse(keys);

        for (Double key : keys) {
            System.out.println(key + " - " + res.get(key));
        }
    }

    private static double log2(double logNumber) {
        return Math.log(logNumber) / Math.log(2);
    }

    private static Double GetEntropyOfRandomVariable(ArrayList<Double> probabilities) {
        double res = 0.0;
        for (Double prob : probabilities) {
            res += prob * log2(1 / prob);
        }
        return res;
    }

    private static Double GetAverageCodeLength(Map<Double, String> codes) {
        double res = 0.0;
        for (Double prob : codes.keySet()) {
            res += prob * codes.get(prob).length();
        }
        return res;
    }

    private static AbstractMap.SimpleEntry<ArrayList<Double>, ArrayList<Double>> GetPartition(ArrayList<Double> probabilities) {
        ArrayList<Double> left = new ArrayList<>();
        ArrayList<Double> right = new ArrayList<>();
        double minimum = 1.1;

        for (int i = 0; i < probabilities.size() / 2; i++) {
            ArrayList<Double> aux1 = new ArrayList<>(probabilities.subList(0, i + 1));
            ArrayList<Double> aux2 = new ArrayList<>(probabilities.subList(i + 1, probabilities.size()));
            double diff = Math.abs(aux1.stream()
                    .mapToDouble(a -> a)
                    .sum() - aux2.stream()
                    .mapToDouble(a -> a)
                    .sum());
            if (diff < minimum) {
                minimum = diff;
                left = aux1;
                right = aux2;
            }
        }
        //System.out.println(minimum);
        return new AbstractMap.SimpleEntry<>(left, right);
    }

    private static void ShannonFanoCode(ArrayList<Double> probabilities, Stack<String> stack, Map<Double, String> res) {
        if (probabilities.size() == 1) {
            String output = "";
            for (String s : stack) {
                output = output.concat(s);
            }
            res.put(probabilities.get(0), output);
            return;
        }

        AbstractMap.SimpleEntry<ArrayList<Double>, ArrayList<Double>> partition = GetPartition(probabilities);
        stack.push("0");
        ShannonFanoCode(partition.getKey(), stack, res);
        stack.pop();
        stack.push("1");
        ShannonFanoCode(partition.getValue(), stack, res);
        stack.pop();

    }

    private static Map<Double, String> GetShannonFanoCodeWords(ArrayList<Double> probabilities) {
        Map<Double, String> codeWords = new HashMap<>();
        ArrayList<Double> probabilities2 = new ArrayList<>(probabilities);
        Collections.sort(probabilities2);
        Collections.reverse(probabilities2);
        ShannonFanoCode(probabilities2, new Stack<>(), codeWords);
        return codeWords;
    }

    private static void TestHuffmanShanon(int n, String input) {

        int nrOfTests = 0;
        int passed = 0;

        BufferedReader br;
        String line;
        try {
            br = new BufferedReader(new FileReader(input));
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        }

        while (true) {
            Double huffmanLength = 0.0;
            Double shanonLength = 0.0;

            ArrayList<Node> nodes = new ArrayList<>();
            ArrayList<Double> probabilities = new ArrayList<>();
            try {
                if ((line = br.readLine()) == null) {
                    break;
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            nrOfTests++;
            String[] parts = line.split(" ");
            for (String part : parts) {
                nodes.add(new Node(null, null, Double.parseDouble(part)));
                probabilities.add(Double.parseDouble(part));
            }

            Node root = GetHuffmanTree(nodes);

            huffmanLength += GetAverageCodeLength(GetCodeWords(root));
            shanonLength += GetAverageCodeLength(GetShannonFanoCodeWords(probabilities));
            if(Objects.equals(String.format("%.6f", huffmanLength), String.format("%.6f", shanonLength))){
                passed++;
            }
        }

        System.out.println();
        System.out.println("N = " + n + " forrásszimbólum esetén: ");
        System.out.println("A tesztek " + (double) passed/nrOfTests*100 + "%-a esetén a kódhosszak megegyeznek! ");
        System.out.println("(" + passed + " sikeres |  " + nrOfTests + " teszteset)" );
    }

    public static void main(String[] args) {
        String file = "src/inputs/testInput3.txt";
        TestHuffmanShanon(3, file);

        file = "src/inputs/testInput4.txt";
        TestHuffmanShanon(4, file);
    }
}