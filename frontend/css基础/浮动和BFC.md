## 布局

`position: absolute` 和 float 会隐式地改变 display 类型，不论之前是什么类型的元素 (display:none) 除外，主要设置 `position: absolute` 和 float 中任意一个，都会让元素以 `display: inline-block` 的方式显示，可以设置长宽，默认宽度不占满父元素



## 负外边距

`margin-left和margin-top`：影响自身元素，将向指定方向偏移

`margin-right和margin-bottom`：影响相邻元素，将其拖入指定方向 (将自身拖入指定方向？)

**对于浮动元素有些例外：**

当负值的 margin 的方向与浮动流方向一直时，则元素会往对应的方向移动对应的距离。当负值的 margin 的方向与浮动流方向相反时，则元素本身不动，元素之前或者之后的元素会向该元素的方向移动相应的距离。



## BFC

### 特征

1. 不会与浮动元素发生重叠
2. 包含浮动元素，父元素会计算浮动元素的高度，不会发生塌陷
3. 没有外边距折叠 (外边距折叠主要发生在相邻兄弟元素和父子元素中，外边距取大者)



### zoom: 1

这条命令的作用是激活父元素的 `hasLayout` 属性，让父元素拥有自己的布局。`IE6` 会读取这条命令，其它浏览器会直接忽略它。



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

