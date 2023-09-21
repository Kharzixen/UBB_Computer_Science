public class Node {
    private Node left;
    private String leftEdge;
    private Node right;
    private String rightEdge;

    public String getLeftEdge() {
        return leftEdge;
    }

    public void setLeftEdge(int leftEdge) {
        this.leftEdge = Integer.toString(leftEdge);
    }

    public String getRightEdge() {
        return rightEdge;
    }

    public void setRightEdge(int rightEdge) {
        this.rightEdge = Integer.toString(rightEdge);
    }

    private double prob;

    public Node(Node left, Node right, double prob) {
        this.left = left;
        this.right = right;
        this.prob = prob;
    }

    public Node getLeft() {
        return left;
    }

    public void setLeft(Node left) {
        this.left = left;
    }

    public Node getRight() {
        return right;
    }

    public void setRight(Node right) {
        this.right = right;
    }

    public double getProb() {
        return prob;
    }

    public void setProb(double prob) {
        this.prob = prob;
    }
}
