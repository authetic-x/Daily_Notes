## bind

```js
// MDN -- BIND
if (!Function.prototype.bind) {
    Function.prototype.bind = function(oThis) {
        if (typeof this !== 'function') {
            throw new TypeError(
                "Function.prototype.bind - what is trying " + 
                "to be bound is not callable"
            )
        }

        var args = Array.prototype.slice.call(arguments, 1),
            fToBind = this,
            fNOP = function(){},
            fBound = function() {
                return fToBind.apply(
                    (
                        // 这里是为了new操作有this的优先级
                        this instanceof fNOP && oThis
                        ? this : oThis
                    ),
                    args.concat(Array.prototype.slice.call(arguments))
                )
            }
        
        fNOP.prototype = this.prototype
        // new创建的对象__proto__属性会指向fBound的原型
        fBound.prototype = new fNOP()
        
        return fBound
    }
}
```



## new

> this 绑定的优先级：
>
> `new > 显示绑定 > 上下文绑定 > 默认绑定`

```js
// new操作符的四步操作
1. 创建一个全新的对象
2. 设置新对象的__proto__属性为构造函数([[原型]]连接)
3. 将新对象绑定到函数调用的this
4. 若函数没有返回其它对象，new表达式中的函数会自动返回这个新对象
function New(fn) {
   var obj = Object.create(fn.prototype)
   fn.apply(obj, Array.prototype.slice.call(arguments, 1))
   return obj
}
```



## 防抖

一定在事件触发n秒后再执行

```js
function debounce(func, wait, immediate) {
    let timeout, result
    const debounced = function() {
        // 解决this指向和event参数的问题
        const context = this
        const args = arguments
        
        if (timeout) clearTimeout(timeout)
        if (immediate) {
            const callNow = !timeout
            timeout = setTimeout(() => {
                timeout = null
            }, wait)
            if (callNow) result = func.apply(context, args)
        } else {
            timeout = setTimeout(() => {
                func.apply(context, args)
            }, wait)
        }

        return result
    }

    debounced.cancel = function() {
        clearTimeout(timeout)
        timeout = null
    }

    return debounced
}
```

