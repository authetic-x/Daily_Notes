[toc]



## Code Splitting

Code Splitting 可以将本来被打包为一个文件的 `bundle.js` 拆分为多个文件，可用来优化首屏加载时间

有三种方式可以进行 Code Splitting:

1. 配置 `entry` 选项，显示拆分打包，缺点是不够灵活，不同 chunk 中引入相同模块该模块会被重复打包
2. splitChunkPlugin
3. 动态加载 (Dynamic imports)，使用 `import()` 方法。另外可以通过配置 output 中的 `chunkFileName` 选项来指定 chunk 的名称



## Prefetching/Preloading modules

* prefetch: resource is probably needed for some navigation in the future
* preload: resource might be needed during the current navigation



## Cache

可以指定 output.filename 选项 `[name].[contenthash].js` 来为 chunk 添加 hash。

webpack provides an optimization feature to split **runtime code** into a separate chunk using the [`optimization.runtimeChunk`](https://webpack.js.org/configuration/optimization/#optimizationruntimechunk) option. 没弄懂什么叫 runtime code.

查了一下，runtime 部分的代码主要包含在模块交互时，连接模块所需的加载和解析的逻辑；而与之相关的一般还有 manifetst，当 compiler 开始执行、解析和映射应用程序时，它会保留所有模块的详细要点。也就是说，runtime 和 manifest 的代码主要是用来管理所有模块的交互。



Extract third-party libraries, such as `lodash` or `react`, to a separate `vendor` chunk as they are less likely to change than our local source code.

```js
optimization: {
  runtimeChunk: 'single',
  splitChunks: {
    cacheGroups: {
      vendor: {
        test: /[\\/]node_modules[\\/]/,
       	name: 'vendors',
        chunks: 'all'
      }
    }
  }
}
```



## Authoring Libraries

这一节主要是讲如何用 webpack 打包一个 JS 库，如何配置库的导出方式，即如何在不同的环境中使用这个库。

常规配置方式大同小异，记录几个陌生点：

### 1. externals

配置这个选项可以让库中引用的第三方库不被一起打包进最终的代码，也就是说用户要使用你写的这个库就必须事先安装了这些第三方库

### 2. output.library/output.libraryTarget

只配置 library 可以让你的库在全局环境下暴露出来，配置 libraryTarget 则可以适配不同的环境，如： 

1. var: <script> tag
2. this
3. window
4. umd: AMD or CommonJS

最后别忘了在 `package.json` 配置一下 main 选项，一般为打包后文件所在位置



## Environment Variables

`webpack --env.NODE_ENV=local --env.production` 可以创建环境变量，使用 webpack 的环境变量需要将导出对象改为函数模式

```js
module.exports = env => {
  console.log(env.NODE_ENV) // local
  console.log(env.production) // true
  
  return {
    entry: './src/index.js'
    // ...
  }
}
```

## HMR

热模块更新用在开发环境，不用重新打包就可以立即加载变更的代码。一般的使用方式十分简单，只需要在 devServer 选项下添加 `hot: true` 即可开启热更新。Node.js 下使用 HMR 略有不同，详情参考[文档](https://webpack.js.org/guides/hot-module-replacement/#via-the-nodejs-api)。

### Gotchas

HMR 会有一些陷阱，比如一个绑定了事件的按钮，仅修改事件处理函数点击按钮不会得到最新结果，你可能需要添加如下代码判断

```js
let element = component();
document.body.appendChild(element);

if (module.hot) {
  module.hot.accept('./print.js', function() {
    console.log('Accepting the updated printMe module!');
    printMe();
    document.body.removeChild(element);
    element = component();
    document.body.appendChild(element);
  })
}
```

好在有很多的 loader 可以帮我们做这些事情，比如：`React Hot Loader, Vue Loader`



## Tree Shaking

*Tree shaking* is a term commonly used in the JavaScript context for dead-code elimination.

使用 Tree Shaking 你需要：

1. Use ES2015 module syntax (import and export)
2. Ensure no compilers transform your ES2015 module syntax into CommonJS modules (this is the default behavior of the popular Babel preset @babel/preset-env - see the [documentation](https://babeljs.io/docs/en/babel-preset-env#modules) for more details).
3. Add a `"sideEffects"` property to your project's `package.json` file.
4. Use the [`production`](https://webpack.js.org/configuration/mode/#mode-production) `mode` configuration option to enable [various optimizations](https://webpack.js.org/configuration/mode/#usage) including minification and tree shaking



