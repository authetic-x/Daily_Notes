## 用户认证

基于 `Flask-Login`



## 权限管理

### 表结构：

* Role
* Permission

设置一个 `permission_required` 装饰器可实现某些路由的权限访问，`User` 类也有一个 can 方法可判断用户有哪些权限



## 图片文件上传

`Flask-dropzone`



## 用户主页



## 图片展示



## 收藏图片

定义了一个 `Collect` 表，用来表示收藏关系，有两个关键字段 `collector, collected` 表示收藏者和被收藏的图片



## 用户关注

关注和收藏一样的，也建立一个 `Follow` 中间表，用来表示关注关系，有两个字段 `follower和followed` 表示关注者和被关注者



## 消息提醒

轮询实现实时更新未读计数，时间间隔为30秒



## 用户设置



## 全局搜索

`Flask-Whooshee`







