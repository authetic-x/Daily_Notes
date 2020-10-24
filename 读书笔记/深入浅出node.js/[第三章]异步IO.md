## 并行I/O

异步 I/O 和非阻塞 I/O 貌似是两回事，可以简单理解为异步 I/O 是针对应用程序层面的说法，而非阻塞 I/O 是针对系统内核层面的。

操作系统内核处理 I/O 的方式只有两种：阻塞I/O和非阻塞I/O。阻塞 I/O 要等到系统内核层面完成所有操作后调用才结束，这会让 CPU 等待 I/O，造成 CPU 的浪费；非阻塞 I/O 则立即返回当前调用状态，可提升 CPU 利用率。

Node 的单线程仅仅指语言层面，它的 libuv 底层用的是多线程的 I/O 架构。

## 异步 API

1. setTimeout/setInterval
2. process.nextTick()
3. setImmediate()