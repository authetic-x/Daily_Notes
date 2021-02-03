## <script> 标签

### async 属性

MDN 定义如果 `script` 标签定义了 `async` 属性那么脚本会被并行请求，并尽快解析和执行。设置该属性可以不必让浏览器阻塞的解析 Javascript

### defer 属性

设置该属性脚本将在文档完成解析后，触发 `DOMContentLoad` 事件前执行。defer 属性对模块脚本无效，因为它们默认就是 defer



## <meta> 标签





## 全局事件

### DOMContentLoaded

当初始的 **HTML** 文档被完全加载和解析完成之后，**`DOMContentLoaded`** 事件被触发，而无需等待样式表、图像和子框架的完全加载

### window.onload

页面完全加载完毕时触发，包括样式表、图片等资源

