package cn.memento.dome2;

/**
 * @author luke
 * @date
 */

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

public class Gamer {

    private static final String[] FruitsSame = {"香蕉", "苹果", "橘子", "柚子"};

    private int menoy;
    private List fruits = new ArrayList();
    private final Random random = new Random();

    public Gamer(int menoy) {
        this.menoy = menoy;
    }

    public int getMenoy() {
        return menoy;
    }

    public void bet() {
        int next = random.nextInt(6) + 1;
        if (next == 1) {
            menoy += 100;
            System.out.println("金钱增加了100,当前金钱为：" + menoy);
        } else if (next == 2) {
            menoy /= 2;
            System.out.println("金钱减少了一半，当前金钱为：" + menoy);
        } else if (next == 6) {
            String f = getFruit();
            fruits.add(f);
            System.out.println("获得了水果:" + f + "，当前金钱为：" + menoy);
        } else {
            System.out.println("金钱没有发生改变，当前金钱为：" + menoy);
        }
    }

    private String getFruit() {

        String prefix = "";
        if (random.nextBoolean()) {
            prefix = "好吃的";
        }
        return prefix + FruitsSame[random.nextInt(FruitsSame.length)];

    }

    public Memento createMemento() {
        Memento m = new Memento(menoy);
        Iterator it = fruits.iterator();
        while (it.hasNext()) {
            String fruit = (String) it.next();
            if (fruit.startsWith("好吃的")) {
                m.addFruits(fruit);
            }
        }
        return m;
    }

    /**
     * 恢复备忘录
     *
     * @param memento
     */
    public void restoreMemento(Memento memento) {
        this.menoy = memento.getMenoy();
        this.fruits = memento.getFruits();
    }

    public String toString() {
        return "Menoy：" + menoy + " ,Fruits:" + fruits;
    }

}