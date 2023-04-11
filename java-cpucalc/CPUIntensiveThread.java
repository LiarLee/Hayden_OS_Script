import static java.lang.Math.*;

class ThreadDemo extends Thread {
    private Thread t;
    private String threadName;

    ThreadDemo(String name) {
        threadName = name;
    }

    public void run() {
        double degrees = 45.0;
        double radians = toRadians(degrees);
        while (true) {
            double multisin = sin(sin(sin(sin(radians))));
        }
    }

    public void start() {
        if (t == null) {
            t = new Thread(this, threadName);
            t.start();
        }
    }
}

public class CPUIntensiveThread {

    public static void main(String[] args) {
        ThreadDemo T1 = new ThreadDemo("Thread-1");
        T1.start();

        ThreadDemo T2 = new ThreadDemo("Thread-2");
        T2.start();

        ThreadDemo T3 = new ThreadDemo("Thread-3");
        T3.start();

        ThreadDemo T4 = new ThreadDemo("Thread-4");
        T4.start();

    }
}
