package cn.music;

import lombok.Builder;

import java.io.File;

@Builder
public class MusicInfo {
    /** 专辑 */
    private final File file;
    /** 专辑 */
    private final String album;
    /** 专辑的艺术家 */
    private final String albumArtist;
    /** 专辑的艺术家排序 */
    private final String albumArtistSort;
    /** 专辑排序 */
    private final String albumSort;
    /** 亚马逊ID */
    private final String amazonId;
    /** 艺术家 */
    private final String artist;
    /** 艺术家排序 */
    private final String artistSort;
    /** 条形码 */
    private final String barcode;
    /** 目录编号 */
    private final String catalogNo;
    /** 评论 */
    private final String comment;
    /** 作曲家 */
    private final String composer;
    /** 作曲家排序 */
    private final String composerSort;
    /** 导体 */
    private final String conductor;
    /** 封面 */
    private final String coverArt;
    /** 盘号 */
    private final String discNo;
    /** 盘总 */
    private final String discTotal;
    /** 编码器 */
    private final String encoder;
    /** 类型 */
    private final String genre;
    /** 分组 */
    private final String grouping;
    /** 是编译 */
    private final String isCompilation;
    /** 关键 */
    private final String key;
    /** 语言 */
    private final String language;
    /** 抒情诗人 */
    private final String lyricist;
    /** 歌词 */
    private final String lyrics;
    /** 媒体 */
    private final String media;
    /** 情绪 */
    private final String mood;
    /** 场合 */
    private final String occasion;
    /** 原始的专辑 */
    private final String originalAlbum;
    /** 原始艺术家 */
    private final String originalArtist;
    /** 原始的抒情诗人 */
    private final String originalLyricist;
    /** 质量 */
    private final String quality;
    /** 评级 */
    private final String rating;
    /** 唱片公司 */
    private final String recordLabel;
    /** 混音师 */
    private final String remixer;
    /** 标签 */
    private final String tags;
    /** 节奏 */
    private final String tempo;
    /** 标题 */
    private final String title;
    /** 标题排序 */
    private final String titleSort;
    /** 维基百科发布网站 */
    private final String urlWikipediaReleaseSite;
    /** 年 */
    private final String year;
    /** 工程师 */
    private final String engineer;
    /** 生产商 */
    private final String producer;
    /** 混合机 */
    private final String mixer;
    /** 编曲 */
    private final String arranger;
}
