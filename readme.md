### 目录结构

- debug：使用OpenCore 0.6.3 debug包，体积稍大，保留啰嗦模式
- release：使用OpenCore 0.6.3 release包，体积小，去掉啰嗦模式
- tools：hackintosh的常用工具（以mac的为主）

### 黑苹果配置 

OpenCore版本： [0.6.3](https://github.com/acidanthera/OpenCorePkg/releases/tag/0.6.3) 

MacOS版本：big sur 11.0.1 （20B29）

- 配置参数

![big sur 11.0.1 （20B29）](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E9%85%8D%E7%BD%AE1.png)

- 主界面 

![big sur 11.0.1 （20B29）](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E9%85%8D%E7%BD%AE2.png)

- 核显

![big sur 11.0.1 （20B29）](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E9%85%8D%E7%BD%AE3.png)

- 蓝牙-wifi-以太网

![蓝牙-wifi-以太网](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E8%93%9D%E7%89%99-wifi-%E4%BB%A5%E5%A4%AA%E7%BD%91.png)
- 隔空投送

![隔空投送](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E9%9A%94%E7%A9%BA%E6%8A%95%E9%80%81.png)

- 接力

![接力](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E6%8E%A5%E5%8A%9B1.png)

![接力](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E6%8E%A5%E5%8A%9B2.png)

### 支持功能

- ✅ 蓝牙-wifi（BCM94360CD）
- ✅ 以太网（需手动设置） 
- ✅ 睡眠唤醒（鼠标唤醒）
- ✅ 核显加速
- ✅ 隔空投送 
- ✅ 接力
- ✅ App Store
- ✅ 所有USB
- ❓ 随航（未测试）
- ❓ 独显（未测试）

### GeekBench5跑分

- 综合
![综合](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/geekbench%E8%B7%91%E5%88%86.png)

- 单核
![单核](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E5%8D%95%E6%A0%B8%E6%8E%92%E5%90%8D.png)

- 多核
![多核](https://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E5%A4%9A%E6%A0%B8%E6%8E%92%E5%90%8D.png)



### 我的配置



| 配置             | 型号                                                         | 价格  | 购买渠道 |
| ---------------- | ------------------------------------------------------------ | ----- | -------- |
| CPU              | 英特尔 Intel i7 10700（9或10代cpu最好）                      | 2279  | JD自营   |
| 主板             | 微星 MSI MAG B460M MORTAR 迫击炮✅                            | 659   | JD自营   |
| 内存             | 2 x 16G 金士顿（Kingston）DDR4 3200 骇客神条 Fury雷电系列    | 899   | JD自营   |
| 显卡             | 核显（我的显示器是接核显的，独立显卡未测试）✅                | 0     | JD自营   |
| 显示器           | AOC Q2490W1 2k 60HZ                                          | 992   | JD自营   |
| 连接线           | 山泽 4kHDMI转HDMI（京东买了毕亚兹的DP转HDMI，会闪屏，注入UUID也无解） | 22    | JD自营   |
| 固态硬盘（m.2）  | 2 x Western Digital 西数 SN750 512G （靠近cpu的m.2接口与SATA1接口冲突，装了固态后，SATA1接口不可用） | 499x2 | JD自营   |
| 固态硬盘（SATA） | 英睿达（Crucial）MX500 500G                                  | 355   | JD自营   |
| 机型硬盘（SATA） | 东芝（TOSHIBA）64MB 7200RPM P300 3T                          | 433   | JD自营   |
| wifi+蓝牙        | BCM94360CD 1750M（Fenvi T919）✅                              | 250   | 淘宝     |
| 散热器           | 利民FS140                                                    | 209   | JD自营   |
| 电源             | 海韵（SEASONIC）FOCUS GX750 750W电源                         | 659   | JD自营   |
| 机箱             | 追风者 300 Air                                               | 219   | 淘宝     |
| 散热风扇         | ID-COOLING XF-12025-SD-K 无光 x 3                            | 16x3  | 京东     |

除显示器外，都是双十一前购买，加上一些优惠：6724元（不包括显示器）

**如果你满足以上3️⃣点，可以参考我的配置**



### 小白建议

我自己也算是个小白，先看了视频，再去看官方教程捣鼓，最后慢慢的修复问题

**如果不懂，建议先看上B站看一下视频，了解大致流程**

[【司波图】CometLake十代Intel平台台式机Opencore黑苹果通用配置教程（附安装包](https://www.bilibili.com/video/BV1uf4y1X7MT)

[Intel Coffee Lake平台完美黑苹果系统安装教程（Opencore+Catalina15.4）](https://www.bilibili.com/video/BV1hA411t7dr)



### 一、准备工作：

- [QCOpencoreConfig](https://github.com/ic005k/QtOpenCoreConfig)：配置文件plist编辑器（windows版）
- ProperTree：配置文件plist编辑器（windows版和mac都可以）
- [https://mackie100projects.altervista.org/download/opencore-configurator-2-15-2-0/)：配置文件plist编辑器（mac版）
- [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)：生成三码（主板号、序列号、UUID）
- [GibMacOS](https://github.com/corpnewt/gibMacOS) ：下载系统镜像
- [MountEFI](https://github.com/corpnewt/MountEFI)：挂着磁盘EFI工具，也可以使用OpenConfigurator自带的方式挂着
- 8G U盘
- [安装python环境](https://www.python.org/downloads/release/python-390/)：有了的话忽略

### 二、制作启动U盘

[官方教程](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/)【需科学上网】



### 三、享用（修改配置参数）

下载后先使用debug版本的（有啰嗦模式），稳定后在换release版本的（体积小，关闭啰嗦模式）

将debug版本的EFI文件夹负责出来到桌面（任意位置）

1. 用GenSMBIOS生成三码，建议机型  iMac19,1

2. 查看自己电脑的mac地址

3. Opencore Configurator打开 EFI/OC/config.plist 文件

选择【PlatformInfo-机型平台设置】-DataHub -Generic - PlatformNVRAM

| 选项                 | 填入值           |
| -------------------- | ---------------- |
| System Serial Number | 序列号           |
| System UUID          | UUID             |
| MLB                  | 主板号           |
| ROM                  | MAC地址，不要:号 |

更改后记得保存！！

4. 使用磁盘挂载工具挂载启动U盘的EFI，将修改好的EFI文件夹复制到U盘的EFI分区中，如果分区本来就有EFI就先删除。

5. 属于你的启动U盘制作完成

   

### 四、微星BIOS设置

开机不断按F11进入，选择高级模式（F7），切换到英文版

BIOS版本：E7C82IMS.130   2020/10/07

- 禁用

| 英文            | 路径                             | 设置状态 |
| --------------- | -------------------------------- | -------- |
| Fast Boot       | Settings/Boot/Boot Configuration | Disabled |
| MSI Fast Boot   | Settings/Boot/Boot Configuration | Disabled |
| CFG Lock        | Overclocking/CPU Features        | Disabled |
| Intel VT-D Tech | Overclocking/CPU Features        | Disabled |
| IntelSGX        | Overclocking/CPU Features        | Disabled |



- 启用

| 英文                                    | 路径                                                 | 设置状态 |
| --------------------------------------- | ---------------------------------------------------- | -------- |
| Above 4G memory/Crypto Currentcy mining | Settings/Advanced/PCIe/PCI Sub-System Settings       | Enabled  |
| Hyper-Threading                         | Overclocking/Advanced CPU Configuraton               | Enabled  |
| XHCI  Hand-off                          | Settings/Advanced/USB Configuration                  | Enabled  |
| Legacy USB Device                       | Settings/Advanced/USB Configuration                  | Enabled  |
| Resume By USB Device                    | Settings/Advanced/Wake Up Event Setup                | Enabled  |
| IGD Multi-Monitor                       | Settings/Advanced/intergrated Graphics Configuration | Enabled  |

改完后按F10保存，此时会重新启动



### 五、安装阶段

1. 插上制作好的启动U盘（插到主板后面的黑色的USB2.0口！！）

2. 开机，快速按F11，选择启动U盘进入安装，

3. 选择磁盘管理工具，对你要安装到的磁盘进行抹掉，格式为apfs（注意数据备份）

4. 完成后×掉，回到继续安装，安装的磁盘选择刚刚抹掉的那个磁盘，

5. window版安装过程需要网络，记得接上WIFI（这就是免驱卡的优势了），mac版是下载完整镜像（按道理来说不用接wifi），但我还是接了哈哈

6. 开始安装过程请耐心等待....

首次安装后会进行多次自动重启，选择 Mac Installer，直至选项中有MacOS，就选择MacOS，证明装成功了



### 六、安装完成

将启动U盘的EFI分区的EFI文件夹拷贝到安装磁盘的EFI分区目录下



### 七、问题修复

1. **板载2.5G网卡接入不了网络**
   系统偏好设置 -网络 - 以太网（高级）- 硬件 - 配置

   改成手动，选择速度:1000baseT、 双工:全双工、 MTU:标准1500，改完后应用即可

2. **核显正常，但是屏幕闪烁**
   dp线转hdmi会闪屏，hdmi转hdmi不会

3. **系统自带的输入法，大写键不起作用**

   安装搜狗输入法后可以使用，但是切换到系统的输入法后仍不起作用

4. **关闭啰嗦模式**

   修改启动参数（位置：NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82）

   从boot-args 项的值中删除

   ```shell
   -v keepsyms=1
   ```

5. **将Opencore放到bios的启动项的第一位**

   BIOS中【Settings/Boot/UEFI USB Key Drive BBS Proorities】的Boot Option #1 改成 Opencore。

6. **设置默认启动磁盘**

   进入启动引导选择界面时，按contrl+enter键，下次就默认选中它了。

7. **无法调节亮度**

   安装MonitorControl软件可以调节，效果一般

8. **Opencore启动的UI**

   在OC配置Resource中，自行了解

     

###  八、仍无法解决的问题

1. 睡眠无法从键盘唤醒，鼠标倒是可以。



### 九、曾遇到棘手的问题

1. **添加驱动文件后，记得添加快照，只保存也没用！！！**

   十分重要，会出错，安装好之后，如果你再删除添加了固件而不再次添加快照就会进不来系统。

   添加快照，选择OC目录，就是让配置文件知道你有了更改了

   1. Opencore Configurator 是在 内核设置/添加/ 左下角一个不起眼的位置上

   2. ProperTree：mac中是comand+R 

2. **无线网卡+蓝牙 BCM94360CD，在 big sur版本中蓝牙不起作用**

   在[OpenCore 支持的内核驱动 (Kext) 及其用途](https://oc.skk.moe/kextlist.html)中找到相应的补丁([BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM))，下载三个必要的kext，放入kext文件夹中（记得添加快照，否则不会写入你的配置！！！），然后在内核设置中配置补丁参数，即可解决

3. **安装完后屏闪+黑屏！！**

   本以为是核显没起作用，折腾了好久参考

   1. 【[教程：利用Hackintool打开第8代核显HDMI/DVI输出的正确姿势](https://blog.daliansky.net/Tutorial-Using-Hackintool-to-open-the-correct-pose-of-the-8th-generation-core-display-HDMI-or-DVI-output.html)】没有解决

   2. 用了[one-key-hidpi](https://github.com/xzhih/one-key-hidpi)开启hidpi，注入EEID仍是没有解决

   后面把dp转hdmi的线换成hdmi转hdmi的就可以了！！！我醉了，看网上说要dp口输出还专门买了dp转hdmi的线，后面给自己挖了个坑

4. **mac制作windows的启动盘**

   试了很多，都没办法装成功，最后还是用windows电脑到Microsoft官方制作启动盘（最靠谱！！）

   参考：[【装机教程】超详细WIN10系统安装教程，官方ISO直装与PE两种方法教程，UEFI+GUID分区与Legacy+MBR分区](https://www.bilibili.com/video/BV1DJ411D79y?from=search&seid=8570295898912758487)

   

### 十、感谢

[Dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html)

[bilibili 催眠UP主：司波图](https://space.bilibili.com/28457?from=search&seid=8395905450845074970)

[bilibili UP主 硬件茶谈](https://space.bilibili.com/14871346?spm_id_from=333.788.b_765f7570696e666f.1)

[bilibili UP 喵喵折App](https://space.bilibili.com/338748561?from=search&seid=8570295898912758487)

[**黑果小兵的部落阁**](https://blog.daliansky.net/)

[Xjn´s Blog](https://blog.xjn819.com/?p=543)

[OpenCore 简体中文参考手册](https://oc.skk.moe/)

[OpenCore 支持的内核驱动 (Kext) 及其用途](https://oc.skk.moe/kextlist.html)

[szc188](https://github.com/szc188)/**[MSI-B460M-MORTAR-10700K-5500XT-OC](https://github.com/szc188/MSI-B460M-MORTAR-10700K-5500XT-OC)**]

[xiaoka-li](https://github.com/xiaoka-li)/**[Hackintosh-CVN-B460i-10100](https://github.com/xiaoka-li/Hackintosh-CVN-B460i-10100)**]