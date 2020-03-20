关于 this 的值我记得书上说的是指**执行环境**。我一直所困惑的是为什么函数不是执行环境。其实可以将执行环境理解为谁调用了你。函数作为 `Function` 类型的实例当然可以作为执行环境，之所以在函数内部使用 this 指向的不是函数，是因为并不是函数本身调用了你，而是某个对象调用了函数。

我们要明确的是 this 指向的肯定是对象，一条语句只能在全局或者某个函数的内部执行，比如你这样写：

```js
let hello = 'Hello!';
function sayHello() {
    alert(this.hello);
}
sayHello(); // Hello!
```

alert 语句在函数内部执行，而正是因为 `global` 对象调用了函数它才得以执行，所以执行环境也就是 this 指向的是 `global`。这么说可能更绕了，**其实就是外层第一个使用点语法调用函数的对象**。



## 实现 call

```js
Function.prototype.myCall = function(context, ...args) {
    context = (context ?? window) || new Object(context);
    const key = Symbol();
    // this指向调用myCall的那个对象
    context[key] = this;
    const result = context[key](...args);
    return result;
}
```



## 面试问题

```js
const arrayLike = {
    length: 0; // 所谓的类数组就是拥有length属性的对象
}
const call = [].push.call;
call(arrayLike, 1);
console.log(arrayLike[0]);
```

为什么报错？

其实只要动手写过 `call` 的实现，就可以轻松理解。因为 call 是在全局作用域中调用的，所以 `this` 是 global，也就是所它无法获取到 push 函数并将其作为 arrayLike 的成员对象了。这里我们也可以了解到，要将一个函数的内部 this 指定给某个对象，简单的做法就是将那个函数变为指定对象的成员函数。