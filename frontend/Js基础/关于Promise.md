## 2020-02-06

第一次碰到 Promise 的巨坑。再做 node.js 的路由测试，用 promise 去接收 post 的数据，出现了很奇怪，很奇怪的行为。调式到心态接近崩溃。原因是完全忽略了 Promise 的异步特性，一直在以同步的思维去寻找问题。我将一些逻辑写在了 then 函数的外面，然而这些逻辑需要使用 then 里赋值的数据，所以一直出现 undefined 的状态，然后调试 then 以及之上的逻辑又是正确的，所以令人十分困惑和焦灼。



Promise 是一种异步编程的解决方案。有两个特点：

> 1. 对象状态不受外界影响，有异步函数逻辑决定。有三个状态：`pending`,  `fulfilled`, `rejected`
> 2. 一旦状态发生改变，就不会再变



### Promise 封装 ajax

```js
// 封装ajax
const getJson = (url) => {
    const promise = new Promise((resolve, reject) => {
        const handler = function() {
            if (this.readyState !== 4) {
                return;
            }
            if (this.status === 200) {
                resolve(this.response);
            } else {
                reject(new Error(this.statusText));
            }
        };
        const client = new XMLHttpRequest();
        client.open('GET', url);
        client.onreadystatechange = handler;
        client.responseText = "json";
        client.setRequestHeader("Accept", "application/json");
        client.send();
    });
}

getJson.then((data) => {
    console.log('Content: ', data);
}, (err) => {
    console.error(err);
});
```

来看一个比较奇怪的行为，给 resolve 传入一个 promise

```js
const p1 = new Promise(function (resolve, reject) {
  setTimeout(() => reject(new Error('fail')), 3000)
})

const p2 = new Promise(function (resolve, reject) {
  setTimeout(() => resolve(p1), 1000)
})

p2
  .then(result => console.log(result))
  .catch(error => console.log(error))
// Error: fail

// resolve(p1) 等价于：
p1.then(resolve).catch(reject); // Promise 标准定义的行为
```

这相当于是将 p1 reject 的结果传给了 p2 的 reject，注意这里比较绕。记住 then 和 catch 里的都是回调函数，满足某种情况就会被调用，而且都会返回一个新的 Promise。通俗的说，这种情况下 p1 的状态决定 p2 的状态，p2 后面的 then, catch 语句都是针对 p1 的。



## Promise 的若干方法

### Promise.prototype.then()

then() 方法会返回一个新的 Promise，链式调用可指定一组按照链式调用的回调函数。参数接收两个回调函数，分别对应 `fulfilled` 和 `rejected` 状态



### Promise.prototype.catch()

`Promise.prototype.catch ` 方法是 `.then(null, rejection)` 或 `.then(undefined, rejection)`的别名，用于指定发生错误时的回调函数。then 方法运行时发生错误，也会被 catch 捕获，因此最佳实践是不写 then 的第二个参数，始终用 catch。如果 Promise 在 resolve 的后面再抛出错误，就不会被捕获，因为 Promise 一旦状态改变就不会再变了。

Promise 对象的错误具有“冒泡”性质，会一直向后传递，直到被捕获为止。“Promise 会吃掉错误”，Promise 内部的错误不会影响到 Promise 外部的代码

catch 也会返回一个 Promise，可在后面接着调用 then



### Promise.prototype.finally

`finally` 方法用于指定不管 Promise 对象最后状态如何，都会执行的操作



### Promise.all()

`const p = Promise.all([p1, p2, p3]);`

包装若干个 Promise 实例，如果参数不是 Promise 实例，则会先调用 `Promise.resolve()` 方法将其转化一下。

p 的状态由 `p1, p2, p3` 决定。当所有都变为 `fulfilled` 时，p 才会变成 `fulfilled`，每个 Promise 的返回值会组成一个数组传给 p 的回调函数。只要有一个变为 `rejected`，p 也会变成 `rejected`，其返回值也会传给 p 的回调函数。

```js
const databasePromise = connectDatabase();

const booksPromise = databasePromise
  .then(findAllBooks);

const userPromise = databasePromise
  .then(getCurrentUser);

Promise.all([
  booksPromise,
  userPromise
])
.then(([books, user]) => pickTopRecommendations(books, user));
```

注意：如果作为参数的 Promise 实例，自己定义了`catch`方法，那么它一旦被`rejected`，并不会触发`Promise.all()`的`catch`方法。要看它的 catch 方法里是返回什么状态的 Promise, 或者说有没有继续抛出错误



### Promise.race()

只要`p1`、`p2`、`p3`之中有一个实例率先改变状态，`p`的状态就跟着改变。那个率先改变的 Promise 实例的返回值，就传递给`p`的回调函数。

```js
const p = Promise.race([
  fetch('/resource-that-may-take-a-while'),
  new Promise(function (resolve, reject) {
    setTimeout(() => reject(new Error('request timeout')), 5000)
  })
]);

p
.then(console.log)
.catch(console.error);
```



### Promise.allSettled

只有等到所有这些参数实例都返回结果，不管是`fulfilled`还是`rejected`，包装实例才会结束。该方法返回的新的 Promise 实例，一旦结束，状态总是`fulfilled`，不会变成`rejected`

```js
const promises = [ fetch('index.html'), fetch('https://does-not-exist/') ];
const results = await Promise.allSettled(promises);

// 过滤出成功的请求
const successfulPromises = results.filter(p => p.status === 'fulfilled');

// 过滤出失败的请求，并输出原因
const errors = results
  .filter(p => p.status === 'rejected')
  .map(p => p.reason);
```

注意： Promise 的监听函数接收到的参数是一个数组，每个成员对应一个传入`Promise.allSettled()`的 Promise 实例。**这一点与前面两个函数不同**



### Promise.any()

只要参数实例有一个变成 `fulfilled` 状态，包装实例就会变成 `fulfilled` 状态；如果所有参数实例都变成 `rejected` 状态，包装实例就会变成 `rejected` 状态。目前这是一个新的提案。



### Promise.resolve()

将现有对象转为 Promise 对象。`Promise.resolve` 方法的参数分成四种情况：

1. 参数是一个 Promise 实例，不做任何修改，直接返回

2. 参数是一个 thenable 对象 (具有 then 方法的对象)。resolve 会先将这个对象转化为 Promise，然后立即执行 then 方法

   ```js
   let thenable = {
     then: function(resolve, reject) {
       resolve(42);
     }
   };
   
   let p1 = Promise.resolve(thenable);
     p1.then(function(value) {
     console.log(value);  // 42
   });
   ```

3. 普通对象，基本数据类型，或什么都不传，就返回一个新的状态为 `resolved` 的 Promise 对象



需要注意的是，立即`resolve()`的 Promise 对象，是在本轮“事件循环”（event loop）的结束时执行，而不是在下一轮“事件循环”的开始时。

```js
setTimeout(function () {
  console.log('three');
}, 0);

Promise.resolve().then(function () {
  console.log('two');
});

console.log('one');

// one
// two
// three
```



### Promise.reject()

返回一个新的 Promise 实例，该实例的状态为`rejected`。

注意，`Promise.reject()`方法的参数，会原封不动地作为`reject`的理由，变成后续方法的参数。这一点与`Promise.resolve`方法不一致。

```js
const thenable = {
  then(resolve, reject) {
    reject('出错了');
  }
};

Promise.reject(thenable)
.catch(e => {
  console.log(e === thenable)
})
// true
```

