[toc]

## hooks 相关

### componentDidMount() 和 useEffect(fn, []) 有什么不同？

#### 1. 执行时机

componentDidMount() 和 useEffect(fn, []) 都是在组件挂载之后执行。不同的是 componentDidMount() 会同步阻塞将 render 的返回值渲染到浏览器上，而 useEffect(fn, []) 不会阻塞 DOM 的渲染，它是类似于 requestIdleCallback() 的运行机制，在浏览器空闲时异步执行的。因此，在 

useEffect(fn, []) 里执行修改状态可能会导致页面发生闪烁，而 componentDidMount() 不会。useLayoutEffect() 在执行时机上更接近 componentDidMount()

#### 2. Props 和 State 的捕获

使用 useEffect() 不小心的话很容易出现“闭包问题”

```react
class App extends React.Component {
  state = {
    count: 0
  };

  componentDidMount() {
    longResolve().then(() => {
      alert(this.state.count);
    });
  }

  render() {
    return (
      <div>
        <button
          onClick={() => {
            this.setState(state => ({ count: state.count + 1 }));
          }}
        >
          Count: {this.state.count}
        </button>
      </div>
    );
  }
}
```

如果按照 hooks 来改写的话是这样的：

```js
function App() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    longResolve().then(() => {
      alert(count);
    });
  }, []);

  return (
    <div>
      <button
        onClick={() => {
          setCount(count + 1);
        }}
      >
        Count: {count}
      </button>
    </div>
  );
}
```

如果你在 longResolve 之前多次点击按钮，那么实际上 alert 的 count 仍旧是0。那么这个问题怎么解决呢？可以用 useRef() 每次保存最新的值

```react
function App() {
  const [count, setCount] = useState(0);
  const countRef = useRef()
  countRef.current = count

  useEffect(() => {
    longResolve().then(() => {
      alert(countRef.current);
    });
  }, []);

  return (
    <div>
      <button
        onClick={() => {
          setCount(count + 1);
        }}
      >
        Count: {count}
      </button>
    </div>
  );
}
```

## React 生命周期

### 挂载阶段

- `constructor`

- `getDerivedStateFromProps`

  新的 `getDerivedStateFromProps` 是一个静态函数，所以不能在这函数里使用 `this`。

  该函数会在挂载时，在更新时接收到新的 `props`，调用了 `setState` 和 `forceUpdate` 时被调用，返回一个对象用来更新当前的 `state`，如果不需要更新可以返回 `null`。

- `UNSAVE_componentWillMount`

- `render`

- (React Updates DOM and refs)

- `componentDidMount`

### 更新阶段

- `UNSAFE_componentWillReceiveProps`

- `getDerivedStateFromProps`

- `shouldComponentUpdate`

- `UNSAFE_componentWillUpdate`

- `render`

- `getSnapshotBeforeUpdate`

  `getSnapshotBeforeUpdate` 生命周期方法在 `render` 之后，在更新之前（如：更新 DOM 之前）被调用。给了一个机会去获取 DOM 信息，计算得到并返回一个 `snapshot`，这个 `snapshot` 会作为 `componentDidUpdate` 的第三个参数传入。如果你不想要返回值，请返回 `null`，不写的话控制台会有警告。

  并且，这个方法一定要和 `componentDidUpdate` 一起使用，否则控制台也会有警告。`getSnapshotBeforeUpdate` 与 `componentDidUpdate` 一起，这个新的生命周期涵盖过时的 `UNSAFE_componentWillUpdate` 的所有用例。

- (React Updates DOM and refs)

- `componentDidUpdate`

### 卸载阶段

* `componentWillUnMount`



## Context 所引发的组件重新渲染问题



## react-redux connect 原理



## React Fiber



