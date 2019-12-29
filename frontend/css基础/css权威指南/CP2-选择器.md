## 元素选择器

```css
h1 {
    color: gray;
}
// 分组
h2, p {
    color: yellow;
}
```



## 类选择器和ID选择器

```java
p.warning {
    font-weight: bold;
}

#first-para {
	font-weight: bold;
}
```

区别：id 值是唯一的，仅能有一个元素拥有。且不同于类选择器，ID 选择器不能结合使用，即不允许有以空格分隔的词列表



## 属性选择器

```java
h1[class] {
    color: silver;
}
```



## 后代选择器和子选择器

```java
// 标记h1中所有em后代元素
h1 em {
    color: gray;
}

// 子元素，直接的父子关系
h1 > strong {
    color: red;
}
```



## 伪类

```java
// 就像a标签有一个link类一样
a:link {color: blue;}
a:visited {color: red;}
a:hover {
    font-size: 20px;
}

input:focus {
	background: silver;
	font-weight: bold;
}
```



## 伪元素

```java
p:first-letter {
    font-size: 200%;
}
p:first-line {
    color: purple;
}

h2:before {
    content: "]]";
    color: silver;
}
h2:after {
    content: "The end;";
}
```

