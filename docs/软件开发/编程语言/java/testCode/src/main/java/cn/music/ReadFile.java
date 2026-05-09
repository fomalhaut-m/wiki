package cn.music;


import com.google.common.collect.Lists;
import org.jaudiotagger.audio.AudioFile;
import org.jaudiotagger.audio.AudioHeader;
import org.jaudiotagger.audio.exceptions.InvalidAudioFrameException;
import org.jaudiotagger.audio.exceptions.ReadOnlyFileException;
import org.jaudiotagger.audio.mp3.MP3FileReader;
import org.jaudiotagger.tag.FieldKey;
import org.jaudiotagger.tag.Tag;
import org.jaudiotagger.tag.TagException;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class ReadFile {
    /**
     * 阅读目录
     *
     * @param directory 目录
     * @return 列表<音频文件>
     */
    public List<AudioFile> readDirectory(String directory) {
        return readDirectory(directory, null);
    }

    /**
     * 阅读目录
     *
     * @param directory 目录
     * @return 列表<音频文件>
     */
    public List<AudioFile> readDirectory(String directory, Predicate<String> fileNameFilter) {
        File file = new File(directory);

        String[] list = file.list();

        ArrayList<String> fileNames = Lists.newArrayList(list);

        return fileNames
                .stream()
                // 自定义过滤
                .filter(fileName -> fileNameFilter == null || fileNameFilter.test(fileName))
                // 过滤 “.”开头的文件
                .filter(o -> !o.startsWith(".")).map(fileName -> {
                    return readFile(directory + "\\" + fileName);
                })
                // 过滤空
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    /**
     * 读取文件
     *
     * @param fileUrl 文件路径
     * @return 音频文件
     */
    public AudioFile readFile(String fileUrl) {
        File file = new File(fileUrl);
        MP3FileReader reader = new MP3FileReader();
        AudioFile audioFile = null;

        try {
            audioFile = reader.read(file);
        } catch (IOException e) {
            System.out.println("IO 异常" + fileUrl);
            return null;
        } catch (TagException e) {
            System.out.println("标记异常" + fileUrl);
            return null;
        } catch (ReadOnlyFileException e) {
            System.out.println("只读文件异常" + fileUrl);
            return null;
        } catch (InvalidAudioFrameException e) {
            System.out.println("无效音频帧异常" + fileUrl);
            return null;
        }

        return audioFile;
    }

    public MusicInfo analyseFile(AudioFile audioFile) {
        System.out.println(audioFile);
        AudioHeader audioHeader = audioFile.getAudioHeader();
        // 获取比特率
        System.out.println("获取比特率 = " + audioHeader.getBitRate());
        // 获取比特率作为数字
        System.out.println("获取比特率作为数字 = " + audioHeader.getBitRateAsNumber());
        // 获取频道
        System.out.println("获取频道 = " + audioHeader.getChannels());
        // 获取编码类型
        System.out.println("获取编码类型 = " + audioHeader.getEncodingType());
        // 获取格式
        System.out.println("获取格式 = " + audioHeader.getFormat());
        // 获取采样率
        System.out.println("获取采样率 = " + audioHeader.getSampleRate());
        // 获取采样率作为数字
        System.out.println("获取采样率作为数字 = " + audioHeader.getSampleRateAsNumber());
        // 获取轨道长度
        System.out.println("获取轨道长度 = " + audioHeader.getTrackLength());

        Tag tag = audioFile.getTag();

        return MusicInfo.builder()
                .file(audioFile.getFile())
                .album(tag == null ? null : tag.getFirst(FieldKey.ALBUM))
                .albumArtist(tag == null ? null : tag.getFirst(FieldKey.ALBUM_ARTIST))
                .albumArtistSort(tag == null ? null : tag.getFirst(FieldKey.ALBUM_ARTIST_SORT))
                .albumSort(tag == null ? null : tag.getFirst(FieldKey.ALBUM_SORT))
                .amazonId(tag == null ? null : tag.getFirst(FieldKey.AMAZON_ID))
                .artist(tag == null ? null : tag.getFirst(FieldKey.ARTIST))
                .artistSort(tag == null ? null : tag.getFirst(FieldKey.ARTIST_SORT))
                .barcode(tag == null ? null : tag.getFirst(FieldKey.BARCODE))
                .catalogNo(tag == null ? null : tag.getFirst(FieldKey.CATALOG_NO))
                .comment(tag == null ? null : tag.getFirst(FieldKey.COMMENT))
                .composer(tag == null ? null : tag.getFirst(FieldKey.COMPOSER))
                .composerSort(tag == null ? null : tag.getFirst(FieldKey.COMPOSER_SORT))
                .conductor(tag == null ? null : tag.getFirst(FieldKey.CONDUCTOR))
                .coverArt(tag == null ? null : tag.getFirst(FieldKey.COVER_ART))
                .discNo(tag == null ? null : tag.getFirst(FieldKey.DISC_NO))
                .discTotal(tag == null ? null : tag.getFirst(FieldKey.DISC_TOTAL))
                .encoder(tag == null ? null : tag.getFirst(FieldKey.ENCODER))
                .genre(tag == null ? null : tag.getFirst(FieldKey.GENRE))
                .grouping(tag == null ? null : tag.getFirst(FieldKey.GROUPING))
                .isCompilation(tag == null ? null : tag.getFirst(FieldKey.IS_COMPILATION))
                .key(tag == null ? null : tag.getFirst(FieldKey.KEY))
                .language(tag == null ? null : tag.getFirst(FieldKey.LANGUAGE))
                .lyricist(tag == null ? null : tag.getFirst(FieldKey.LYRICIST))
                .lyrics(tag == null ? null : tag.getFirst(FieldKey.LYRICS))
                .media(tag == null ? null : tag.getFirst(FieldKey.MEDIA))
                .mood(tag == null ? null : tag.getFirst(FieldKey.MOOD))
                .occasion(tag == null ? null : tag.getFirst(FieldKey.OCCASION))
                .originalAlbum(tag == null ? null : tag.getFirst(FieldKey.ORIGINAL_ALBUM))
                .originalArtist(tag == null ? null : tag.getFirst(FieldKey.ORIGINAL_ARTIST))
                .originalLyricist(tag == null ? null : tag.getFirst(FieldKey.ORIGINAL_LYRICIST))
                .quality(tag == null ? null : tag.getFirst(FieldKey.QUALITY))
                .rating(tag == null ? null : tag.getFirst(FieldKey.RATING))
                .recordLabel(tag == null ? null : tag.getFirst(FieldKey.RECORD_LABEL))
                .remixer(tag == null ? null : tag.getFirst(FieldKey.REMIXER))
                .tags(tag == null ? null : tag.getFirst(FieldKey.TAGS))
                .tempo(tag == null ? null : tag.getFirst(FieldKey.TEMPO))
                .title(tag == null ? null : tag.getFirst(FieldKey.TITLE))
                .titleSort(tag == null ? null : tag.getFirst(FieldKey.TITLE_SORT))
                .urlWikipediaReleaseSite(tag == null ? null : tag.getFirst(FieldKey.URL_WIKIPEDIA_RELEASE_SITE))
                .year(tag == null ? null : tag.getFirst(FieldKey.YEAR))
                .engineer(tag == null ? null : tag.getFirst(FieldKey.ENGINEER))
                .producer(tag == null ? null : tag.getFirst(FieldKey.PRODUCER))
                .mixer(tag == null ? null : tag.getFirst(FieldKey.MIXER))
                .arranger(tag == null ? null : tag.getFirst(FieldKey.ARRANGER))
                .build();
    }


}
