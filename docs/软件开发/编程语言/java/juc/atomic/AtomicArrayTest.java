package atomic;

import java.util.concurrent.atomic.AtomicReferenceArray;

public class AtomicArrayTest {

    public static void main(String[] args) {
        // 定义一个数
        String[] names = {"leiming", "wangrui","leiwen"};

        // 使用原子数组引用
        AtomicReferenceArray<String> array = new AtomicReferenceArray<>(names);

        System.out.println("[当前内容] :"+array);

        // 修改内容
        array.set(2,"zhaodongyan");

        System.out.println("[当前内容] :"+array);

        // 使用cas方法, 元数据不正确不会被修改

        array.compareAndSet(1, "?","yaojing");

        System.out.println("[当前内容] :"+array);

        // 使用cas方法

        array.compareAndSet(1, "wangrui","leiming2");

        System.out.println("[当前内容] :"+array);

    }
}
