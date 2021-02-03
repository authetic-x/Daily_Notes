## 实现一个限制并发请求的类

```js
// requestLimit.js
class RequestLimit {
	constructor(limit) {
		this.limit = Number(limit) || 5;
		this.currentReq = 0;
		this.queue = [];
	}

	async request(req) {
		if (Object.prototype.toString.call(req) 
        !== '[object Function]') {
			throw new Error('The parameter req must be a function.');
		}

		if (this.currentReq >= this.limit) {
			await new Promise(resolve => this.queue(resolve));
		}
		return this._handleRequest(req);
	}

	async	_handleRequest(req) {
		this.currentReq++;
		try {
			return await req()
		} catch (e) {
			return Promise.reject(e);
		} finally {
			this.currentReq--;
			if (this.queue.length) {
				const resolve = this.queue.unshift();
				resolve();
			}
		}
	}
}
```

