### 1. 行高设置垂直居中

问题：为什么不适用于div，比如下面的无效：

```js
.father {
    width: 200px;
    height: 200px;
    border: 1px solid red;
}

.son {
    width: 100px;
    height: 100px;
    line-height: 200px;
    background-color: blue;
}

<div class="father">
	<div class="son"></div>
</div>
```

原因是行高本质是设置文本一行的高度，文本在一行中是垂直居中的。所以将文本的行高等于父容器的高度可以设置文本垂直居中，但不适用于其它非文本元素。行高可以继承，也可在父元素中设置。

**解决方案：**

* 设置 padding 填充
* 设置父元素为 table + 设置 vertical-align
* relative + absolute
* css3的 transform
* flex、grid
