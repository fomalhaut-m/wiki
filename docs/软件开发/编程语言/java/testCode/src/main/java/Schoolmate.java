import java.lang.*;

/** 数据定义 : 同学 */
public class Schoolmate{
    /**
     *  主键ID,唯一键
     *  <p>
     *  可空 = false
     *  <p>
     *  主键ID,唯一键
     */
    private String id;
    /**
     *  名称
     *  <p>
     *  可空 = true
     *  <p>
     *  同学的名称,他是身份证的名称
     */
    private String name;
    /**
     *  年龄
     *  <p>
     *  可空 = false
     *  <p>
     *  这是同学的年龄
     */
    private String age;
    /**
     *  入学时间
     *  <p>
     *  可空 = false
     *  <p>
     *  这个学生今年入学时间
     */
    private String admissionTime;
    /**
     *  备注
     *  <p>
     *  可空 = false
     *  <p>
     *  这里填写一些其他信息
     */
    private String remark;

    /** 主键ID,唯一键 */
    public void setId(String id) {
        this.id = id;
    }
    /** 主键ID,唯一键 */
    public String getId() {
        return id;
    }
    /** 名称 */
    public void setName(String name) {
        this.name = name;
    }
    /** 名称 */
    public String getName() {
        return name;
    }
    /** 年龄 */
    public void setAge(String age) {
        this.age = age;
    }
    /** 年龄 */
    public String getAge() {
        return age;
    }
    /** 入学时间 */
    public void setAdmissionTime(String admissionTime) {
        this.admissionTime = admissionTime;
    }
    /** 入学时间 */
    public String getAdmissionTime() {
        return admissionTime;
    }
    /** 备注 */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    /** 备注 */
    public String getRemark() {
        return remark;
    }
}

