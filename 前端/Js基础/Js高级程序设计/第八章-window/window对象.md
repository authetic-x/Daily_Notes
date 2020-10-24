window 对象是 ECMAScript 中的 Global 对象
```js
// 判断是否有弹出窗口屏蔽程序
var blocked = false;

try {
    var wroxwin = window.open("http://www.google.com", "_blank");
    if (wroxwin == null) {
        blocked = true;
    }
} catch(ex) {
    blocked = true;
}

if (blocked) {
    alert("The popup was blocked!");
}
```



### 超时调用和间歇调用

```js
setTimeout(function() {
    alert("Hello, world!");
}, 1000);

setInterval(function(){}, 1000);
```



## location对象

### 查询字符串参数

```js
function getQueryStringArgs() {
    var qs = (location.search.length > 0 ? location.search.substring(1) : 											"");
    var args = {};
    var items = qs.length ? qs.split("&") : [];
    var item = null, name = null, value = null;
    
    for (var i = 0; i < items.length; i ++ ) {
        item = items[i].split("=");
        name = decodeURIComponent(item[0]);
        value = decodeURIComponent(item[1]);
        
        if (name.length) {
            args[name] = value;
        }
    }
    return args;
}
```



### 位置操作

```js
window.location = "http://www.google.com";
location.href = "http://www.google.com";

// 禁用后退
location.replace("http://www.google.com");

// 重新加载页面
location.reload(); // 可能从缓存加载
location.reload(true); // 从服务器重新加载
```



## navigator对象

主要用于识别客户端浏览器类型



### 检测插件

```js
// 对IE无效
function hasPlugin(name) {
    name = name.toLowerCase();
    for (var i = 0; i < navigator.plugins.length; i ++ ) {
        if (navigator.plugins[i].name.toLowerCase.indexOf(name) > -1) {
            return true;
        }
    }
    return false;
}

alert(hasPlugin("Flash"));
```



## history对象

```js
// 页面前进和后退
history.back();
history.forward();

// 是否是用户打开窗口的第一个页面
if (history.length == 0) {
    // ...
}
```



