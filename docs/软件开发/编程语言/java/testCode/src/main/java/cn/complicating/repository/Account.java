package cn.complicating.repository;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity(name = "account")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Account {
    @Id
    private long id;

    private double money;

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("帐号 : {");
        sb.append("id=").append(id);
        sb.append(", money=").append(money);
        sb.append('}');
        return sb.toString();
    }
}
