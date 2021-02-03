# requestAnimationFrame 和 setTimeout 的区别

## 前言

requestAnimationFrame 绝对是面试的高频题目，MDN 对于这个方法的解释是：

> **`window.requestAnimationFrame()`** 告诉浏览器，你希望执行一个动画，并且要求浏览器在下次重绘之前调用指定的回调函数更新动画。该方法需要传入一个回调函数作为参数，该回调函数会在浏览器下一次重绘之前执行

光这样说比较难以理解，我们来详细分析一下。



## 屏幕刷新率

屏幕刷新率一般指图像每秒钟刷新的次数，单位是赫兹(HZ)。比如 60HZ 就表示一秒钟刷新60次。为什么要刷新图像呢？因为如果不刷新图像，那么页面就是绝对静止的，也就是不会有任何的动画效果。

我们电影的原理就是利用了人眼的**视觉停留效应**，人看到的画面会在大脑中停留一段短暂的时间，如果画面以极短的时间不断地变化，那么我们就能看到连续的画面，变化频率的最低要求是1秒24帧，变得比这个慢就会感觉到画面出现卡顿。



## 浏览器动画原理

浏览器动画的本质是让图像不断的刷新，如60HZ的屏幕会使图像每 16.7ms刷新一次。如果我们每次刷新都将图像移动一个像素，由于刷新的效果很快，我们就会看到图像在连贯、平滑的移动。



## requestAnimationFrame

给 requestAnimationFrame 注册的回调函数的执行时机是由系统的刷新频率来决定的。通俗的将，如果刷新频率是60HZ，那么就会每隔16.7ms执行一次，回调函数的执行是跟着屏幕刷新频率走的。**它能保证回调函数在屏幕每一次的刷新间隔中只被执行一次**，这样就不会引起丢帧现象，也不会导致动画出现卡顿的问题。



## 与 setTimeout 的区别

1. **setTimeout 的执行时机不确定**

   setTimeout 只是将回调函数在某个时间点后加入到宏任务执行队列，具体什么时候执行还要看执行栈里有没有其它的任务

2. **requestAnimationFrame 更节省性能**

   使用setTimeout实现的动画，当页面被隐藏或最小化时，setTimeout 仍然在后台执行动画任务，由于此时页面处于不可见或不可用状态，刷新动画是没有意义的，完全是浪费CPU资源。而requestAnimationFrame则完全不同，当页面处理未激活的状态下，该页面的屏幕刷新任务也会被系统暂停，因此跟着系统步伐走的requestAnimationFrame也会停止渲染，当页面被激活时，动画就从上次停留的地方继续执行，有效节省了CPU开销。



## requestAnimationFrame 实践

### 动画

```js
let deg = 0

const div = document.getElementById('wrapper')

div.addEventListener('click', (e) => {
  const el = e.currentTarget
  requestAnimationFrame(function change() {
    el.style.transform = `rotate(${deg++}deg)`
    if (deg < 360) {
      requestAnimationFrame(change)
    }
  })
})
```

### 长列表渲染

```js
const total = 10000
const size = 100
let done = 0
const ul = document.getElementById('list')

function addItems() {
  let li = null
  const fg = document.createDocumentFragment()
  for (let i = 0; i < size; i ++ ) {
    li = document.createElement('li')
    li.innerText = `item-${done * size + i}`
  }
  ul.appendChild(fg)
  done++

  if (done < total / size) {
    requestAnimationFrame(addItems)
  }
}

requestAnimationFrame(addItems)
```

