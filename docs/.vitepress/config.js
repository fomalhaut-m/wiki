import { defineConfig } from 'vitepress'

export default defineConfig({
  title: '雷鸣的知识库',
  description: '个人知识沉淀与技术笔记',

  base: '/',

  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }]
  ],

  themeConfig: {
    repo: 'fomalhaut-m/wike',
    repoLabel: 'GitHub',

    nav: [
      { text: '首页', link: '/' },
      { text: 'AI', link: '/AI/' },
      { text: '软件开发', link: '/软件开发/' },
      { text: '项目管理', link: '/项目管理/' },
      { text: '产品经理', link: '/产品经理/' },
      { text: '运维与工具', link: '/运维与工具/' },
    ],

    sidebar: {
      '/AI/': [
        { text: 'AI', items: [
          { text: '大模型基础', link: '/AI/' },
          { text: 'AI-Agent入门', link: '/AI/AI-Agent入门' },
        ]}
      ],

      '/软件开发/': [
        {
          text: 'Java',
          collapsed: true,
          items: [
            { text: 'Java知识体系', link: '/软件开发/Java/Java知识体系' },
            { text: 'Java8新特性', link: '/软件开发/Java/Java8新特性' },
            { text: 'Java NIO入门', link: '/软件开发/Java/JavaNIO入门' },
            { text: 'Java并发编程', link: '/软件开发/Java/Java并发编程' },
            { text: 'Java反射机制', link: '/软件开发/Java/Java反射机制' },
            { text: 'Java集合体系', link: '/软件开发/Java/Java集合体系' },
            { text: 'Java网络编程', link: '/软件开发/Java/Java网络编程' },
            { text: 'Java多线程基础', link: '/软件开发/Java/Java多线程基础' },
            { text: 'Java IO编程', link: '/软件开发/Java/JavaIO编程' },
            { text: '设计模式', link: '/软件开发/Java/设计模式' },
            { text: 'UML类图关系', link: '/软件开发/Java/UML类图关系' },
            { text: '单例模式', link: '/软件开发/Java/单例模式' },
            { text: '创建型设计模式', link: '/软件开发/Java/创建型设计模式' },
            { text: '结构型设计模式', link: '/软件开发/Java/结构型设计模式' },
            { text: '行为型设计模式', link: '/软件开发/Java/行为型设计模式' },
            { text: '重构知识体系', link: '/软件开发/Java/重构知识体系' },
          ]
        },
        {
          text: '数据库',
          collapsed: true,
          items: [
            { text: 'Redis快速上手', link: '/软件开发/数据库/Redis快速上手' },
            { text: 'Redis事务', link: '/软件开发/数据库/Redis事务' },
            { text: 'MySQL快速上手', link: '/软件开发/数据库/MySQL快速上手' },
            { text: 'MySQL索引详解', link: '/软件开发/数据库/MySQL索引详解' },
            { text: 'MySQL逻辑架构', link: '/软件开发/数据库/MySQL逻辑架构' },
            { text: 'MySQL-Explain分析', link: '/软件开发/数据库/MySQL-Explain分析' },
            { text: 'NoSQL入门', link: '/软件开发/数据库/NoSQL入门' },
          ]
        },
        {
          text: '前端',
          collapsed: true,
          items: [
            { text: 'Vue快速上手', link: '/软件开发/前端/Vue快速上手' },
          ]
        },
        {
          text: '框架',
          collapsed: true,
          items: [
            { text: '消息队列', link: '/软件开发/框架/消息队列' },
            { text: 'MyBatis快速上手', link: '/软件开发/框架/MyBatis快速上手' },
            { text: 'Spring Boot快速上手', link: '/软件开发/框架/SpringBoot快速上手' },
            { text: 'Spring Cloud微服务', link: '/软件开发/框架/SpringCloud微服务' },
            { text: 'Kafka快速上手', link: '/软件开发/框架/Kafka快速上手' },
            { text: 'Shiro安全框架', link: '/软件开发/框架/Shiro安全框架' },
            { text: 'OAuth2入门', link: '/软件开发/框架/OAuth2入门' },
            { text: 'Dubbo入门', link: '/软件开发/框架/Dubbo入门' },
            { text: 'Zookeeper入门', link: '/软件开发/框架/Zookeeper入门' },
          ]
        },
        {
          text: '架构设计',
          collapsed: true,
          items: [
            { text: '架构设计原则', link: '/软件开发/架构设计/架构设计原则' },
            { text: '限流熔断降级', link: '/软件开发/架构设计/限流熔断降级' },
            { text: '限流方案详解', link: '/软件开发/架构设计/限流方案详解' },
            { text: '熔断器对比', link: '/软件开发/架构设计/熔断器对比' },
            { text: 'AKF扩展模型', link: '/软件开发/架构设计/AKF扩展模型' },
            { text: '分布式系统特征', link: '/软件开发/架构设计/分布式系统特征' },
            { text: 'HTTP协议详解', link: '/软件开发/架构设计/HTTP协议详解' },
            { text: 'TCP协议详解', link: '/软件开发/架构设计/TCP协议详解' },
            { text: '数据结构与算法', link: '/软件开发/架构设计/数据结构与算法' },
          ]
        },
      ],

      '/项目管理/': [
        { text: '项目管理', items: [
          { text: 'PMP认证', link: '/项目管理/' },
        ]}
      ],

      '/产品经理/': [
        { text: '产品经理', items: [
          { text: '产品经理学习资源', link: '/产品经理/' },
        ]}
      ],

      '/运维与工具/': [
        { text: '运维与工具', items: [
          { text: '工程实践规范', link: '/运维与工具/' },
        ]}
      ],
    },

    search: {
      provider: 'local',
      options: {
        detailedView: true
      }
    },

    editLink: {
      pattern: 'https://github.com/fomalhaut-m/wike/edit/main/docs/:path',
      text: '在 GitHub 上编辑此页'
    },

    footer: {
      message: '基于 VitePress 构建',
      copyright: 'Copyright © 2024 Luke Lei'
    }
  }
})