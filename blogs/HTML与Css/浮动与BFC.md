## 布局

`position: absolute` 和 float 会隐式地改变 display 类型，不论之前是什么类型的元素 (display:none) 除外，主要设置 `position: absolute` 和 float 中任意一个，都会让元素以 `display: inline-block` 的方式显示，**可以设置长宽，默认宽度不占满父元素**



## 负外边距

`margin-left和margin-top`：影响自身元素，将向指定方向偏移

`margin-right和margin-bottom`：影响相邻元素，将其拖入指定方向 (将自身拖入指定方向？)

**对于浮动元素有些例外：**

当负值的 margin 的方向与浮动流方向一致时，则元素会往对应的方向移动对应的距离。当负值的 margin 的方向与浮动流方向相反时，则元素本身不动，元素之前或者之后的元素会向该元素的方向移动相应的距离。



## BFC

块级格式化上下文(Block Formatting Context)，它是页面中的一块渲染区域，并且有一套渲染规则，它决定了其子元素将如何定位，以及和其他元素的关系和相互作用。



### 触发BFC的条件

- body 根元素
- 浮动元素：float 除 none 以外的值
- 绝对定位元素：position (absolute、fixed)
- display 为 inline-block、table-cells、flex
- overflow 除了 visible 以外的值 (hidden、auto、scroll)



### 1. 解决父元素高度塌陷问题

```html
<div class="box-wrapper">
  <div class="box"></div>
</div>

.box-wrapper {
	overflow: hidden;
	.box {
		float: left;
		width: 100px
		height: 100px;
	}
}
```

### 2. 消除外边距折叠

发生外边距的条件：

1. 都是普通流中的元素且属于同一个 BFC
2. 没有被 padding、border、clear 或非空内容隔开
3. 两个或两个以上垂直方向的「相邻元素」

```html
<!-- 1. 兄弟元素 -->
<div class="box-1"></div>
<div class="box-2"></div>

.box-1 {
	overflow: hidden;
	margin-bottom: 20px;
}
.box-2 {
	overflow: hidden;
	margin-top: 20px;
}

<!-- 2. 父子元素 -->
<div class="parent">
  <div class="child"></div>
</div>

.parent {
	overflow: hidden;
	.child {
		overflow: hidden;
		margin-top: 20px;
	}
}
```

### 3. BFC容器不会与浮动元素发生重叠

```html
<div class="box-wrapper">
  <div class="box"></div>
  <div class="text"></div>
</div>

.box-wrapper {
  overflow: hidden;
  .box {
    width: 100px;
    height: 100px;
  }
  .text {
    overflow: hidden;
    height: 100px;
  }
}
```

### zoom: 1

这条命令的作用是激活父元素的 `hasLayout` 属性，让父元素拥有自己的布局。`IE6` 会读取这条命令，其它浏览器会直接忽略它。



## 浮动列表布局

有太多匪夷所思的地方，比如对父元素设置百分比定宽子元素用margin无法撑大父元素宽度，却可以撑开其高度？



## 常见布局

### 1. 两列自适应布局

**特征：**左侧由内容撑开，右侧自适应占满剩余空间

```js
div class="container">
    <div class="left">left</div>
	<div class="right">right</div>
</div>

1. float + 触发BFC
.container {
    width: 80%;
    margin: 0 auto;
    overflow: hidden;
}
.left {
    float: left;
    background: silver;
}
.right {
    overflow: hidden;
    background: skyblue;
}

2. flex布局
.container {
    width: 80%;
    margin: 0 auto;
    display: flex;
}
.left {
    background: silver;
}
.right {
    flex: 1;
    background: skyblue;
}
```

### 2. 粘连布局

**特征：** 页面的 footer 始终粘连在页面的底部，即使主体内容高度不够

```js
<div class="wrapper">
    <div class="main"></div>
</div>
<div class="footer"></div>

.wrapper {
    min-height: 100%;
    box-sizing: border-box;
    padding-bottom: 50px;
}
.footer {
    height: 50px;
    margin-top: -50px;
}
```

