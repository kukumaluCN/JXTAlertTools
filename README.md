# JXTAlertTools

详见：[iOS （封装）一句话调用系统的alertView和alertController](http://www.jianshu.com/p/056809125cbe)

UIAlertController是iOS8.0之后出来的新方法，其将系统原先的UIAlertView和UIActionSheet进行了规范整合。iOS9.0之后，UIAlertView和UIActionSheet已经不建议使用，但还未彻底废弃。
alert提示窗可以算得上是十分常用的UI控件了，基于上述情况，考虑到版本兼容，笔者将上述控件进行了简单的整合封装。
封装之后，只需一句话，便可调用系统的alert提示，至于是调用alertView还是alertController，会根据系统版本自行判断，做到了兼容适配。alert提示窗的回调方法，也基于block进行了封装。按钮数量提供了变参和数组两种封装模式，各有用途。

