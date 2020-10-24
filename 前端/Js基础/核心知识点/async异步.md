`ES6 入门` 说 `async/await` 语法是 `generator` 的语法糖，理解这一点还需打磨



## 基本用法和注意项

`async` 加载函数前面表示函数中有异步操作，而且会始终返回一个 Promise。`await` 只能用在 `async` 函数中，后面跟一个 Promise 或 `thenable` 对象，返回传入 `resolve()` 方法的参数。如果 `await` 后面

的 Promise 对象变为 `rejected` 状态，那么整个 `async` 函数会直接中断执行，reject 的参数会被传到外部的 catch。

```js
async function f() {
    await Promise.reject('出错了');
}

f().catch(v => {console.log(v);}) // 出错了
```

如果不想让 `async` 函数中断，可以将语句放在 `try...catch` 里，或者 `await` 后面的 Promise 跟一个 catch。

如果在处理两个互不依赖的异步操作时，可以让它们同时触发

```js
// 这样getBar必需要等待getFoo的完成
let foo = await getFoo();
let bar = await getBar();

// 方案一
let result = await Promise.all([getFoo(), getBar()]);

// 方案二
let fooPromise = getFoo();
let barpromise = getBar();
let foo = await fooPromise;
let bar = await barPromise;
```



### 异步任务按顺序执行

```js
async function dbFuc(db) {
  let docs = [{}, {}, {}];

  // 同步执行
  for (let doc of docs) {
    await db.post(doc);
  }
  
  // 注意：如果写成这样，任务是异步执行的
  docs.forEach(async function (doc) {
    await db.post(doc);
  });
}
```



### 实例

```js
async function logInOrder(urls) {
    // 异步执行
    const textPromises = urls.map(async url => {
        const response = await fetch(url);
        return response.text();
    });
    
    // 按序输出
    for (const textPromise of textPromises) {
        console.log(await textPromise)
    }
}
```



## 顶层 await (提案)

阻塞异步操作，非常期待这个特性！

在我们异步引入模块时，会出现无法确定有没有加载完成的问题

```js
// awaiting.js
let output;

(async function main() {
    const dynamic = await import("module");
    const data = fetch(url);
    output = someProcess(dynamic, data);
})();

export {output};
```

我们在其它的模块引入 `output` 时无法确定不容易确定异步任务有没有完成，一种解决方案是默认导出一个 Promise，因为任何 `async` 函数都会返回一个 Promise

```js
export default (async function main() {
  const dynamic = await import(someMission);
  const data = await fetch(url);
  output = someProcess(dynamic.default, data);
})();

// other module
import promise, {output} from "./awaiting.js";

promise.then(() => {
    console.log(output);
})
```

顶层 await 可以直接这样写

```js
// awaiting.js
const dynamic = import(someMission);
const data = fetch(url);
export const output = someProcess((await dynamic).default, await data);
```

