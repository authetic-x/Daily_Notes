slice 在源码里是一个很简洁的结构体

```go
type slice struct {
    array unsafe.Pointer  // 指向底层数组的首地址
    len int
    cap int
}
```



### slice的创建

```go
var slice []int

var slice = *new([]int)

var slice = []int{1,2,3,4,5}

var slice = make([]int, 5, 10)

var slice = array[1:5]
```

前两个创建出来的是 `nil slice`， 它和 `empty slice` 是有区别的，前者与 nil 比较为 true, 后者为 false，空切片可以这样创建 `var slice = []int{}` ，所有空切片的指针都指向同一个地址。注意 `nil slice` 和 `empty slice` 都可以直接用 append 添加元素



### 传slice和slice指针有什么区别

Go都是值传递，当传入slice时相当于传入了一个结构体，直接修改拷贝的slice并不会影响实参，但由于都指向同一个底层数组，因此修改数组元素会改变实参指向的值。若要修改实参，可传入slice的指针

```go
func f(s []int) {
    for i := range s {
        s[i] += 1
    }
}

func myAppend(s []int) {
    s = append(s, 1,2,3)
}

func myAppendPtr(s *[]int) {
    *s = append(*s, 1,2,3)
}

func main() {
    s := []int{1,1,1}
    f(s) // s: 2,2,2
    
    myAppend(s) // s:2,2,2
    myAppend(&s) // s: 2,2,2,1,2,3
}
```

