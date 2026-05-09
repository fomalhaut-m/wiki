package cn.music;

import org.junit.Test;

import java.util.stream.Collectors;

public class ReadFileTest {
    ReadFile readFile = new ReadFile();

    @Test
    public void readDirectoryTest() {
        System.out.println(readFile.readDirectory("D:\\Music")
                .stream()
                .map(readFile::analyseFile)
                .collect(Collectors.toList()));
    }
}