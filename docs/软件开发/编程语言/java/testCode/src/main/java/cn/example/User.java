package cn.example;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity(name = "t_user")
public class User {
    @Id
    private long id;

    private String name;

    private int age;

    private int sex;
}
