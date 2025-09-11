public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, CS-210 in Java!");
        int sum = addNumbers(5, 10);
        System.out.println("5 + 10 = " + sum);
    }

    public static int addNumbers(int a, int b) {
        return a + b;
    }
}
