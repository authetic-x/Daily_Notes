## dev web 上的70道js面试题难点汇总

1. `&&` 和 `||` 运算符都是短路操作，一个碰到假就返回，一个碰到真就返回。但比较特别的是，这两个运算符返回的不是 `boolean`，而是对象或数值本身。前者全为真时，返回最后一个对象，后者亦同。

   ```js
   const event = window.event || event;
   ```

2. `+` 单元运算符是将 `string` 类型转换为 `number` 类型的最快方法，也可以对布尔值，`null` 对象使用 `+` 运算符。注意：当字符串和数字类型相加时，会将数字转换为字符串并返回新的字符串，而对于其它非 `+` 运算符则会将字符串转为数字进行算术运算

   ```js
   let str = '123';
   let num = +str;
   ```

3. 在 js 中，`document` 对象就代表 DOM，注意：`document.documentElement 在浏览器中指 html元素`

4. 事件传播有三个阶段：

   * 捕获阶段 (从 window 一直到 触发事件的元素本身)
   * 目标阶段
   * 冒泡阶段 (从触发事件的元素冒泡到 window 对象)

   事件默认是在冒泡阶段阶段触发，若如果设置 `addEventListener` 第三个参数为 `true`，则事件会在捕获阶段触发

5. `event.target` 是触发事件的元素本身，而 `event.currentTarget` 是我们添加了事件处理函数的元素本身

6. > `toPrimitive` uses first the `valueOf` method then the `toString` method in objects to get the primitive value of that object.

7. !! 强制转换布尔类型

8. `execution context` 有两个阶段：`compilation` 和 `execution`。前一个阶段是变量提升的过程，js 将 var 声明的变量以及函数提升到执行上下文的顶部，后一个阶段就是执行阶段。注意：以表达式形式声明的函数不会被提升

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

11. 手写数组的 `map, filter, reduce` 方法

    ```js
    Array.prototype.myMap = (callBack) => {
    	const arr = this;
    	if (typeof callBack !== 'function') {
    		return [];
    	}
    	const res = [];
    	for (let i = 0; i < arr.length; i ++ ) {
    		res.push(callBack(arr[i], i, arr));
    	}
    	return res;
    }
    
    Array.prototype.myFilter = (callBack) => {
    	if (typeof callBack !== 'function') return [];
    	const arr = this;
    	const res = [];
    	for (let i = 0; i < arr.length; i ++ ) {
    		if (callBack(arr[i], i, arr)) {
    			res.push(arr[i]);
    		}
    	}
    	return res;
    }
    
    Array.prototype.myReduce(callBack, initial) => {
    	if (typeof callBack !== 'function') return null;
    	const arr = this;
    	const hasInitialValue = initial !== undefined;
    	let value = hasInitialValue ? initial : arr[0];
    	for (let i = hasInitialValue ? 0 : 1; i < arr.length; i ++ ) {
    		value = callBack(value, arr[i], i, arr);
    	}
    	return value;
    }
    ```

12. 创建没有原型的对象：

    ```js
    const obj = Object.create(null);
    ```

13. 利用 Set 删除数组中的重复元素：

    ```js
    const newArr = [...new Set(arr)];
    ```

14. 将回调形式的异步函数转化为 Promise 形式的异步函数

    ```js
    const toPromise (asyncFunc) => {
    	return (...args) => {
    		return new Promise((resolve, reject) => {
    			asyncFunc(...args, (err, res) => {
    				return err ? reject(err) : resolve(res);
    			});
    		});
    	}
    }
    
    const promReadFile = toPromise(fs.readFile);
    promReadFile('./index.js')
    	.then((data) => {
    		console.log(data);
    	})
    	.catch((err) => {
    		console.log(err);
    	});
    ```

15. `async/await` 建立在 Promise 之上，是我们的异步逻辑变得更加清晰。async 函数会默认返回一个 Promise，await 是一个阻塞操作。

16. 判断一个对象是否有某个属性的三种办法：

    1. `console.log('prop' in obj);`
    2. `console.log(obj.hasOwnProperty('prop'));`
    3. `console.log(obj['prop'])`

17. 创建对象的三种方法：

    1. 对象字面量（花括号）
    2. 构造函数或类 (本质也是构造函数，基于原型继承，一种语法糖)
    3. `Object.create()`

18. `Object.freeze()` 函数让对象变为 `immutable`，无法增删改，就连原型也不可改变；`Object.seal()` 函数让对象变得密封起来，无法增加新的属性，而且变为 `non-configurable`

19. `in` 操作符和 `Object.hasOwnProperty()` 的区别是前者会搜索原型，后者不会



## 掘金上的高频面试题总结

1. 手写类继承

2. 实现类似map的功能

   ```js
   const newArr = Array.from(arr, item => item*2)
   ```

3. 手写数组去重

   ```js
   const newArr = [...new Set(arr)];
   ```

4. 求两个数组的交集

   ```js
   const arr1 = [1, 4, 4, 5, 6, 9]
   const arr2 = [1, 4, 7, 8]
   
   const dupArr = [...new Set(arr1)].filter(item => {
       return arr2.includes(item)
   })
   ```

5. 删除数组的假值

   ```js
   const newArr = arr.filter(Boolean)
   ```

6. 如何遍历对象属性

   ```js
   // 目前为止发现四个方法，暂不知区别
   Object.keys(target);
   for ... in 语法
   Obejct.getOwnPropertyNames(target);
   Obejct.getOwnPropertySymbols(target);
   Reflect.ownKeys(target)
   ```

7. 同源策略

   如果两个页面拥有相同的协议、域名、端口，那么这两个页面就是同源的

8. 手写 jsonp 实现

   同源策略限制了跨域的读请求，并没有限制对跨域嵌入请求，比如 `<img>` 标签里记载图片。因此，我们可以手动插入 `<script>` 元素来实现跨域请求。当然，只支持 `GET`

   ```js
   const jsonp = (url, data={}, callback) => {
   	if (typeof callback !== 'function') return
   	let dataStr = url.indexOf('?') === -1 ? '?' : '&'
   	for (let key in data) {
   		dataStr += `${key}=${data[key]}&`
   	}
   
   	const callback_name = 'jsonpCallback'
   	dataStr += `callback=${callback_name}`
   	const scriptEle = document.createElement('script')
   	scriptEle.src = url + dataStr
   
   	// 注册window回调
   	window[callback_name] = (data) => {
   		callback(data)
   		document.body.removeChild(scriptEle)
   	}
   	document.body.appendChild(scriptEle)
   }
   ```

9. 跨域是什么，跨域的几种实现方案

   > #### CORS
   >
   > 简单请求：`GET, POST, HEAD`，请求会带一个 `origin` 字段，响应头会有一个 `Access-Allow-Origin` 字段。非简单请求就是其他的请求方法，一般会先发送一个预检请求
   >
   > #### JSONP
   >
   > #### nginx 代理
   >
   > #### Websocket

10. 手写 once, debounce 函数

11. **实现拖拽**

12. 手写原生 ajax, 封装成类 promise

    ```js
    
    ```

13. let, const 区别

14. **setTimeout, setInterval, requestAnimation 区别， 倒计时使用哪一个**

15. **js 简单合并是按需加载还是按模块加载，延时加载和异步加载**

16. js 实现继承的多种方案

17. **监控 js 对象属性变更**

18. **如何实现一个私有变量，只能用成员函数访问**

19. js 垃圾回收机制

20. **localStorage 和 Cookie/sessionStorage**

21. websocket 和 ajax 轮询

22. 原型链和伪数组

23. **document.ready 和 window.onload 方法**

24. 字符串去重

    ```js
    const newStr = [...new Set(Array.from(str))].join('')
    ```

25. **自己实现一个事件委托**

26. 性能优化

27. **写一个倒计时页面**

28. Promise 是如何实现的，自己实现一个 Promise

29. Promise接收的函数中resolve()后的代码是否会执行？

30. **图片懒加载，预加载**

31. 监听一段时间内用户对我方网页的操作

32. for in 和 for of 区别

33. **react 中的 setState为什么异步**

34. **数组扁平化**

35. 闭包的使用场景

36. **为什么reducer是纯函数**

37. react 中的 叶子节点之间如何通信，组件间通信

38. 节流，防抖

39. MVC vs MVVM

40. **观察者模式**

41. **继承和闭包必考**

42. async/await

43. **实现一个 sleep 函数**

44. Promise.all

45. Symbol

46. 

