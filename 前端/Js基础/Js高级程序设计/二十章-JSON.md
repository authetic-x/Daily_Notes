JSON 是一种数据格式。每个属性可以是简单值、对象、数组。

JSON 中字符串必须用双引号，对象的属性也必须用双引号



## 解析与序列化

```js
var book = {
    "title": "One Hunderd Years Of Solitude",
    "author": "Gabriel García Márquez",
    "year": 1967
};

// 第二个参数为过滤函数，第三个参数表示缩进；两个都是可选参数
var jsonText = JSON.stringify(book, function(key, value) {
    switch(key) {
        case "title":
            return value.join("-");
        case "author":
            return value.join(".");
        default:
            return value;
    }
}, 4);

var bookCopy = JSON.parse(jsonText);
```

如果为对象设置了 `toJSON()` 方法，那么调用 `stringify()` 时会优先调用该方法。