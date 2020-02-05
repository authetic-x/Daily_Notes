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