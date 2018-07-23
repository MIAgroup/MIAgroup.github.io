---
title: 服务器上使用tensorflow
date: 2018-01-16 13:37:53
tags: [this_site, lincolnzjx]
---



## 使用tensorflow各组件之间的依赖关系

简单来说，按照下图指引，从左到右是依赖关系。

$tensorflow(GPU) \rightarrow cudnn \rightarrow cuda$ 

因为实验室的cudnn主要是5.1, 6以及cuda版本主要8.0，所以下载的tensorflow版本要与之相适应才能使用。



## 实验室服务器使用tensorflow概况

### pip安装包的网速比较慢

**解决方案**：换源

```
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package

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


```bash
# install python3.4 environment
conda create -n py34 python=3.4
conda update conda anaconda
# activate python3.4 environment
conda activate py34
# install tensorflow 1.2
pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.2.1-cp34-cp34m-linux_x86_64.whl
```

### 查看tensorflow版本对应的关于CUDNN和CUDA的要求

举个粟子，对于tensor flow 1.4的要求在下面这个[链接](https://www.tensorflow.org/versions/r1.2/install/install_linux#nvidia_requirements_to_run_tensorflow_with_gpu_support) 以此类推

### Cuda安装目录以及Cudnn安装目录

> /usr/local/cuda
>
> /usr/local/cuda/lib64

## 更新日志

* 2018.1.16 添加文章

### Reference

1. [tensorflow 对应的cudnn和cuda版本](https://www.tensorflow.org/install/install_sources#tested_source_configurations)
