package cn.btree;

import cn.Application;
import cn.btree.repository.Btree;
import com.google.gson.Gson;
import lombok.extern.slf4j.Slf4j;
import org.databene.contiperf.PerfTest;
import org.databene.contiperf.junit.ContiPerfRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.Instant;
import java.util.List;

@Slf4j(topic = "并发测试")
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
public class BTreeServiceTest {

    @Autowired
    BTreeService bTreeService;

    @Rule
    public ContiPerfRule contiPerfRule = new ContiPerfRule();

    /**
     * save
     */
    @Test
    @PerfTest(invocations = 20000, threads = 20)
    public void save(){
        bTreeService.save(10000);;
    }

    /**
     * save
     */
    @Test
    public void select1000() throws IOException {
        List<Long> select = bTreeService.selectDifference(190708573);

        String json = new Gson().toJson(select);
        System.out.println(json);

        File file = new File("/json.json");
        if (!file.exists()) {
            file.createNewFile();
        }
        FileOutputStream fileOutputStream = new FileOutputStream(file);

        fileOutputStream.write(json.getBytes());

        fileOutputStream.close();
    }

    /**
     * save
     */
    @Test
    public void calculateQuerySpeed() throws IOException {
        System.out.println(Instant.now().getEpochSecond());
        System.out.println(bTreeService.selectOne(100000000L));
        System.out.println(Instant.now().getEpochSecond());
    }
}