# ACPackFramework

a Xcode plugin to pack iOS framework & bundle.
a Xcode plugin just by a coder without product ideas.

## 功能

- **支持打包framework和bundle文件**
- **自定义选择framework工程路径**
- **自定义选择framework工程产品输出路径**
- **自定义framework工程target**
- **自定义打包超时时间**

## 预览

**在这里选择插件**

![在这里选择插件](http://img.blog.csdn.net/20160125104441926)

**插件主界面**

![插件主界面](http://img.blog.csdn.net/20160125104301641)


## 插件失效

本插件支持Xcode7.2及以下版本
如果插件没有被Xcode加载，在命令行运行如下命令：

获取Xcode的UUID

```
defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID
```

将命令行输出添加到工程的info.plist的DVTPlugInCompatibilityUUIDs数组中，Build，重启Xcode。
