import com.google.gson.Gson;
import okhttp3.*;

import java.io.IOException;

/**
 * 发布
 */
public class HttpPublishData {

    // 这是 json 转换工具
    private static final Gson gson = new Gson();

    private static final String HOST = "http://192.168.0.17:8899";
    private static final String REQUEST_PATH = HOST + "/external/inter/publish";
    private static final String MEDIA_TYPE = "application/json";
    /** 发布Id */
    private static final String publishId = "publishId";
    /** 节点标识 */
    private static final String dataNodeId = "dataNodeId";
    /** 节点秘钥 */
    private static final String dataNodeSecretKey = "dataNodeSecretKey";

    public static void main(String[] args) throws IOException {
        send();
    }
    public static void send() throws IOException {
        // 请求体
        ServiceRequest serviceRequest = new ServiceRequest();
        // 发布Id
        serviceRequest.setPublishId(publishId);
        // 节点标识
        serviceRequest.setDataNodeId(dataNodeId);
        // 节点秘钥
        serviceRequest.setDataNodeSecretKey(dataNodeSecretKey);
        // 数据主键
        serviceRequest.setPrimaryKey("todo : primaryKey 是需要发布数据的唯一标识 ");
        // 发布数据
        serviceRequest.setPublishData(gson.toJson(new Schoolmate()));

        // 请求
        OkHttpClient client = new OkHttpClient().newBuilder().build();
        RequestBody body = RequestBody.Companion.create(gson.toJson(serviceRequest),MediaType.parse(MEDIA_TYPE));
        Request request = new Request.Builder().url(REQUEST_PATH).method("POST", body).build();
        Response response = null;
        try {
            response = client.newCall(request).execute();
        } catch (IOException e) {
            // todo: HTTP 请求异常
            System.out.println("HTTP 请求异常");
            throw e;
        }

        // 获取结果
        ResponseBody responseBody = response.body();
        try {
            ServiceResponse serviceResponse = gson.fromJson(responseBody.string(), ServiceResponse.class);
            if (10000 == serviceResponse.getMessageCode()) {
                System.out.println("数据发布成功");
            }else {
                System.out.println("失败原因:"+serviceResponse.getMessage());
            }
        } catch (IOException e) {
            // todo: HTTP 返回异常
            System.out.println("HTTP 返回异常");
            throw e;
        }
    }

    /** 服务请求 */
    public static class ServiceRequest {
        /** 发布Id */
        private String publishId;
        /** 数据主键 */
        private String primaryKey;
        /** 节点标识 */
        private String dataNodeId;
        /** 节点秘钥 */
        private String dataNodeSecretKey;
        /** 发布数据json */
        private String publishData;
        public String getPublishId() {
            return publishId;
        }
        public void setPublishId(String publishId) {
            //发布Id不能为空
            assert  publishId!=null;
            this.publishId = publishId;
        }
        public String getPrimaryKey() {
            return primaryKey;
        }
        public void setPrimaryKey(String primaryKey) {
            //数据主键不能为空
            assert  primaryKey!=null;
            this.primaryKey = primaryKey;
        }
        public String getDataNodeId() {
            return dataNodeId;
        }
        public void setDataNodeId(String dataNodeId) {
            //节点标识不能为空
            assert  dataNodeId!=null;
            this.dataNodeId = dataNodeId;
        }
        public String getDataNodeSecretKey() {
            return dataNodeSecretKey;
        }
        public void setDataNodeSecretKey(String dataNodeSecretKey) {
            //节点秘钥不能为空
            assert  dataNodeSecretKey!=null;
            this.dataNodeSecretKey = dataNodeSecretKey;
        }
        public String getPublishData() {
            return publishData;
        }
        public void setPublishData(String publishData) {
            //发布数据json不能为空
            assert publishData!=null;
            this.publishData = publishData;
        }
    }

    /** 服务响应 */
    public class ServiceResponse<T> {

        /** 响应状态码(10000=成功，10001=失败） */
        private int messageCode;

        /** 响应状态消息 */
        private String message;

        /** 响应数据 */
        private T data;

        public int getMessageCode() {
            return messageCode;
        }

        public void setMessageCode(int messageCode) {
            this.messageCode = messageCode;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public T getData() {
            return data;
        }

        public void setData(T data) {
            this.data = data;
        }
    }

    /** 数据定义 : 同学 */
    public static class Schoolmate{
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

