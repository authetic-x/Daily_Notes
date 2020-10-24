### apply, call, bind



### Promise 封装 ajax，或将异步函数转化为Promise形式

```js
const toPromise = (asyncFunc) => {
    return (...args) => {
        return new Promise((resolve, reject) => {
            asyncFunc(...args, (err, data) => {
                if (err) {
                    reject(err)
                } else {
                    resolve(data)
                }
            })
        })
    }
}
```



### 手写 Jsonp 实现

