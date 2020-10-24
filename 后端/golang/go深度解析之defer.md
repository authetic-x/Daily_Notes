`  defer` 是Go语言提供的一种用于注册延迟调用的机制，常用于打开/关闭文件，加锁解锁等成对的操作，典型的特征是后进先出。

在 `defer` 函数定义时，对外部变量的引用有两种方式，分别是作为函数参数和闭包引用。作为函数参数时，定义时把值传递给defer，作为闭包的话，会在defer函数真正调用时根据整个上下文确定当前的值。对于前者需要注意的是，**函数调用的参数会被保存起来，相当于把调用的参数复制了一份**，如果这个变量是一个“值”，那么参数在函数执行时和定义时是一样，如果变量是一个“引用”，那么就可能会发生变化。如下：

```go
type number int

func (n number) print() {
    fmt.Println(n)
}
func (n *number) pprint() {
    fmt.Println(*n)
}

func main() {
    var n number
    
    defer n.print()  // 0
    defer n.pprint() // 3
    // 下面两个是闭包
    defer func() {
        n.print()
    }()              // 3
    defer func() {
        n.pprint()
    }()              // 3
    
    n = 3
}

```



### defer的陷阱

```return xxx``` 经编译后可拆解为三条指令

```
1. 返回值 = xxx
2. 调用defer函数
3. 空的return
```

来看些例子：

```go
func f() (r int) {
    t := 5
    defer func() {
        t = t+5
    }
    return t
}
// r先被赋值为t，然后执行defer函数，最后空return返回
// 所以函数返回值为5

func f() (r int) {
    defer func(r int) {
        r = r+5
    }(r)
    return 1
}
// r同样先被赋值为1，然后执行defer，因为传进去的r是一个值拷贝，
// 所以不会影响返回的r，最终r返回1
```

始终记住一点，如果不是以闭包的形式传入参数，那么在defer定义时参数的值就已经固定了，即复制了一份，只不过引用类型指向的是地址，如果地址里的内容发生变化，参数的值自然也会变化



### 闭包

`闭包 = 函数 + 引用环境`

匿名函数也被称为闭包，一个闭包继承了函数声明时的作用域。在Golang中，所有的匿名函数都是闭包。

```go
func main() {
	var a = Accumulator()
	fmt.Printf("%d\n", a(1))
	fmt.Printf("%d\n", a(10))
	fmt.Printf("%d\n", a(100))

	fmt.Println("------------------")

	var b = Accumulator()
	fmt.Printf("%d\n", b(1))
	fmt.Printf("%d\n", b(10))
	fmt.Printf("%d\n", b(100))
}
func Accumulator() func(int) int {
	var x int

	return func(delta int) int {
		fmt.Printf("(%+v, %+v) - ", &x, x)
		x += delta
		return x
	}
}
```

```
Output:
(0xc000062080, 0) - 1
(0xc000062080, 1) - 11
(0xc000062080, 11) - 111
------------------
(0xc0000620d8, 0) - 1
(0xc0000620d8, 1) - 11
(0xc0000620d8, 11) - 111
```



### 配合recover使用

recover 常与 defer 配合使用，防止某个 goroutine 发生 panic 而导致整个程序崩溃，还能方便定位 bug

```go
func main() {
	defer fmt.Println("defer main")
	var user = os.Getenv("USER_")

	go func() {
		defer func() {
			fmt.Println("defer caller")
			if err := recover(); err != nil {
				fmt.Println("recover success, err: ", err)
			}
		}()

		func() {
			defer func() {
				fmt.Println("defer here")
			}()

			if user == "" {
				panic("Should set user env")
			}

			// won't execute
			fmt.Println("after panic")
		}()
	}()

	time.Sleep(100)
	fmt.Println("end of main function")
}
```

```
defer here
defer caller
recover success, err:  Should set user env
end of main function
defer main
```

