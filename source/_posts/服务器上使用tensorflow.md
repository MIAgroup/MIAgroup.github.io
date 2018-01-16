---
title: 服务器上使用tensorflow
date: 2018-01-16 13:37:53
tags: [this_site, lincolnzjx]
---



## 使用tensorflow各组件之间的依赖关系

简单来说，按照下图指引，从左到右是依赖关系。

$tensorflow\_gpu \rightarrow	cudnn \rightarrow cuda$

因为实验室的cudnn主要是5.1, 6以及cuda版本主要8.0，所以下载的tensorflow版本要与之相适应才能使用。



## 实验室服务器使用tensorflow概况

### pip安装包的网速比较慢

**解决方案**：添加参数**--default-timeout=100** ，如下，用处是延长下载等待时间

```
pip install --default-timeout=100 xxx
```

### 查看cuda版本

```bash
cat /usr/local/cuda/version.txt
```

### 查看cudnn版本

```bash
cat /usr/local/cuda/include/cudnn.h | grep CUDNN_MAJOR -A 2
```



### 面对cudnn版本不匹配的解决方案（举个粟子）

* 问题核心：cudnn版本是5.1，不能使用tensorflow 1.4.0
* 问题约束：cudnn和cuda版本无法修改
* 解决思路：使用低版本的tensorflow



