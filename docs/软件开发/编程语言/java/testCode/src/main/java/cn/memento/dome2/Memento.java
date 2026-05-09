package cn.memento.dome2;

/**
 * @author luke
 * @date
 */

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Memento implements Serializable {

    private static final long serialVersionUID = 8497203738547925495L;

    private int menoy;
    private ArrayList fruits;

    //窄接口，访问部分信息
    public int getMenoy(){
        return menoy;
    }

    //宽接口，本包之内皆可访问
    Memento(int menoy){
        this.menoy=menoy;
        fruits=new ArrayList();//每次调用的时候重新生成，很重要
    }
    //宽接口，本包之内皆可访问
    List getFruits(){
        return (List) fruits.clone();
    }
    //宽接口，本包之内皆可访问
    void  addFruits(String fruit){
        fruits.add(fruit);
    }

}
