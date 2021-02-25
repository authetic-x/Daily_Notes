## 前言

来一篇长的~



## async/await 执行顺序的思考

头条有一道经典的异步逻辑面试题：

```js
async function async1(){
  console.log('async1 start')
  await async2()
  console.log('async1 end')
} 
async function async2(){
  console.log('async2')
}

console.log('script start')

setTimeout(function(){
  console.log('setTimeOut')
}, 0)

async1()

new Promise(function(resolve){
  console.log('promise1')
  resolve()
}).then(function(){
  console.log('promise2')
})

console.log('script end')
```

代码执行顺序为：script start、async1 start、async2、promise1、script end、promise2、async1 end

setTimeOut。

我第一次做的时候，我把 async1 end 放在了 promise2 的前面。原因是我当时觉得 await 后面的逻辑相当于是绑定在 await 后面的 Promise 的 then 函数里，但实际不是这样的。

### await 后面的是同步逻辑时

await 仍旧会中断 async 函数的执行，但是 await 后面的代码会先于微任务队列里的回调函数执行。

### await 后面的是异步逻辑时

await 后面的代码会在 Promise resolve 后执行，而且执行时机在微任务队列的末尾！



## Promise、async/await 中如何进行错误处理？

### 1. Promise 中的错误捕获

Promise 内部抛出的错误可以被 `catch` 语句捕获，catch 也可以继续抛出错误

```js
new Promise(() => {
  throw new Error('error test1')
}).catch(e => {
  console.log(e)
  throw new Error('error test2')
}).catch(e => {
  console.log(e)
})

// Error: error test1
// Error: error test2
```

但如果错误抛出在 `resolve/reject` 语句后面，那么错误就无法被捕获

```js
new Promise((resolve) => {
  resolve('hello')
  throw new Error('error')
}).then(v => console.log(v))
	.catch(e => console.log(e))

// hello
```



### 2. async 函数中如何捕获错误？

在 async 函数里抛出的错误相当于返回了一个 `Promise.reject(e)`，可以在外部用 catch 语句进行捕获

```js
async function fn() {
  throw new Error('error')
  console.log('hello')
}

fn().catch(e => console.log(e))

// Error: error
```

对于 await 后面的异步逻辑抛出的错误可以自行 catch，如果不进行处理，就会中断 async 函数的执行

```js
async function fn() {
  await Promise.reject('error1').catch(e => console.log(e))
  console.log('123')
  await Promise.reject('error2')
  console.log('456')
}

fn().catch(e => console.log(e))

// error1
// 123
// error2
```

由于 await 语句直接返回异步的结果，那么如果每次都要写个 if 语句判断数据是否发生错误就会显得代码很乱，有没有优雅一点的处理方式呢？

```js
(async () => {
  function fetchData() {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve('data')
      }, 3000)
    })
  }

  const [err, data] = await fetchData()
  	.then(v => [null, v]).catch(e => [e, null])
  console.log('err', err)
  console.log('data', data)
})()
```

是不是显得代码更高级一点了呢？



## 参考

* [9k字 | Promise/async/Generator实现原理解析](https://juejin.cn/post/6844904096525189128)

* [async/await 优雅的错误处理方法](https://juejin.cn/post/6844903767129718791)
* [总结一下ES6中promise、generator和async/await中的错误处理](https://blog.csdn.net/liwusen/article/details/79617903?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control)