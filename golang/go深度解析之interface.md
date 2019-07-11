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

Go 提供了一个语法糖，也是利用值接收者调用指针接受者定义的方式时，会做隐式转化，即 `(&php).debug`，反之亦然，`(*python).code`

但有一个区别是实现了接收者是类型的方法，相当于自动实现了接收者是指针类型的方法；而实现了接收者是指针类型的方法，不会自动生成对应接收者是值类型的方法

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