```html
<div class="rhombus"></div>

<div class="triangle"></div>

<div class="trapezoid"></div>

<div class="parallelogram"></div>

div {
  display: inline-block;
  margin: 50px;
}

.rhombus {
  width: 100px;
  height: 100px;
  background: pink;
  transform: rotate(45deg);
}

.triangle {
  width: 0;
  height: 0;
  border: 50px solid #fff;
  border-left-color: transparent;
  border-right-color: transparent;
  border-bottom-color: transparent;
}

.trapezoid {
  width: 60px;
  height: 0;
  border: 50px solid #fff;
  border-left-color: transparent;
  border-right-color: transparent;
  border-bottom-color: transparent;
}

.parallelogram {
  width: 100px;
  height: 100px;
  background: pink;
  transform: skew(-30deg);
}
```

