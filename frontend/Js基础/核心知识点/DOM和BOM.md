## document

js 中 `document` 对象就代表了 DOM

### document.documentElement

> `Document.documentElement` returns the [`Element`](https://devdocs.io/dom/element) that is the root element of the [`document`](https://devdocs.io/dom/document) (for example, the <html> element for HTML documents).



## Element

### Element.clientWidth

表示元素**可视区**的宽度，包含 `padding` 不包含 `border`，不包含滚动条

### Element.clientTop

元素上 `border-top` 的宽度

### Element.scrollHeight

表示整个元素的高度，包含不可见的部分，计算方式和 `clientWidth` 一样

### Element.scrollTop

读取或设置一个元素的内容在竖直方向滑动了多少像素

#### 利用以上属性判断滚动条是否滚动到了底部

```js
window.onscroll = () => {
    const html = document.documentElement;
    const clientHeight = html.clientHeight;
    const scrollTop = html.scrollTop;
    const scrollHeight = html.scrollHeight;
    if (clientHeight+scrollTop === scrollHeight) {
        alert("already scrolled to the bottom!");
    }
}
```





## window

### window.innerWidth

浏览器窗口的宽度