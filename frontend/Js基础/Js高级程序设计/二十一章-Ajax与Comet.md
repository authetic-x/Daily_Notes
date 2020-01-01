## XMLHttpRequest

```js
var xhr = new XMLHttpRequest();
xhr.onreadystatechange = function() {
    if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304) {
        alert(xhr.responseText);
    } else {
        alert("Request was unsuccessful: " + xhr.status);
    }
}

// false表示同步
xhr.open("get", "example.txt", false);
xhr.setRequestHeader("MyHeader", "MyValue");
xhr.send(null);

//传递表单数据
var form = document.getElementById("user-info");
var data = new FormData(form);
data.append("email", "----------");
xhr.send(data);

// 超时设定
xhr.timeout = 1000;
xhr.ontimeout = function() {
    alert("error!");
};

// 进度事件
xhr.onload = function() {
    if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304) {
        alert(xhr.responseText);
    } else {
        alert("Request was unsuccessful: " + xhr.status);
    }
};
xhr.onprogress = function(event) {
    var status = document.getElementById("status");
    if (event.lengthComputable) {
        status.innerHTML = "Received " + event.position + " of " +
                            event.totalSize + " bytes.";
    }
};
```

