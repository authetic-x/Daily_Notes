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



## 02-02

webpack 是一个模块打包工具。

我们进行模块化开发时，往往会在一个 js 文件中引入多个 js 模块，然而浏览器中不支持类似 `ES6 import` 的模块引入机制。所以需要用 webpack 这类打包工具将这个 js 文件整合一下，这样即解决的引入问题，也提升了一些性能。

`npx webpack index.js` 或配置默认的 `webpack.config.js` 文件，`npx webpack`。注意：`webpack-cli` 用来在 `bash` 中使用 `webpack` 命令，`npx` 是指在当前目录的 `node_modules` 中寻找可执行文件。还可以配置 npm 中的 `scripts`，`npm run bundle `



## 02-03

Loader 用来配置怎么打包各种类型的文件。因为 webpack 默认只认识 js 文件，要打包其它的如：图片，`css/sass`，字体文件，就要去详细的配置。

今天学到的 loader 和安装的一些模块有：

* style-loader
* css-loader
* file-loader
* url-loader
* sass-loader
* node-sass
* autoprefixer

内容比较多，但本质就是指定文件以怎样的方式放到哪个文件夹里，详细内容查阅官方文档



## 02-04

### plugin

可在 webpack 运行到某个时刻帮我们做一些事情，类似于生命周期函数的功能。比如：`html-webpack-plugin` 自动帮我们在打包目录下生成 html，也会在 html 文件中自动引入打包后的 js 文件；`clean-webpack-plugin` 可以帮助我们在打包前清空打包目录。

设置 output 下的 publicPath 属性可以让 html 引入文件时加上一些前缀，filename 也可以用 `[name].js` 占位符的形式指定

### sourcemap

作用是提供打包文件与源文件之间的映射关系。这可以让我们快速定位报错的源文件。默认会生成 `main.js.map` 类似的映射源文件，可设置 `devtool: inline-source-map` 将其变为 base64 内嵌在打包的 js 文件里，还有一些关于性能的配置可详见官方文档。最佳实践是：开发时用 `devtool: cheap-module-eval-source-map`，项目上线时用 `devtool: cheap-module-source-map`。

### devServer

`webpack --watch` 可实时更新。`webpack-dev-server` 模块主要是提供了一个服务器，用 devServer 属性配置。类似于 create-react-app 开发时打开 `localhost:3000` 网址底层就是用这个配置的。可以详细配置端口，proxy 跨域代理等。还可以手动用 node 开发一个简单的服务器，内部引入 webpack 的配置，然后用一些中间件模块配置一下即可。打包不会生成打包目录，直接放在内存里提升打包速度。



## 02-05

### 热模块更新 (HMR)

使用 devServer 时，当我们的文件发生改变，它会自动重新打包，并且刷新页面。如果我们不想重新载入页面，只加载更新的模块，就可以配置热模块更新。

实现 js 的热模块更新需要额外编写一些代码，css 不用写是因为 css-loader 已经帮忙配置了。详见 webpack 文档

### 使用 Babel 处理 ES6 代码

babel 有很多细节，开小差了。先记住 Babel 作用，后面再说。



## 02-06

### Tree Shaking

当引入一个模块时，只打包这个模块里我们需要的代码。只支持 `ES Module` 引入模式 (import, export)。production 模式自动支持。

### 开发配置和生产配置文件分离

可新建一个 `webpack-common.js` 文件，里面存放开发环境和生产环境公共的一些配置代码，然后在两个文件里分别用 `webpack-merge` 合并一下

### Code Splitting

打包逻辑拆分，提升打包速度。说白了，就是引入一些工具模块比如 `lodash`，每次稍微改动一下业务代码都要一起重新打包太浪费性能了。我们需要把它们打包为两个文件，以后业务代码修改就不会再一起打包那些工具模块了。无论是同步导入模块还是异步导入模块，我们都可以通过配置 `optimization 里的 splitChunks` 去自动帮我们进行代码拆分，也就是打包为两个或多个 js 文件。

1. entry 手动分开打包
2. 配置 optimization 属性



## 02-08

### Lazy loading

在我们需要时才载入某些代码，提高页面载入速度。比如交互逻辑的代码，我们的最终目的是提高页面第一次加载的速度。可以使用动态 `import` 导入代码的方式 (返回一个 Promise)

### Bundle Analysis

`webpack --profile --json > stat.json` 生成打包分析文件

### Prefetching/Preloading Modules

对于一些交互逻辑或者说加载首页不需要的代码，我们不第一时间进行加载，而是在首页加载完成后，网络代码释放出来时，去偷偷的加载这部分代码。这样即可以提升首页载入速度，又可以解决懒加载在点击这部分逻辑响应过慢的问题。



## 02-10

### CSS Code Splitting

详见官方文档

### 浏览器 Cache 问题

将 `filename` 改为 `[name].[hash].js`

### Shimming

模块打包相互独立，使用 `ProvidePlugin()` 插件。

### imports-loader 插件



## 02-11

### Library 打包

配置可引入 library 的方式，还可以设置 `externals` 配置项，详见官方文档

### 将项目打包为 PWA 应用

引入 `WorkboxPlugin` 插件，详见官方文档

### TypeScript 打包

使用 `ts-loader`，需额外创建 `tsconfig.js` 文件，详见官方文档

### webpackDevServer 实现接口转发

在 `devServer` 配置项下配置 `proxy`，详见官方文档

### webpackDevServer 解决单页面应用路由问题

设置 `devServer` 的 `historyApiFallback` 属性为 true



烂尾了！！！