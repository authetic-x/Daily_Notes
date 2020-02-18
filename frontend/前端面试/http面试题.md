## 掘金高频

1. 浏览器缓存
2. http 和 https 的区别
3. 输入 url 到网页呈现的过程
4. cookie，session，token各种细节
5. http1.0/1.1/2.0
6. SSL/TLS握手, 保密性？ 完整性？证书？浏览器如何验证CA是否正确？
7. XSS, CSRF？区别？举个例子？
8. 206
9. token为什么能抵抗csrf
10. dns
11. cdn
12. 浏览器内核
13. tcp/ip 三次握手，四次挥手



## 问题解决方案总结：

### 1. cookie/session, token, JWT (Json Web Token)

cookie 和 session 主要用来实现会话跟踪，因为 http 协议是无状态的。在用户第一次登录后，服务端会创建一个 session 用来保存会话信息，并且在响应的报文中会有一个 `set-cookie` 字段，里面保存了 sessionId。cookie 存储在客户端，以后发出的请求都会带上 cookie，这样就可以实现类似免登录的功能。cookie 只能存储字符串，常见字段有 `name=value, maxAge, secure, httpOnly, domain`，cookie 不能跨域使用。session 的问题是如何服务器是一个集群，session 就需要做跨域共享，可以用 session 持久化去解决，所有主机向持久层数据库访问 session，缺点是比较耗费资源，工程量大。

token 是一种认证鉴权机制。简单 token 的组成： uid(用户唯一的身份标识)、time(当前时间的时间戳)、sign（签名，token 的前几位以哈希算法压缩成的一定长度的十六进制字符串）。Access Token 可以理解为访问资源接口时所需要的凭证，一个令牌表示你有做某种事情的权限。用户第一次登录后服务端会返回一个 token，以后每次请求带上 token 就可以实现身份验证。Refresh Token 是用来刷新 Access Token 的。**基于 token 的用户认证是一种服务端无状态的认证方式，服务端不用存放 token 数据**， **token 完全由应用管理，所以它可以避开同源策略**

JWT 是目前比较流行的跨域认证解决方案。JWT 的原理就是生成一个 JSON 对象，用 bae64URL 算法转化为字符串后拼接成 token 返回给客户端。JWT 的组成部分： `Header, Payload,Signature ` ，每个都是 JSON 对象，其中实际需传递的数据保存在 Payload 里，Signature 是对前两部分的签名，防止数据被篡改。JWT 可以存储在 cookie 或 localStorage 里，但用 cookie 就不能跨域了。最佳实践是放在 Authorization 字段里，还有一种是放在 POST 里。JWT 最大缺点是服务器是无状态的，无法在使用过程中废止某个 token，只能等它过期。



### 2. 跨域的解决方案：

1. jsonp，通过类似 `<script>` 标签引入 js 的形式来跨域，并且需要在 url 传入一个 callback 函数作为参数。其优点是兼容性好，缺点是只支持 get 请求

2. CORS, 跨域资源共享。浏览器一旦发现AJAX请求跨域，就会自动添加一些附加的头信息，只要服务器实现了CORS接口，就可以跨域通信。Access-Control-Allow-Origin

3. HTML5 的 postMessage。通过事件监听的方式实现两个页面间的通信

   ```js
   // 页面A
   window.onload = () => {
   	const ifr = document.getElementById('ifr');
   	const targetOrigin = "http://www.google.com";
   	ifr.contentWindow.postMessage('hello world', targetOrigin);
   }
   
   // 页面B
   const onMessage = (event) => {
   	const data = event.data;
   	const origin = event.origin;
   	const source = event.source;
   	if (origin === 'http://www.baidu.com') {
   		console.log(data);
   	}
   }
   
   window.addEventListener('message', onMessage, false);
   ```

4. WebSocket，HTML5下一种新的协议。 它实现了浏览器与服务器全双工通信，适合体量小的，需要双向数据传输的应用。

5. 如果主域相同，子域不同，可用 iframe 相关解决方案



### 3. Post 表单字段

* application/x-www-form-urlencoded， 不设置 `enctype` 的默认值

* multipart/form-data 上传表单文件，要设置 `enctype=multipart/form-data`

* application/json，现在流行传输序列化后的 json 字符串



### 4. http1.1

主要是新增了几个头部字段和错误状态响应码。如关于缓存的 `If-match`，断点续传相关的 `range`，其响应码是 206，请求主机名的 `host`，长连接的 `connection:keep-alive`



### 5. http2.0

* http1.x 的解析是基于文本的，而 http2.0 的解析是基于二进制的。
* 多路复用，多个请求可以共用一个连接
* header 压缩，通讯双方各维护一份 `header fields` 表，通过编码的方式避免了一些 header 的重复传输

注意 http1.1 的长连接请求是串行执行的，而 http2.0 的请求是并行的，可以同时发出多个请求

