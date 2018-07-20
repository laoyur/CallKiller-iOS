# 截图
![](https://laoyur.com/dl/ios/callkiller/photo_2018-07-20_18-42-00.jpg)
![](https://laoyur.com/dl/ios/callkiller/photo_2018-07-20_18-42-09.jpg)
![](https://laoyur.com/dl/ios/callkiller/photo_2018-07-20_18-42-14.jpg)
![](https://laoyur.com/dl/ios/callkiller/photo_2018-07-20_18-42-18.jpg)


# changes in 1.1.0
  * 终于有GUI设置界面了
  * 应该可以拦截未知号码（需进一步测试）
  * 可以选择是否放行联系人
  * 支持按区号拦截
  * 支持自定义号码黑名单，支持通配符（ * 和 ? ）
  * 支持自定义拦截关键词（跟1.0.0版一样，需要自行安装助手类App来写入标签数据库）
  * **接受捐赠**。我曾在v2ex上说过不需要捐赠，后来想了想，既然有GUI了，为啥不做一个功能进去呢

# 如何安装
  * 你可以稍等一两天，已经跟BigBoss沟通过，他们表示1.1.0版可以接受（1.0.0被他们拒绝了）
  * 直接从Release页面下载编译好的deb
  * 下载代码自己编译

# 如何编译
  * 下载安装MonkeyDev
  * 下载安装Theos
  * 机器上装好`ldid`、`dpkg-deb`，推荐用Homebrew安装
  * 打开xcodeproj，配置证书
  * 打开终端，cd到项目根目录，执行 `sh generate_deb.sh`，deb包会生成在项目根目录
  * `sh deploy.sh DEVICE_IP`，可以快速把deb scp到手机上安装
