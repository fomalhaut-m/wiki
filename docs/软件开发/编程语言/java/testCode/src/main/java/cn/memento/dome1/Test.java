package cn.memento.dome1;


public class Test {

    public static void main(String[] args) {
        Gamer gamer = new Gamer(100);
        Memento memento = gamer.createMemento();
        for (int i = 0; i < 100; i++) {
            System.out.println("当前状态：" + i);
            System.out.println("当前金额：" + gamer.getMenoy());
            gamer.bet();
            if (gamer.getMenoy() < memento.getMenoy() / 2) {

                System.out.println("金钱过少，恢复到以前的状态：");
                gamer.restoreMemento(memento);
                System.out.println("此时状态为：" + gamer);

            } else if (gamer.getMenoy() > memento.getMenoy()) {

                System.out.println("金钱增多，保存当前状态：");
                memento = gamer.createMemento();
                System.out.println("此时状态为：" + gamer);

            }
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }

}