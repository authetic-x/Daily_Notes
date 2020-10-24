## 百分比规则

1. [top, left], [width, height]

   参照于包含块对应的宽高

2. [margin, padding]

   参照包含块的宽度，典型的应用场景就是利用 `padding` 写一个宽高比例固定的区域，如图片防闪烁问题

   ```js
   <div class="img-wrapper">
     <div class="img">
     	<img src="..." />
     </div>
   </div>
   
   .img {
     position: relative;
     width: 200px;
     height: 0;
     padding-bottom: 50%;
     img {
       position: absolute;
       top: 0;
       left: 0;
       right: 0;
       bottom: 0;
     }
   }
   ```

3. translate

   基于自身宽高的百分比值