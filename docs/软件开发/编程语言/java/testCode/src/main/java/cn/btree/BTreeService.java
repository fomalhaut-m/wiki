package cn.btree;

import cn.btree.repository.Btree;
import cn.btree.repository.BtreeLog;
import cn.btree.repository.BtreeLogRepository;
import cn.btree.repository.BtreeRepository;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

@Slf4j(topic = "B树服务")
@Service
public class BTreeService {

    @Autowired
    BtreeRepository btreeRepository;
    @Autowired
    BtreeLogRepository logRepository;

    public void save(int num) {

        long creationTime = Instant.now().getEpochSecond();

        for (int i = 0; i < num; i++) {
            Btree entity = new Btree();
            entity.setCreationTime(creationTime);
            btreeRepository.save(entity);
        }
        BtreeLog entity = new BtreeLog();
        entity.setCreationTime(creationTime);
        entity.setFrequency(num);
        logRepository.save(entity);
    }

    public List<Long> selectDifference(long i) {
        long id = 1L;
        List<Long> ids = Lists.newArrayList();
        for (long j = 0; j <= 1000; j++) {
            ids.add(id);
            id = id += 200000L;
        }

        List<Btree> allById = btreeRepository.findAllById(ids);

        List<Long> difference = Lists.newArrayList();

        for (int index = 0; index < allById.size(); index++) {
            try{
            Btree btree1 = allById.get(index);
            Btree btree2 = allById.get(index + 1);
           difference.add( btree2.getCreationTime() - btree1.getCreationTime());}catch (Exception e){}
        }

        return difference;
    }

    public Btree selectOne(long i) {
       return btreeRepository.getOne(i);
    }
}
