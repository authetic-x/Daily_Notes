### 值接收者和指针接收者的区别

```go
type coder interface {
	code()
	debug()
}

type Gopher struct {
	lang string
}

func (p Gopher) code() {
	fmt.Printf("I'm coding %s language\n", p.lang)
}

func (p *Gopher) debug() {
	fmt.Printf("I'm debug %s language\n", p.lang)
}

func main() {
	php := Gopher{"php"}
	php.code()
	php.debug()

	python := &Gopher{"python"}
	python.code()
	python.debug()
}
```

Go 提供了一个语法糖，也就是利用值接收者调用指针接受者定义的方式时，会做隐式转化，即 `(&php).debug`，反之亦然，`(*python).code`

但有一个区别是实现了接收者是值类型的方法，相当于自动实现了接收者是指针类型的方法；而实现了接收者是指针类型的方法，不会自动生成对应接收者是值类型的方法

```go
func main() {
	var bob coder = &Gopher{"C++"}
	bob.code()
	bob.debug()
}
// 以上代码正常输出
// I'm coding C++ language
// I'm debug C++ language

func main() {
    var bob coder = Gopher{"C++"}
	bob.code()
	bob.debug()
}
```

而将&符号去掉时，会编译报错，`cannot use Gopher literal (type Gopher) as type coder in assignment: Gopher does not implement coder (debug method has pointer receiver)`，报错信息说 Gopher 没有实现coder这个接口，因为debug方法传入的是指针接收者，也就是说只有*Gopher类型才实现了coder这个接口。

### iface 和 eface的区别

```go
type iface struct {
    // 表示接口的类型以及赋给这个接口的实体类型
    tab *itab
    // 指向接口具体的值，一般是一个指向堆内存的指针
    data unsafe.Pointer
}

type eface struct {
    _type *_type
    data unsafe.Pointer
}
```

它们两个都是用来描述接口的底层结构体，区别在于iface描述的接口包含方法，而eface是不包含任何方法的空接口: `interface{}`

### 动态值和动态类型

接口值包括动态类型和动态值，接口值的零值是指这两部分的值都为nil

```go
type Coder interface {
	 code()
}

type Gopher struct {
	 name string
}

func (g Gopher) code() {
	fmt.Printf("%s is coding\n", g.name)
}

func main() {
	var c Coder
	fmt.Println(c == nil)
	fmt.Printf("c: %T, %v\n", c, c)

	var g *Gopher
	fmt.Println(g == nil)

	c = g
	fmt.Println(c == nil)
	fmt.Printf("c: %T, %v\n", c, c)
}
```

Output:

```
true
c: <nil>, <nil>
true
false
c: *main.Gopher, <nil>
```

当 g 赋给 c 后，c 的动态类型变成了 *main.Gopher，尽管 c 的动态值任为 nil，但与 nil 比较为 false



### 类型转换和断言的区别

Go中不允许隐式类型转换，也就是说 = 两边不允许出现不相同的变量。类型转换和类型断言本质都是一个类型转换成另外一个类型，不同的是，类型断言只是对接口类型进行的操作

#### 类型转换

><结果类型> := <目标类型>(表达式)

```go
var i int = 10
f := float64(i)
```

#### 类型断言

因为空接口 `interface{}` 没有定义任何函数，因此 Go 中所有类型都实现了空接口。

```go
type Student struct {
    name string
}

func main() {
    var i interface{} = new(Student)
    s := i.(Student)
    fmt.Println(s)
}
```

以上程序运行会产生 panic，即断言失败，i 是 *Student 类型，可以采用安全断言的方法，多接受一个判断值

```go
s, ok := i.(Student)
if ok {
	fmt.Println(s)
}
```

这样即使断言失败也不会 panic，还有一种断言形式是在switch 中对 `interface{}` 使用 v.(type)

