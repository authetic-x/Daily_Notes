Js 最大的特点之一就是函数也是对象，每个函数都是 Function 类型的实例，并且与其它引用类型一样都具有属性和方法。函数名实际上指向函数对象的一个指针，所以可能会有多个函数名同时指向一个函数实例。

### 创建函数的三种方法

```js
// 函数声明
fucntion sum(num1, num2) {
    return num1 + num2;
}

// 函数表达式定义
var sum = function(num1, num2) {
    return num1 + num2;
};
// 注意要加分号

// Function构造函数，并不推荐
var sum = new Function("num1", "num2", "return num1 + num2");
```

#### 为什么没有重载？

```js
function addNumber(num) {
    return num + 100;
}
function addNumber(num) {
    return num + 200;
}

var res = addNumber(100); // 300
```

这相当于对函数名 `addNumber` 进行了两次赋值，所以调用的自然是后面的函数



#### 函数声明与函数表达式的区别

解析器会率先读取函数声明，将它们放到源代码树的顶部；而函数表达式只有等到解析器执行到它所在代码时，才会真正被执行

```js
alert(sum(10, 10));
function sum(num1, num2) {
    return num1 + num2;
}
// 不会报错
// 如果将sum改为如下定义，则会抛出一个"unexpected identifier"
var sum = function(num1, num2) {
    return num1 + num2;
};
```



### 函数内部属性

#### arguments

一个类数组对象，包含着传入函数中的所有参数。它还有一个名为 `callee` 的属性，该属性是指向拥有这个 arguments 对象的函数指针

```js
function factorial(num) {
    if (num <= 1) {
        return 1;
    } else {
        return num * arguemnts.callee(num-1);
    }
}
```

这样，将函数名变量 `factorial` 指向其它的函数时，原函数的功能也不会遭到破坏



#### this

this 引用的是函数据以执行的环境对象

```js
window.color = "red";
var o = {color = "blue"};

function sayColor() {
    alert(this.color);
}

sayColor(); // red

o.sayColor = sayColor;
o.sayColor(); // blue
```

#### caller

这个属性保存着当前函数的函数的引用

```js
function outer() {
    inner();
}

function inner() {
    alert(inner.caller);
}

outer(); // inner.caller 指向outer()

// 松耦合
function inner() {
    alert(arguments.callee.caller);
}
```

#### length

length 属性表示函数希望接受命名参数的个数



#### prototype

prototype 是保存函数所有实例方法的真正所在。`toString() 和 valueOf()` 等方法都是保存在 prototype 名下



#### apply 与 call

这两个方法不是函数继承而来的。用途是在特定的作用域中调用函数，实际上等于设置函数体内 this 对象的值。

```js
function sum(sum1, sum2) {
    return sum1 + sum2;
}

function callSum(num1, num2) {
    // sum.apply(this, [sum1, sum2]);
    return sum.apply(this, arguments);
}

alert(callSum(10, 10)); // 全局执行，this传入的是window对象

// call与apply的唯一不同是第二个参数传入的不是参数数组，而是一个个的参数
sum.call(this, num1, num2);

// 扩充函数作用域
window.color = "red";
var o = {color = "blue"};

function sayColor() {
    alert(this.color);
}

sayColor(); // red

sayColor.call(this); // red
sayColor.call(window); // red
sayColor.call(o); // blue
```

#### bind

this 的值会被绑定到传给 bind() 函数的值

```js
var objectSayColor = sayColor.bind(o);
objectSayColor(); // blue
```

