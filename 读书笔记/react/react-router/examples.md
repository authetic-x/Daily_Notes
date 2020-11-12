## URL Parameters

```js
const { id } = useParams()
```

## Nesting

```js
// 你可以传入一个字符串path或者一个Route对象，返回匹配结果或者null
const { path, url } = useRouteMatch()
```

path 是相对于父组件，传入 `<Route path=''/>` 中的 path，而 `url` 指域名后的 相对 url

## Redirect(Auth)

### useContext()

```js
const authContext = createContext()

function useAuth() {
  return useContext(authContext)
}
```

### privateRoute

```js
function PrivateRoute({ children, ...rest }){
  <Route
  	{...rest}
  	render={({ location }) => 
			auth.user ? (
      	children
      ) : (
      	<Redirect 
        	to={{
        		pathname: '/login',
        		state: {from: location}
        	}}
        />
      )
		}
  />
}
```

