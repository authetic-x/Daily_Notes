[toc]

## 元素大小

### element.scrollHeight/scrollWidth

表示元素内容真实大小，包含溢出部分

### element.clientWidth/clientHeight

表示元素可视区大小

### element.offsetWidth/offsetHeight

表示元素的 `border + padding + content`，这里的 content 因该是指可视区大小，即 `client` 表示的值



## 元素位置

### element.scrollLeft/Top

表示元素已滚动的距离

### element.offsetLeft/Top

表示元素相对于 `element.offsetParent` 左边界偏移的值

### element.getBoundingClientRect()

返回元素大小及其相对于视口的位置



## 鼠标位置

### MouseEvent.clientX/Y

表示事件发生时鼠标相对于视口左上角的偏移值

### MouseEvent.pageX/Y

表示事件发生时鼠标相对于浏览器左上角的偏移值

​	

## getBoundingClientRect

`Element.getBoundingClientRect()` 方法返回元素的大小及其相对于视口的位置。

返回值是一个 `DOMRect` 对象，返回的结果是包含完整元素的最小矩形，并且拥有 `left`, `top`, `right`, `bottom`, `x`, `y`, `width`, 和 `height` 这几个以像素为单位的只读属性用于描述整个边框。

```js
const el = document.getElementById('wrapper')
const rect = el.getBoundingClientRect()
const top = rect.top
```

## getComputedStyle

返回一个 `CSSStyleDeclaration` 对象，表示元素的 CSS 属性

```js
const el = document.getElementById('wrapper')
let style = window.getComputedStyle(element, null);
const marginVal = style.getPropertyValue('margin')
```

