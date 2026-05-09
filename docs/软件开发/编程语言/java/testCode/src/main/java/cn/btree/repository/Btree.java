package cn.btree.repository;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity(name = "b_tree")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Btree {
    @Id@GeneratedValue(strategy= GenerationType.IDENTITY)
    private long id;

    private long creationTime;

}
