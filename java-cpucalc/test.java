package com.example.myapp;


import static java.lang.Math.*;

class ThreadDemo extends Thread {
    private Thread t;
    private String threadName;

    ThreadDemo(String name) {
        threadName = name;
        System.out.println("Creating " + threadName);
    }

    public void run() {
        System.out.println("Running " + threadName);

        System.out.println("Thread: " + threadName);
        double degrees = 45.0;
        double radians = toRadians(degrees);
        while (true) {
            double multisin = sin(sin(sin(sin(radians))));
            System.out.println(threadName + ": " + multisin);
        }
    }

    public void start() {
        System.out.println("Starting " + threadName);
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
