## 三栏布局

```html
<div class="container">
  <div class="left">
  	left
  </div>
  <div class="middle">
		middle
  </div>
  <div class="right">
    right
  </div>
</div>
```

### flex

```js
.container {
  display: flex;
  .left, .right {
    flex: 0 0 50px;
  }
  .middle {
    flex: 1;
  }
}
```

### 浮动

```js
.left {
  float: left;
  width: 50px
}
.right {
  float: right;
  width: 50px;
}
.middle {
  margin: 0 50px;
  // padding: 0 50px;
}
```

### 绝对定位

```js
.container {
  position: relative;
  .left {
    position: absolute;
    left: 0;
    width: 50px;
  }
  .right {
    position: absolute;
    right: 0;
    width: 50px;
  }
  .middle {
    margin: 0 50px;
  }
}
```

### calc

```js
.container {
  .left, .right {
    width: 50px;
  }
  .middle {
    width: calc(100% - 100px);
  }
}
```

