import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Luke's Wiki",
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
      { text: 'Java', link: '/Java/' },
      { text: '数据库', link: '/数据库/' },
      { text: '前端', link: '/前端/' },
      { text: '架构设计', link: '/架构设计/' },
      { text: '项目管理', link: '/项目管理/' },
      { text: '运维', link: '/运维/' },
      { text: '产品经理', link: '/产品经理/' },
    ],
    sidebar: {
      '/AI/': [
        {
          text: '大模型基础',
          collapsed: true,
          items: [
            { text: '训练阶段', link: '/AI/大模型-基础/01-训练阶段' },
            { text: '特点与分类', link: '/AI/大模型-基础/02-特点与分类' },
            { text: '分词与词表', link: '/AI/大模型-基础/03-分词与词表' },
            { text: '应用场景', link: '/AI/大模型-基础/04-应用场景' },
          ]
        },
        {
          text: 'Spring AI',
          collapsed: false,
          items: [
            { text: '学习路径索引', link: '/AI/SpringAI/' },
            { text: '01 概述', link: '/AI/SpringAI/01-Spring-AI-概述' },
            { text: '02 Chat Memory', link: '/AI/SpringAI/02-ChatMemory-聊天记忆' },
            { text: '03 Tool Calling', link: '/AI/SpringAI/03-Tool-Calling-工具调用' },
            { text: '04 MCP 协议', link: '/AI/SpringAI/04-MCP-协议' },
            { text: '05 RAG', link: '/AI/SpringAI/05-RAG-检索增强生成' },
          ]
        },
      ],
      '/Java/': [
        {
          text: '核心',
          collapsed: true,
          items: [
            { text: 'Java8 新特性', link: '/Java/核心/Java8新特性' },
            { text: '集合框架', link: '/Java/核心/集合' },
            { text: '并发编程', link: '/Java/核心/并发编程' },
            { text: 'IO 与网络', link: '/Java/核心/IO与网络' },
            { text: '反射与代理', link: '/Java/核心/反射' },
          ]
        },
        {
          text: '框架',
          collapsed: true,
          items: [
            { text: 'Spring 核心', link: '/Java/框架/Spring' },
            { text: 'SpringMVC', link: '/Java/框架/SpringMVC' },
            { text: 'Spring Boot', link: '/Java/框架/SpringBoot' },
            { text: 'MyBatis', link: '/Java/框架/MyBatis' },
            { text: '分布式框架', link: '/Java/框架/分布式框架' },
            { text: '消息队列', link: '/Java/框架/消息队列' },
            { text: 'Quartz 调度', link: '/Java/框架/Quartz' },
            { text: 'Shiro 安全', link: '/Java/框架/Shiro' },
            { text: 'WebService', link: '/Java/框架/WebService' },
            { text: 'Activiti 工作流', link: '/Java/框架/Activiti' },
          ]
        },
        { text: 'Maven', link: '/Java/构建/Maven' },
        {
          text: '面试',
          collapsed: true,
          items: [
            { text: 'JVM 与 GC', link: '/Java/面试/JVM与GC' },
            { text: '多线程面试', link: '/Java/面试/多线程面试' },
            { text: '引用类型', link: '/Java/面试/引用类型' },
            { text: 'OutOfMemoryError', link: '/Java/面试/OutOfMemoryError' },
          ]
        },
      ],
      '/数据库/': [
        { text: 'MySQL', link: '/数据库/MySQL/高级/' },
        { text: 'Redis', link: '/数据库/Redis/' },
        { text: 'NoSQL', link: '/数据库/NoSlq/' },
      ],
      '/前端/': [
        { text: 'Vue', link: '/前端/Vue/' },
        { text: 'H5', link: '/前端/H5/' },
      ],
      '/架构设计/': [
        { text: '设计模式', link: '/架构设计/设计模式/' },
        { text: '分布式', link: '/架构设计/分布式/' },
      ],
      '/项目管理/': [
        { text: '项目管理', link: '/项目管理/' },
      ],
      '/运维/': [
        { text: 'Linux', collapsed: true, items: [
          { text: '01 Linux 入门', link: '/运维/Linux/01-Linux-入门' },
          { text: '02 目录与文件命令', link: '/运维/Linux/02-目录与文件命令' },
          { text: '03 系统命令', link: '/运维/Linux/03-系统命令' },
        ]},
        { text: 'Shell 编程', collapsed: true, items: [
          { text: '04 Shell 变量', link: '/运维/Shell/04-Shell-变量' },
          { text: '05 Shell 运算符', link: '/运维/Shell/05-Shell-运算符' },
        ]},
        { text: 'ELK 日志平台', collapsed: true, items: [
          { text: 'ELK 入门', link: '/运维/ELK/ELK-入门' },
          { text: '日志收集工具对比', link: '/运维/ELK/日志收集工具对比' },
        ]},
        { text: '性能优化', link: '/运维/性能优化/性能优化理论' },
      ],
      '/产品经理/': [
        { text: '产品经理学习资源', link: '/产品经理/产品经理学习资源' },
      ],
    },
    search: {
      provider: 'local',
      options: { detailedView: true }
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