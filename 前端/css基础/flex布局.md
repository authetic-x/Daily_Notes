Flexible Box 是一种一维的布局模型。使用 `flex` 布局时，首先想到的就是它的两根轴线：`主轴和交叉轴`，这确定了子元素的排列方式。其由 `flex-direction` 属性控制，有四个可选值：`row, row-reverse, column, column-reverse`。

设置 `display:flex;` 就可以创建一个 `flex` 容器，容器中的直系子元素就会变为 `flex` 元素。`flex` 元素有一些默认行为：

1. 元素排列为一行
2. 元素不会在主轴方向拉伸，但可以缩小
3. 元素被拉伸来填充交叉轴大小
4. `flex-basis` 为 `auto`
5. `flex-wrap` 为 `nowrap`



### flex-wrap

我们应当把 `flex` 布局中的每一行看作是一个单独的 `flex` 容器，可以设置 `flex-wrap: wrap;` 来实现多行效果。如果不设置这个属性，`flex` 元素的总宽度大于容器宽度且无法缩小时，`nowrap` 默认值会导致溢出而不是换行。

`flex-flow` 是 `flex-direction` 和 `flex-wrap` 的简写属性



### flex 元素的三个常用属性

#### flex-basis

这个属性定义了元素的空间大小，默认值为 `auto`，也就是说适应内容宽度。如果设置了宽度为100px，则 `flex-basis` 的值就为100px

#### flex-grow

这个属性用于设置元素分配容器**可用空间**的比例。比如两个子元素宽度为100px, 容器300px, 两个元素都设置这个属性为1，相当于按 `1:1` 的比例平分剩余的100px可用空间

#### flex-shrink

这是相对于处理元素收缩的属性，计算方法比 `flex-grow` 复杂一些，原则是给 `flex-shrink` 属性设置更大的值会使元素收缩程度更大



`flex: flex-grow flex-shrink flex-basis` 是设置以上三个属性的简写形式。它有几个预定义的值：`initial, auto, none`，`flex: initial` 是 `flexbox` 的默认值，对应 `flex: 0 1 auto;`，其余两个分别对应 `flex: 1 1 auto; flex: 0 0 auto`。类似于 `flex: 1;` 这种简写形式对应的是 `flex: 1 1 0`，也就是说元素是以 `flex-basis: 0;` 的基础伸缩的



### 元素对齐和空间分配

#### align-items

设置元素在交叉轴方向的对齐，初始值为 `stretch`，这也解释了为什么 `flex` 元素会被默认拉伸到容器的高度。可设置的值还有 `flex-start, flex-end, center`

### justify-content

设置元素在主轴方向的对齐，初始值为 `flex-start`。可选值有 `stretch, flex-start, flex-end, center, space-between, space-around`，`stretch` 暂时还不知道用法，值得注意的是最后的两个值。`space-between` 把元素排列好之后的剩余空间拿出来，平均分配到元素之间，使元素之间间隔相等；而 `space-around` 是使每个元素左右的空间相等。从名称来看很容易理解。