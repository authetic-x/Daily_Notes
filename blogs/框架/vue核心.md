## 生命周期

1. beforeCreated

   实例初始化之后，`this` 指向 vue 的实例，但是还不能访问 `data, methods, computed` 里的数据，可以进行一些非响应式数据的初始化

2. created

   实例创建完成，可以访问 `data, methods, computed` 里的数据，但是组件模板还没有挂载到 DOM 上，所以无法访问 `vm.$el`，`vm.$refs` 里面也是空的。这里进行一些 ajax 请求

3. beforeMounted

   组件模板被挂载之前

4. mounted

   组件被挂载之后，可以访问 `vm.$el和vm.$refs` 里的数据，这里也可以进行一些 ajax 请求

5. beforeUpdated

   数据发生更新，生成虚拟 DOM 之前

6. updated

   数据更新完成后，这里应该防止修改数据，避免死循环

7. beforeDestroyed

   实例被销毁之前

8. destroyed

   实例被销毁之后

### 注意事项

1. Vue 里面数据改变重新发起 ajax 请求的方式和 React 有些不一样，Vue 更多的是用 `watch` 监听属性
2. 路由发生变化 Vue 组件可能不会重新加载，比如 `/page/1 -> /page/2`，这时候可以通过监听 `this.$route` 去进行一些更新操作



## 组件通信方式

### 1. props/$emit

父组件可通过props给子组件传值，子组件也可以通过 `$emit` 触发自定义事件与父组件通信

若要实现 `props` 的双向绑定，即子组件修改 `props` 的值，可以使用 `sync` 修饰符

### 2. $emit/on

可以通过设置一个空的 Vue 实例，利用它的发布订阅特性来实现兄弟组件间的通信

```js
// 组件a
this.bus.$emit('msg', 'dance to this')

// 兄弟组件b
this.bus.$on('msg', msg => {
    console.log(msg)
})
// bus通过父组件props传递过来
```

### 3. provide/inject

类似于 React 的 Context，父组件提供的数据深层子组件也可以直接获取到，不用层层传递

```js
// 父组件
provide() {
    return {
        music: 'Let me'
    }
}

// 子组件
inject: [music] // 模板中可以直接this.music使用
```

### 4. $parent/$children

子实例可通过 `this.$parent` 访问父实例，子实例被推入父实例的 `this.$children` 数组中

### 5. $root/$refs

任何组件都可通过 `this.$root` 访问根实例，设置了 `ref` 属性的组件也可通过 `this.$refs.[ref_name]` 来访问

### 6. Vuex

### 7. Vue.observable