**PS: 这两章的内容没有认真看，这里只做一个简短，基本的总结**



## Date

创建一个日期对象可以使用构造方法，该方法会自动获得当前日期和时间

```js
var now = new Date();
```

该方法返回自 `1970年1月1日午夜` 起至该日期的毫秒数。同样也可以使用一些内置函数来创建特定的日期

```js
var date1 = new Date(Date.parse("May 25, 2004"));
var date2 = new Date(Date.UTC(2005, 0));
```

可以直接将参数传到构造函数中，构造函数会根据传入的形式自动调用相应的函数

如等价的：

```js
var date = new Date("May 25, 2004");
```

还有一些常用形式：

```js
var start = Date.now();
// do something;
var end = Date.now();
alert(end - start);

// 格式化输入日期
// 有很多的函数，如典型的继承方法
Date.toString();
Date.toLocaleString();
```



## RegExp

js 中的正则表达式由两部分组成：`pattern 和 flags`

先说 flags:

* **g:** 表示全局模式，该模式应用于所有字符串，而非匹配第一个时停止
* **i:** 不区分大小写
* **m:** 多行模式

创建有两种方式：

1. 字面量创建

   ```js
   var expression = / pattern / flags;
   
   var pattern = /[bc]at/g;
   ```

2. 构造函数创建

   ```js
   var pattern = new RegExp("[bc]cat", "i");
   ```

   传入字符串的形式相比字面量方式而言，需要进行双重转义，如：

   `/\[bc\]at/` 对应的字符串是 `"\\[bc\\]at"`

   **PS: 这里很容易搞混，记住”双重转义，多加一个\“即可**

   

RegExp 还有一些实例属性如：global, lastIndex 等，用时再查阅。



### 实例方法

`exec()` 和 `test()`

偷懒不写了，一个是专门为捕获组而设计，一个是判断相应字符串是否满足模式匹配，返回布尔值