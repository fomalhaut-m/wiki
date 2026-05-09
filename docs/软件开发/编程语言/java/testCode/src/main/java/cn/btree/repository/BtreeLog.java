package cn.btree.repository;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity(name = "b_tree_log")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BtreeLog {
    @Id@GeneratedValue(strategy= GenerationType.IDENTITY)
    private long id;

    private long creationTime;

    private long frequency;

}
