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



