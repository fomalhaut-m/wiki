package atomic;

import java.time.Year;
import java.util.concurrent.atomic.AtomicReferenceArray;
import java.util.concurrent.atomic.DoubleAccumulator;
import java.util.concurrent.atomic.DoubleAdder;

public class AtomicAddTest {

    public static void main(String[] args) {

        DoubleAccumulator da = new DoubleAccumulator(
                // 累加函数
                (x, y) -> x + y,
                // 初始值
                0d
        );

        da.accumulate(1.0);

        System.out.println(" 结果 : "+da);
        da.accumulate(3);

        System.out.println(" 结果 : "+da);
        da.accumulate(5.0);

        System.out.println(" 结果 : "+da);


        DoubleAdder adder = new DoubleAdder();

        adder.add(2.0);

        System.out.println("add = "+adder);
        adder.add(2.0);

        System.out.println("add = "+adder);


    }
}
