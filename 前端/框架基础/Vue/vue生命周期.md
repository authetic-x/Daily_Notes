## beforeCreated

实例初始化之后，`this` 指向 vue 的实例，但是还不能访问 `data, methods, computed` 里的数据，可以进行一些非响应式数据的初始化



## created

实例创建完成，可以访问 `data, methods, computed` 里的数据，但是组件模板还没有挂载到 DOM 上，所以无法访问 `vm.$el`，`vm.$refs` 里面也是空的。这里进行一些 ajax 请求



## beforeMounted

组件模板被挂载之前



## mounted

组件被挂载之后，可以访问 `vm.$el和vm.$refs` 里的数据，这里也可以进行一些 ajax 请求



## beforeUpdated

数据发生更新，生成虚拟 DOM 之前



## updated

数据更新完成后，这里应该防止修改数据，避免死循环



## beforeDestroyed

实例被销毁之前



## destroyed

实例被销毁之后



## 注意事项

1. Vue 里面数据改变重新发起 ajax 请求的方式和 React 有些不一样，Vue 更多的是用 `watch` 监听属性

2. 路由发生变化 Vue 组件可能不会重新加载，比如 `/page/1 -> /page/2`，这时候可以通过监听 `this.$route` 去进行一些更新操作