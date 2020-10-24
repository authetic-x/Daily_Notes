任何包含顶级 `import` 或者 `export` 的文件都被当成一个模块。相反地，如果一个文件不带有顶级的 `import` 或者 `export` 声明，那么它的内容被视为全局可见。 -- 有待商讨

TS 中基本的模块导入导出方式和 `ESModule` 并无太大差别。同时 TS 也支持 `CommonJS` 和 `AMD` 的 `export = ` 语法，使用 `export = ` 语法导出的模块必须使用 `import module = require('module')` 的语法来导入此模块。

根据编译时指定的模块目标参数，编译器会生成相应的供Node.js ([CommonJS](http://wiki.commonjs.org/wiki/CommonJS))，Require.js ([AMD](https://github.com/amdjs/amdjs-api/wiki/AMD))，[UMD](https://github.com/umdjs/umd)，[SystemJS](https://github.com/systemjs/systemjs)或[ECMAScript 2015 native modules](http://www.ecma-international.org/ecma-262/6.0/#sec-modules) (ES6)模块加载系统使用的代码。

`d.ts` 文件作用是为非 TS 编写的类库添加类型。

命名空间也被称为内部模块

