## Promise.all

> Promise.all: (iterable: PromiseLike[]) => Promise

`Promise.all` 方法接受一个可迭代对象，返回一个 `Promise` 实例。如果参数中存在的 `Promise` 都 resolved，返回的实例才会 resolved；如果有一个 `Promise` 失败，则返回的实例会 rejectd，err 是第一个失败 `Promise` 的结果。

### 同步还是异步？

传入的参数不一定是由 `PromiseLike` 类型组成的可迭代对象，也可以是一个数字或者字符串，传入一个空迭代对象也可以。我们需要在这些情况下 `Promise.all` 所展现出来的行为。

```js
const p1 = Promise.all([123, '123', true]);

const resolvedPromise = Promise.resolve(123);

const p2 = Promise.all([resolvedPromise, 123, '123']);

const arr = [1, 2, 3];

const p3 = Promise.all(arr.map(i => new Promise(
	(resolve, reject) => setTimeout(() => resolve(i), 100 * i)
)));

const p4 = Promise.all([]);

console.log(p1);
console.log(p2);
console.log(p3);
console.log(p4);

setTimeout(() => console.log(p1, p2, p3, p4), 3000);
```

打印结果是：

```js
Promise { <pending> }
Promise { <pending> }
Promise { <pending> }
Promise { [] }
Promise { [ 123, '123', true ] } Promise { [ 123, 123, '123' ] } Promise { [ 1, 2, 3 ] } Promise { [] }
```

可见，如果传入的参数是一个空的可迭代对象，`Promise.all` 会同步返回一个 `resolved` 的 `Promise`；其它情况都是异步返回，尽管传入的可迭代对象里没有 `Promise` 或者是已经 `resolved` 的 `Promise`。 