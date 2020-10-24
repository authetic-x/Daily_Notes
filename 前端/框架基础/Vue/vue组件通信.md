## props/$emit

父组件可通过props给子组件传值，子组件也可以通过 `$emit` 触发自定义事件与父组件通信

若要实现 `props` 的双向绑定，即子组件修改 `props` 的值，可以使用 `sync` 修饰符



## $emit/on

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



## provide/inject

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



## $parent/$children

子实例可通过 `this.$parent` 访问父实例，子实例被推入父实例的 `this.$children` 数组中



## $root/$refs

任何组件都可通过 `this.$root` 访问根实例，设置了 `ref` 属性的组件也可通过 `this.$refs.[ref_name]` 来访问



## Vuex