## dev web 上的70道js面试题难点汇总

1. `&&` 和 `||` 运算符都是短路操作，一个碰到假就返回，一个碰到真就返回。但比较特别的是，这两个运算符返回的不是 `boolean`，而是对象本身。前者全为真时，返回最后一个对象，后者亦同。

   ```js
   const event = window.event || event;
   ```

2. `+` 单元运算符是将 `string` 类型转换为 `number` 类型的最快方法，也可以对布尔值，`null` 对象使用 `+` 运算符。注意：当字符串和数字类型相加时，会将数字转换为字符串并返回新的字符串，而对于其它非 `+` 运算符则会将字符串转为数字进行算术运算

   ```js
   let str = '123';
   let num = +str;
   ```

3. 在 js 中，`document` 对象就代表 DOM，注意：这不是 html 元素上一层的 `document` 元素，它们的关系是 `document.documentElement`

4. 事件传播有三个阶段：

   * 捕获阶段 (从 window 一直到 触发事件的元素本身)
   * 目标阶段
   * 冒泡阶段 (从触发事件的元素冒泡到 window 对象)

   事件默认是在冒泡阶段阶段触发，若如果设置 `addEventListener` 第三个参数为 `true`，则事件会在捕获阶段触发

5. `event.target` 是触发事件的元素本身，而 `event.currentTarget` 是我们添加了事件处理函数的元素本身

6. > `toPrimitive` uses first the `valueOf` method then the `toString` method in objects to get the primitive value of that object.

7. !! 强制转换布尔类型

8. `execution context` 有两个阶段：`compilation` 和 `execution`。前一个阶段是变量提升的过程，js 将 var 声明的变量以及函数提升到执行上下文的顶部，后一个阶段就是执行阶段。

9. 执行上下文和作用域的区别：`The Execution Context is the "environment of code" that is currently executing`，`Scope in JavaScript is the area where we have valid access to variables or functions`。ES6 新增了块级作用域，在里面声明的 `let, const` 变量在外部不可访问

10.  再次强调 `this` 的取值，函数内部 `this` 值指向谁调用了这个函数，或者说这个函数的拥有者是谁。需要特别注意的是函数内部定义的函数的 `this` 值

    ```js
    const myObject = {
        name: 'Miles',
        outer() {
            console.log(this);
            function inner() {
                console.log(this);
            }
            inner();
        }
    }
    
    myObject.outer(); // myObject, window
    // 这里inner的this指向的是window，因为并没有对象显式调用inner
    // 解决方案：
    // 1. 在outer函数里使用变量保存this值
    // 2. 箭头函数
    ```

11. 