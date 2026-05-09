import com.google.gson.Gson;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 订阅
 */
@RestController
@RequestMapping
public class ControllerSubscribeData {

    public static final String SUBSCRIBE_URL = "订阅的地址(不包含host))";
    // 这是 json 转换工具
    public static final Gson gson = new Gson();

    @PostMapping(value = SUBSCRIBE_URL)
    public void subscribe(@RequestBody ServerRequest request) throws Exception{
        // 得到的返回
        System.out.println("这是返回体");
        System.out.println(request);
        // 获取数据
        Schoolmate data = gson.fromJson(request.getDataJson(),Schoolmate.class);
        System.out.println("这是返回数据");
        System.out.println(data);
    }

    /**
     * 服务请求体
     */
    public class ServerRequest {
        /** 集群id */
        private String clusterId;
        /** 数据节点id */
        private String dataNodeId;
        /** 数据定义id */
        private String dataDefineId;
        /** 订阅者id */
        private String subscribeId;
        /** 生产者id */
        private String producerId;
        /** 发布ID */
        protected String publishId;
        /**数据主键*/
        private String dataKey;
        /**数据值*/
        private String dataJson;

        public String getClusterId() {
            return clusterId;
        }

        public void setClusterId(String clusterId) {
            this.clusterId = clusterId;
        }

        public String getDataNodeId() {
            return dataNodeId;
        }

        public void setDataNodeId(String dataNodeId) {
            this.dataNodeId = dataNodeId;
        }

        public String getDataDefineId() {
            return dataDefineId;
        }

        public void setDataDefineId(String dataDefineId) {
            this.dataDefineId = dataDefineId;
        }

        public String getSubscribeId() {
            return subscribeId;
        }

        public void setSubscribeId(String subscribeId) {
            this.subscribeId = subscribeId;
        }

        public String getProducerId() {
            return producerId;
        }

        public void setProducerId(String producerId) {
            this.producerId = producerId;
        }

        public String getPublishId() {
            return publishId;
        }

        public void setPublishId(String publishId) {
            this.publishId = publishId;
        }

        public String getDataKey() {
            return dataKey;
        }

        public void setDataKey(String dataKey) {
            this.dataKey = dataKey;
        }

        public String getDataJson() {
            return dataJson;
        }

        public void setDataJson(String dataJson) {
            this.dataJson = dataJson;
        }
    }

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

    /**
     * <!-- json 转换工具 -->
     *<dependency>
     *    <groupId>com.google.code.gson</groupId>
     *    <artifactId>gson</artifactId>
     *    <version>2.8.7</version>
     *</dependency>
     * <!-- http请求工具 -->
     *<dependency>
     *    <groupId>com.squareup.okhttp3</groupId>
     *    <artifactId>okhttp</artifactId>
     *    <version>3.14.9</version>
     *</dependency>
     */

}

