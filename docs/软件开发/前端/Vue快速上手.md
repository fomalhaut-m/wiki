# Vue.js 快速上手

> 来源：个人Vue笔记 | 标签：前端 / Vue

---

## 什么是 Vue

Vue 是一个**渐进式**JavaScript框架，可以逐步嵌入应用。

**核心特点：**
- 解耦视图和数据
- 可复用组件
- 前端路由（Vue Router）
- 状态管理（Vuex）
- 虚拟DOM

---

## 生命周期

| 钩子 | 说明 |
|------|------|
| `beforeCreate` | 实例初始化前 |
| `created` | 实例创建完成 |
| `beforeMount` | 挂载前 |
| `mounted` | 挂载完成 |
| `beforeUpdate` | 数据更新前 |
| `updated` | 数据更新后 |
| `beforeDestroy` | 销毁前 |
| `destroyed` | 销毁后 |

---

## 常用指令

| 指令 | 说明 |
|------|------|
| `v-bind` | 动态绑定属性（缩写 `:`） |
| `v-on` | 绑定事件（缩写 `@`） |
| `v-if` | 条件渲染 |
| `v-for` | 循环渲染 |
| `v-model` | 双向绑定 |

### v-bind
```html
<img v-bind:src="imageUrl">
<img :src="imageUrl"> <!-- 缩写 -->
```

### v-on
```html
<button v-on:click="handleClick">点击</button>
<button @click="handleClick">点击</button>
```

### v-if / v-else
```html
<div v-if="isShow">显示</div>
<div v-else>隐藏</div>
```

### v-for
```html
<li v-for="item in items" :key="item.id">
  {{ item.name }}
</li>
```

### v-model
```html
<input v-model="message" placeholder="输入内容">
<p>{{ message }}</p>
```

---

## 组件化

### 注册组件步骤

1. 创建组件构造器 `Vue.extend()`
2. 注册组件 `Vue.component()`
3. 使用组件

### 示例
```javascript
// 创建全局组件
const cpn = Vue.extend({
  template: `<div><h2>标题</h2></div>`
})
Vue.component('my-cpn', cpn)

// 局部组件
new Vue({
  el: '#app',
  components: {
    'my-cpn': cpn
  }
})
```

### 父子组件
子组件注册到父组件的 `components` 中。

---

## 计算属性

```javascript
computed: {
  fullName: {
    get() { return this.firstName + ' ' + this.lastName },
    set(value) { /* ... */ }
  }
}
```

---

## Vue Router

```javascript
const router = new VueRouter({
  routes: [
    { path: '/home', component: Home }
  ]
})
```

---

## Vuex 状态管理

```javascript
const store = new Vuex.Store({
  state: { count: 0 },
  mutations: {
    increment(state) { state.count++ }
  }
})
```
