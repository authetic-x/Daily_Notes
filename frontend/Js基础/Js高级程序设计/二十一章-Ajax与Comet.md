## XMLHttpRequest

```js
var xhr = new XMLHttpRequest();
xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) {
        if ((xhr.status >= 200 && xhr.status < 300) 
            || xhr.status == 304) {
            alert(xhr.responseText);
        } else {
            alert("Request was unsuccessful: " + xhr.status);
        }
    }
}

// false表示同步
xhr.open("get", "example.txt", false);
xhr.setRequestHeader("MyHeader", "MyValue");
xhr.send(null);

//传递表单数据
var form = document.getElementById("user-info");
var data = new FormData(form);
data.append("email", "----------");
xhr.send(data);

// 超时设定
xhr.timeout = 1000;
xhr.ontimeout = function() {
    alert("error!");
};

// 进度事件
xhr.onload = function() {
    if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304) {
        alert(xhr.responseText);
    } else {
        alert("Request was unsuccessful: " + xhr.status);
    }
};
xhr.onprogress = function(event) {
    var status = document.getElementById("status");
    if (event.lengthComputable) {
        status.innerHTML = "Received " + event.position + " of " +
                            event.totalSize + " bytes.";
    }
};
```



## CORS (Cross-Origin Resource Sharing)

### 跨浏览器的 CORS

```js
function createCORSRequest(method, url) {
    var xhr = new XMLHttpRequest();
    if ("withCredential" in xhr) {
        xhr.open(method, url, true);
    } else if (typeof XDomainRequest != "undefined") {
        xhr = new XDomainRequest();
        xhr.open(method, url);
    } else {
        xhr = null;
    }
    return xhr;
}

var request = createCORSRequest("get", "http://www.somewhere-else.com/page/");
if (request) {
    // 指加载成功
    request.onload = function() {
        // ...
    };
    request.send();
}
```



## JSONP(JSON with padding)

由两部分组成：回调函数和数据。回调函数是当响应到来时应该在页面中调用的函数，数据就是传入回调函数中的 JSON 数据

```js
function handleResponse(response) {
    alert("You're at IP address " + response.ip + ", which is in" +
            response.city + ", " + response.region_name);
}

var script = document.createElement("script");
script.src = "http://freegeoip.net/json/?callback=handleResponse";
document.body.insertBefore(script, document.body.firstChild);
```



## Comet

指一种服务器向页面推送数据的技术，一般有两种实现方式：

### 长轮询

短轮询是指定时向服务器发送请求，看有没有更新的数据；而长轮询值页面发送一个请求，服务器一直保持连接打开，直到有新的数据发送。发送完数据后，连接关闭，随即又发起一个新的请求。

### 流

流不同于轮询，它在页面的整个生命周期内只使用一个 HTTP 连接。也就是说，浏览器向服务器发送一个请求，而服务器保持连接打开，然周周期地向浏览器发送数据。



## 服务器发送事件

### SSE (Server-Sent Events)

SSE 是围绕只读 Comet 交互推出的 API 或者模式。服务器响应的 MIME 类型必须是 `text/event-stream`。可以说 SSE 是 Comet 的一种简捷的实现方式，也支持跨域

```js
var source = new EventSource("myevents.php");

source.onmessage = function(event) {
    var data = event.data;
    // ...
}
```



## Web Sockets

Web Sockets 的目标是在一个单独的持久连接上提供全双工、双向通信。其使用了自定义协议，只有支持这种协议的专门服务器才能正常工作。其能够在客户端和服务器之间发送非常少量的数据，而不必担心 HTTP 那用的字节级开销，因此十分适合聊天室这一类型的应用。

```js
var socket = new WebSocket("ws://www.example.com/server.php")
socket.send("Hello, World!");

var message = {
    time: new Date(),
    text: "hahah"
};

socket.send(JSON.stringify(message));
socket.onmessage = function(event) {
    var data = event.data;
    // ...
}
```





