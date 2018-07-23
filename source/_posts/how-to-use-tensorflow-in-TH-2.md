---
title: 怎样在使用天河二号运行深度学习框架 
date: 2018-02-01 14:42:13
tags: [labinfo, cuizhiying]
---

分享一下我个人在Ubuntu操作系统上登录和使用超算中心的一些经验和总结. 这些内容在大群里面的超算中心的使用说明都有提到, 但是里面的内容因为要涉及到多个不同的操作系统, 所以信息量比较大, 我刚开始看的时候是找不到北的. 如果你想尝试一些超算中心飞一般的速度, 希望以下内容可以给你带来一点参考.
## 概述
优点:
1. 天河二号一个运算节点有四张K80显卡, 现存11439MiB/GPU, 一个任务最多可同时使用10个节点, 速度贼快
2. 可远程登录, 回家也能跑代码, 妈妈再也不用担心我的学习 :)
3. Tensorflow, Caffe框架都有现成的几个版本, 环境配置简单

缺点:
1. 登录很麻烦(这个博客主要是为了分享这个麻烦的登录经历)
2. VPN有时候不稳定, 感觉有点容易断线
3. 自定义的配置环境有点困难, 目前还没有尝试可行的方法.
4. 实验室大群里的教程有点杂乱

这篇博客会在不断使用和积累的过程中不断更新.

## 整体的使用流程
不管您是在使用什么操作系统平台(Ubuntu, Windows, Mac等等), 总的流程都是一样的以下方式依次执行.
1. 使用VPN账号和密码连接登录超算中心的VPN
2. 使用超算中心的账号和私钥文件登录超算中心的操作系统(Centos)
3. 在加载需要的运算框架环境变量
4. 在指定的目录下(/BIGDATA)提交自己的作业(也就是执行代码)

以下为详细内容(以在Ubuntu中配置为例子)
为了方大家的理解, 我将群里文件夹中能够拿到的账号的账号密码信息罗列如下(注意,要使用群里的账号密码, 以下敏感信息都已经用\*打码了, 自己对着<超算资源使用简单说明.docx>这个文件一一对应上去):

|                 题目 |答案                       | 备注                |
| :-----------         | :---------                | :---                |
| IPSec gateway address| 10.88.16.100              | 有校内IP和校外IP之分|
| IPSec ID             | hi\*\*\*ne                 | \*是隐藏内容        |
| IPSec secret         | gz\*\*\*23                | \*是隐藏内容        |
| VPN账号              | sy\*\*\*\_1               | 同上                |
| VPN密码              | Hp\*\*\*86                  | 同上                |
| 超算中心的账号       | sy\*\*\*\_2               | 同上                |
| 超算中心的密码       |  是一个秘钥文件(`***.id`) | 在私钥这个文件夹里  |

没错, 登录一下超算中心就是需要那么多的账号和密码, 说很简单估计你也不会信的了.但其实只是配置复杂一点点, 使用起来还是很方便的了.

## 登录VPN
在Ubuntu下要使用`vpnc`工具来登录超算的VPN账号.
### 安装`vpnc`
在命令行下安装`vpnc`的图形化工具
```bash
sudo apt-get install network-manager-vpnc-gnome
```
安装完毕之后,先重启一下自己的Ubuntu, 我们就可以在Ubuntu桌面的右上的网络链接中的配置我们的VPN了. 不重启电脑的话, 在下一步的登录VPN的选项中可能会看不到新安装的`vpnc`的连接方式.
### 登录VPN
在Ubuntu 16.04及16.04之前的操作系统版本, 可以参考这篇超赞的图文教程[**_点击这里_**](https://superuser.com/questions/739309/ubuntu-cisco-vpnc-client-for-my-new-ubuntu-version-32-bit), 17.10之后的Ubuntu版本也差不多, 点击右上脚的`网络`, 然后点击 `vpn off`, 然后点击`vpn setting`即可以看到相类似的配置界面.不复截图.
在配置过程中, `Gateway`选项对应的是上表中的第一个IP地址, 这里面有校内和校外之分,其中, `10.88.16.100`这个地址是校内校外都可以使用, `222.200.179.12`和`222.200.179.9`这个地址呢就只能在校园网中使用. 建议在校内使用的时候还是使用后两者吧, 应该会稳定一点.
`User name`选项和`user password`选项对应着上表中的VPN账号和密码, `Group name`和`Group password`可对应着上面的IPSec ID 和 secret, 设置好保存起来就行. 
当我们需要登录的超算中心之前, 同样是点开刚刚设置vpn的那个按钮, 然后点击我们刚刚设置的vpn的名称, 链接. 然后就可以了.
链接好了vpn之后我们就不能再正常使用外网了, 啥都登录不上了. 有一个方法可以将这些流量区分开来的, 但是我还没有开始折腾, 先这样子将就着吧.
## 使用ssh登录超算中心
有了VPN我们只是修好了通往超算中心的路而已, 要想进去使用还得用超算中心的账号和密码来打开超算中心的大门. 目前超算中心只支持ssh协议登录.
首先, 我们先把与账号名`sy***_2`相对应的`sy***_2.id`那个一秘钥文件复制到一个相对固定的目录中, 如`/home/username/.ssh/`的路径下
```bash
cp sy***_2.id ~/.ssh/
```
注意, 这只是一个例子, 上面的命令直接执行的话肯定要报错的, 要把文件名和文件的路径对应的修改过来.
然后在终端中使用`ssh`命令登录超算中心.
```bash
ssh -i ~/.ssh/sy***_2.id sy**_2@172.16.22.41
```
简单地分析一下这一条登录命令, -i 后面跟着的是秘钥登录所使用的秘钥文件, `sy**_2@172.16.22.41`中`@`前面部分表示的是我们要登录的IP地址.
那么长的一挑命令, 我是不愿意每次登录的时候都要背或者查那一串毫无意思的IP得知的. 所以我们可以通过配置ssh的配置文件来简化我们输入.
我们输入
```bash
gedit ~/.ssh/config
```
命令, 来编辑这个配置文件(一般如果你是第一次编辑这个文件, 他很可能是一个空白的文件)
往配置文件中添加一下内容.
```
Host cs
    HostName 172.16.22.41
    User     sy***_2
    IdentityFile ~/.ssh/sy***_2.id

```
其中`Host cs`中的`cs`是根据自己的意愿起的名字, 我在这里起名为cs是超算的拼音首字母的意思.
做完以上所有的配置, 以后登录的时候就方便了, 点一下桌面右上角的链接VPN, 然后打开终端输入
``` bash
ssh cs
```
然后我们就愉快的登录上超算中心了.
## 在超算中心上传和下载文件
使用sftp协议, 其登录方法和ssh协议一毛一样. 要注意的是我们所有的运行文件和运行时要用到的数据都要放到~/BIGDATA路径中去.
``` bash
sftp cs
```
然后就可以使用常江的`push`, `get`命令来上传和下载文件了,sftp的从入门到精通的教程可以点击[这里](https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server)
## 运行程序
好了, 这里的运行程序和我们在本机运行环境还是有很大不同的, 在这里, 刚刚登录的时候, 会发现这里啥也没有装, 也不能在本机上直接运行程序. 这时候, 我们就可以看一下系统给我们与装好的模块了
```bash
module avail
```
我们可以看到系统中已经装好了pytorch caffe 和tensorflow的各种版本, 好吧,还没有tensorflow的1.4和最新的1.5版, 假如我要运行一个Tensorflow的代码, 我们就直接运行
```bash
module load TensorFlow/1.3-gpu-py3.6
```
`load`后面的参数要严格按照那个`avail`列出的命令来执行.
输入这条命令之后, 你会惊奇的发现啥也没有发生. 恩! 这很好! 这涉及到Unix的一条哲学问题: 没有消息就是最好的消息! 说明命令运行成功了, 模块成功的加载进来了.
然后我们执行我的代码脚本(test.py):
```bash
yhrun -p gpu -n 1 -t 1 python3.6 test.py
```
而不能直接执行
```bash
python3.6
```
因为这就相当于在我们的中转服务上直接跑代码一样, 会把中转服务器的资源全部占用,然后其他的就卡爆了. 而上面的`yhrun`呢则将自己的代码提交给强大的天河去处理和运算了.上面的具体的参数的含义, 可以详细参考一下群里的文件.