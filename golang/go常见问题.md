1. slice 和 map 不可比较，唯一可与 nil 比较

2. slice 唯一可与nil比较，注意空 len(slice) == 0 不一定意味着 slice == nil 。使用 append 对slice扩容时，会先检查底层数组容量够不够，足够直接插入，不够则可能开辟一段更大的存储空间，返回的slice引用新的底层数组

3. 访问map中不存在的key将会返回value类型对应的零值。不能对map的元素进行取址操作，原因是map中的元素地址可能会动态变化。map中的元素是无序的，想要有序访问，可先将key存储到一个切片中，对切片进行排序后再去顺序访问。向一个 nil 值的map存入元素将会导致 panic 异常。注意：map中的key必须是可比较类型，若想将slice这种类型元素用作map的key，可先用一个辅助函数将slice这种不可比较类型转换为string这种可比较类型。

   ```go
   // 顺序访问 map 中的元素
   var ages = make(map[string]int)
   var names []string
   //var names = make([]string, 0, len(ages))
   
   for name := range ages {
       names = append(names, name)
   }
   sort.Strings(name)
   for _, name := range names {
       fmt.Println(ages[name])
   }
   
   // 利用 map 实现 set
   var set = make(map[string]bool)
   var word []string
   
   for _, str := range word {
       if !set[str] {
           set[str] = true
       }
   }
   ```

   

4. 下面是利用二叉树实现插入排序，原理是二叉搜索树的中序遍历。空结构体不包含任何成员，唯一的作用可能就是作为map的value，但很少使用。如果要在函数内修改结构体参数的成员变量，必需要以指针的形式传入，因为Go都是值传递。

   ```go
   type TreeNode struct {
       val int
       left, right *TreeNode
   }
   
   func InsertSort(values []int) {
       var root *TreeNode
       for _, val := range values {
           root = Add(root, val)
       }
       AppendValue(values[:0], root)
   }
   
   func AppendValue(values []int, root *TreeNode) {
       if root != nil {
           AppendValue(values, root.left)
           values = append(values, root.val)
           AppendValue(values, root.right)
       }
   }
   
   func Add(root *TreeNode, val int) *TreeNode {
       if root == nil {
           root = new(TreeNode)
           root.val = val
           return root
       }
       if (val < root.val) {
           Add(root.left, val)
       } else {
           Add(root.right, val)
       }
       return root
   }
   ```

   

5. **当一个 channel 被关闭后，再向该 channel 发送数据会导致一个 panic，当所有数据都被接收后，再从 channel 接受数据不会阻塞，而是立即返回一个零值**。测试一个 channel 是否关闭，可以多接受一个值，如下：

   ```go
   go func() {
       for {
           // 用来检测channel是否关闭
           x, ok := <- naturals
           if !ok {
               break
           }
           squares <- x*x
       }  
       close(squares)
       
       // 上述形式可用range代替，当channel关闭并无值接收时，跳出循环
       for x := range naturals {
           squares <- x*x
       }
   }()
   ```

   因为关闭操作只是断言不再向channel中发送数据，所以试图 close 一个只用于接受的 channel 将会报编译错误。当使用无缓冲的 channel 在多个 goroutine 中插入数据，而只接受了部分数据，就会导致一部分的goroutine 被永远阻塞，这被称为 goroutine 泄漏。注意 wg.Add(1) 是在启动 goroutine 之前调用而不是在 goroutine 中，因为后者无法保证 wg.Wait() 会不会先执行，减1一般用 ```defer wg.Done()```

6. select 执行了一个case就会退出，不会循环等待，只有空select{}会无限等待下去。并发的退出可以考虑用一个全局的无缓冲channel，根据可否从channel中拿到数据去判断是否退出，前提是将其放在select中

   ```go
   var done = make(struct{})
   
   func cancel() bool {
       select {
           case <-done:
           return true
           default:
           return false
       }
   }
   ```

   

7. 像map，channel 这种类型，为 nil 时无法进行任何操作，**对一个为nil的 channel 进行发送和接受操作将会永远阻塞**，在select中的case永远不会被选择到，而map则是发生panic，因此一般要先用make创建

8. make 与 new 的区别是：make只用于 slice, map, channel 这三个引用类型的创建，而 new 为一个类型分配内存，并返回指向这个类型的指针

   ```go
   func main() {
       var i *int
       *i = 10 // panic
       i = new(int)
       *i = 10 // correct
   }
   ```

9. defer 后进先出，panic 等待 defer 处理完后才会向上传递，如果 defer 某个函数的参数里有函数的话，会先顺序执行那个函数

10. foreach 和 Java 一样，都是使用副本

    ```go
    type student struct {
        Name string
        Age  int
    }
    
    func main() {
        m := make(map[string]*student)
        stus := []student{
            {Name: "zhao1", Age: 12},
            {Name: "zhao2", Age: 13},
            {Name: "zhao3", Age: 14},
    	}
        // Wrong 之后保存最后一个stu
        for _, stu := range stus {
            m[stu.Name] = &stu
        }
        // correct
        for i := 0; i < len(stus); i ++ {
            m[stu[i].Name] = &stu[i]
        }
    }
    ```

11. make初始化是有默认值的，如下：

    ```go
    s := make([]int, 5)
    s = append(s, 1, 2, 3)
    fmt.Println(s) // 0,0,0,0,0,1,2,3
    ```

12. golang 的方法集仅仅影响接口实现和方法表达式转换，与通过实例或者指针调用方法无关

    ```go
    type People interface {
        Speak(string) string
    }
    type Student struct{}
    func (stu *Student) Speak(think string) (talk string) {
        if think == "bitch" {
            talk = "You are a good boy"
        } else {
            talk = "hi"
        }
        return
    }
    func main() {
        var peo People = Student{} // compile error
        // *Student 实现了People接口，而Student没有
        think := "bitch"
        fmt.Println(peo.Speak(think))
    }
    ```

13. 接口的内部结构，注意空接口和data域为nil的接口的区别，如果后者实现了某个方法，会多一个itab结构，存储type信息还有结构体实现方法的集合

14. **注意type只能直接用在interface上，并且只用在switch**

    ```go
    func MyPrintf(args ...interface{}) {  
        for _, arg := range args {  
            switch arg.(type) {  
                case int:  
                    fmt.Println(arg, "is an int value.")  
                case string:  
                    fmt.Println(arg, "is a string value.")  
                case int64:  
                    fmt.Println(arg, "is an int64 value.")  
                default:  
                    fmt.Println(arg, "is an unknown type.")  
            }  
        }  
    }  
    ```

    args 参数改为其它类型会编译报错

15. 在函数有多个返回值时，只要有一个返回值有指定命名，其它的也必须有命名

16. defer 在函数结束前执行。函数返回值名字会在函数起始处被初始化为对应零值并且作用域为整个函数

    ```go
    func main() {
        fmt.Println(DeferFunc1(1))  // 4
        fmt.Println(DeferFunc2(1))  // 1
        // 会将t的值和返回值加起来
        fmt.Println(DeferFunc3(1))  // 3
    }
    
    func DeferFunc1(i int) (t int) {
        t = i
        defer func() {
          t += 3  
        }()
        return t
    }
    func DeferFunc2(i int) int {
        t := i
        defer func() {
          t += 3  
        }()
        return t
    }
    func DeferFunc3(i int) (t int) {
        defer func() {
            t += i
        }()
        return 2
    }
    ```

17. 不能用new创建切片，new出来的是 *[]int，无法直接使用 append

18. 将切片作为参数传入append时，别忘了在末尾加 ...

19. 只有相同类型结构体才可以比较，**结构体是否相同不但与属性类型个数有关，还与属性顺序相关**，如果结构体中有不可比较类型，会编译报错。像结构体这种聚合类型不能包含自身，但可以包含自身的指针类型

20. string 不能被赋值为 nil

21. iota

    ```go
    const (
        x = iota
        y
        z = "zz"
        k
       	p = iota
    )
    func main() {
        fmt.Println(x,y,z,k,p) // 0 1 zz zz 4
    }
    ```

22. := 只能在函数内部使用

23. **无法获取常量的地址，因为常量会被编译器在预处理阶段直接展开，作为指令数据使用**，因此无法为常量赋值

24. alias，为一个类型创建一个别名，保留源类型的方法，字段，本质上是一样的

    ```go
    func main() {
        var Myint1 int
        var Myint2 = int
        var i int = 9
        var i1 Myint1 = i // compile error, 需要强制类型转换
        var i2 Myint2 = i // correct
    }
    ```

25. 闭包延迟求值

    ```go
    func test() []func() {
        var funs []func()
        for i := 0; i < 2; i ++ {
            funs = append(funs, func() {
                println(&i, i)
            })
        }
        return funs
    }
    func main() {
        funs := test()
        for _, f := range funs {
            f()  // 输出结果都一样，i值为2
        }
    }
    
    // 可以把循环改为
    for i := 0; i < 2; i ++ {
        x := i
        funs = append(funs, func() {
            println(&x, x)
        })
    }
    ```

26. 