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
      { text: '软件开发', link: '/软件开发/' },
      { text: '产品经理', link: '/产品经理/' },
      { text: '项目管理', link: '/项目管理/' },
      { text: '书籍', link: '/书籍/' },
      { text: '字典', link: '/字典/' },
      { text: '关于', link: '/我的/' },
    ],
    sidebar: {
      '/AI/': [
        {
          text: 'AI技术',
          items: [
            { text: 'AI Agent', link: '/AI/Ai Agent' },
            { text: '大模型基础', link: '/AI/大模型 - 基础篇' },
          ]
        }
      ],
      '/软件开发/': [
        {
          text: '编程语言',
          items: [
            { text: 'Java', link: '/软件开发/编程语言/Java' },
            { text: 'C#', link: '/软件开发/编程语言/C#' },
            { text: 'Python', link: '/软件开发/Python' },
          ]
        },
        {
          text: '前端技术',
          items: [
            { text: 'Vue', link: '/软件开发/前端技术/VUE' },
            { text: 'Vue3', link: '/软件开发/前端技术/Vue3' },
            { text: 'H5/CSS', link: '/软件开发/前端技术/H5' },
            { text: 'ES6', link: '/软件开发/前端技术/ES6' },
          ]
        },
        {
          text: '数据库',
          items: [
            { text: 'MySQL', link: '/软件开发/数据库/DB/MySQL' },
            { text: 'Redis', link: '/软件开发/数据库/DB/Redis' },
            { text: 'NoSQL', link: '/软件开发/数据库/DB/NoSlq' },
            { text: 'Oracle', link: '/软件开发/数据库/DB/Oracle' },
            { text: 'SQL基础', link: '/软件开发/数据库/DB/SQL' },
          ]
        },
        {
          text: '后端技术',
          items: [
            { text: 'APM监控', link: '/软件开发/后端技术/APM' },
            { text: '限流', link: '/软件开发/后端技术/限流' },
          ]
        },
        {
          text: '架构设计',
          items: [
            { text: '架构思想', link: '/软件开发/架构设计/思想' },
            { text: '数据结构', link: '/软件开发/架构设计/数据结构' },
            { text: '架构师心得', link: '/软件开发/架构设计/架构师' },
          ]
        },
        {
          text: '运维技术',
          items: [
            { text: 'Linux', link: '/软件开发/运维技术/Linux' },
            { text: 'ELK', link: '/软件开发/运维技术/ELK' },
            { text: 'Jenkins', link: '/软件开发/运维技术/Jenkins' },
          ]
        },
        {
          text: '开发工具',
          items: [
            { text: 'Git', link: '/软件开发/开发工具/GIT' },
            { text: 'VS Code', link: '/软件开发/开发工具/Visual Studio Code' },
          ]
        },
        {
          text: '其他技术',
          items: [
            { text: '网络通信', link: '/软件开发/网络通信' },
            { text: '云服务网络', link: '/软件开发/云服务网络' },
            { text: 'Redis缓存', link: '/软件开发/缓存/Redis缓存' },
            { text: 'RabbitMQ消息队列', link: '/软件开发/消息队列/RabbitMQ消息队列' },
          ]
        }
      ],
      '/产品经理/': [
        {
          text: '入门学习',
          items: [
            { text: '入门基础', link: '/产品经理/入门/入门基础' },
            { text: '角色与职责', link: '/产品经理/入门/角色与职责' },
            { text: '用户分析', link: '/产品经理/入门/用户分析' },
            { text: '学习路径', link: '/产品经理/入门/学习路径-转型指南' },
          ]
        },
        {
          text: '学习资源',
          items: [
            { text: 'B站课程汇总', link: '/产品经理/学习资源/B站课程汇总' },
            { text: '推荐书籍', link: '/产品经理/学习资源/推荐书籍' },
          ]
        }
      ],
      '/项目管理/': [
        {
          text: 'PMP认证',
          items: [
            { text: 'PMP知识库', link: '/项目管理/PMP认证/PMP' },
          ]
        },
        {
          text: '敏捷管理',
          items: [
            { text: 'ACP敏捷管理', link: '/项目管理/敏捷管理/ACP敏捷管理' },
          ]
        }
      ],
      '/书籍/': [
        {
          text: '技术类',
          items: [
            { text: '分布式系统', link: '/书籍/技术类/分布式系统/分布式系统' },
            { text: '架构简洁之道', link: '/书籍/技术类/架构设计/架构的简洁之道' },
            { text: '设计模式', link: '/书籍/技术类/编程实践/设计模式' },
            { text: '重构', link: '/书籍/技术类/编程实践/重构' },
          ]
        },
        {
          text: '哲学类',
          items: [
            { text: '道德经', link: '/书籍/哲学类/道德经/道德经' },
          ]
        },
        {
          text: '管理类',
          items: [
            { text: '项目管理', link: '/书籍/管理类/项目管理/项目管理' },
          ]
        },
        {
          text: '语言类',
          items: [
            { text: '英语', link: '/书籍/语言类/英语/英语' },
          ]
        },
        {
          text: '其他',
          items: [
            { text: '杂记', link: '/书籍/其他/杂记' },
          ]
        }
      ],
      '/字典/': [
        {
          text: '技术名词',
          items: [
            { text: 'Appium', link: '/字典/Appium' },
            { text: 'TestNG', link: '/字典/TestNG' },
            { text: 'Xunit', link: '/字典/Xunit' },
            { text: '冒烟测试', link: '/字典/冒烟测试' },
            { text: 'DRM', link: '/字典/DRM' },
            { text: 'KMS', link: '/字典/KMS' },
            { text: '待学习名词', link: '/字典/待学习名词' },
          ]
        }
      ],
      '/我的/': [
        {
          text: '个人档案',
          items: [
            { text: '我的记忆', link: '/我的/个人档案/自传/我的记忆' },
            { text: '简历', link: '/我的/个人档案/2026 - 简历' },
          ]
        },
        {
          text: '职业发展',
          items: [
            { text: '职业规划', link: '/我的/职业发展/职业规划' },
          ]
        }
      ],
      '/3D建模/': [
        {
          text: '3D建模',
          items: [
            { text: 'Blender与Ae基础', link: '/3D建模/Blender与Ae基础' },
            { text: '万圣节设计方案', link: '/3D建模/2025-万圣节/提示词' },
          ]
        }
      ]
    },
    search: {
      provider: 'local',
      options: { detailedView: true }
    },
    ignoreDeadLinks: true,
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