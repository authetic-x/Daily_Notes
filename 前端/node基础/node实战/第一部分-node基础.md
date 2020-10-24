官网定义 `node`：

> 一个搭建在Chrome JavaScript运行时上的平台，用于构建高速、可伸缩的网络程序

Node.js 采用事件驱动、非阻塞 I/O 模型，适合于构建数据密集型实时引用，即 DIRT (data-intensive real-time)



### 读取图片

```js
const http = require("http");
const fs = require("fs");

http.createServer(function(req, res) {
    res.writeHead(200, {'Content-Type': 'image/png'});
    fs.createReadStream("./empty.png").pipe(res);
}).listen(3000);
```



