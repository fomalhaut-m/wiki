package atomic;

import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

public class AtomicBasicTest {

    public static void main(String[] args) {
        AtomicInteger atomicInteger = new AtomicInteger();

        atomicInteger.addAndGet(1);

        System.out.println(atomicInteger);

        AtomicLong atomicLong = new AtomicLong();
        //  = 0 . 没有修改
        atomicLong.compareAndSet( 0,2 );

        System.out.println(atomicLong);
        // = 1 . 修改了
        atomicLong.compareAndSet( 1,2 );

        System.out.println(atomicLong);

        AtomicBoolean atomicBoolean = new AtomicBoolean();

        atomicBoolean.compareAndSet(true, true);
        // = false . 没有修改
        System.out.println(atomicBoolean);

        atomicBoolean.compareAndSet(false,true);
        // true . 修改了
        System.out.println(atomicBoolean);
    }
}
