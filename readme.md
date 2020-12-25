### 目录结构

- debug：使用OpenCore  debug包，体积稍大，保留啰嗦模式
- release：使用OpenCore  release包，体积小，去掉啰嗦模式
- tools：hackintosh的常用工具（以mac的为主）

### 黑苹果配置

OpenCore版本： [0.6.4](https://github.com/acidanthera/OpenCorePkg/releases/tag/0.6.4)

MacOS版本：big sur 11.0.1 （20B29）

下面的图片看不了？

请参考[Github无法加载或不显示图片问题](https://www.jianshu.com/p/25e5e07b2464)

- 启动画面

  第12s的时候有一下子闪屏，非完美主义不影响使用。
  
  [启动视频](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/boot.mp4)

- 配置

  ![big sur 11.0.1 （20B29）](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E9%85%8D%E7%BD%AE.png)

- 主界面

  ![big sur 11.0.1 （20B29）](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E6%A1%8C%E9%9D%A2.png)

- 核显

  ![big sur 11.0.1 （20B29）](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E6%A0%B8%E6%98%BE.png)

- 蓝牙-wifi-以太网

  ![蓝牙-wifi-以太网](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/Bluetooth%2Bwifi.png)

- 隔空投送

  ![隔空投送](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/AirDrop.png)

- 接力

  ![接力](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E6%8E%A5%E5%8A%9B1.png)

  ![接力](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E6%8E%A5%E5%8A%9B2.png)

### 支持功能

- ✅  蓝牙-wifi（BCM94360CD）
- ✅  以太网（需手动设置）
- ✅  睡眠唤醒（鼠标唤醒）
- ✅  核显加速
- ✅  隔空投送
- ✅  接力
- ✅  App Store
- ✅  所有USB
- ✅  声卡
- ❌  风扇+电源（无法检测）
- ❓ 随航（未测试）
- ❓ 独显（未测试）

### GeekBench5跑分

- 综合

  ![综合](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/GeekBench%E7%BB%BC%E5%90%88.png)

- 单核

  ![单核](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/GeekBench%E5%8D%95%E6%A0%B8.png)

- 多核

  ![多核](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/GeekBench%E5%A4%9A%E6%A0%B8.png)

### 我的配置

我装的是双系统 Windows+MacOS

| 配置             | 型号                                                      | 价格  | 购买渠道 |
| ---------------- | --------------------------------------------------------- | ----- | -------- |
| CPU              | 英特尔 Intel i7 10700（9或10代cpu最好）                   | 2279  | JD       |
| 主板             | 微星 MSI MAG B460M MORTAR 迫击炮✅                         | 659   | JD       |
| 内存             | 2 x 16G 金士顿（Kingston）DDR4 3200 骇客神条 Fury雷电系列 | 899   | JD       |
| 显卡             | 核显（我的显示器是接核显的，独立显卡未测试）✅             | 0     | JD       |
| 显示器           | AOC Q2490W1 2k 60HZ                                       | 992   | JD       |
| 连接线           | 山泽 4k HDMI转HDMI                                        | 22    | JD       |
| 固态硬盘（m.2）  | 2 x Western Digital 西数 SN750 512G                       | 499x2 | JD       |
| 固态硬盘（SATA） | 英睿达（Crucial）MX500 500G                               | 355   | JD       |
| 机型硬盘（SATA） | 东芝（TOSHIBA）64MB 7200RPM P300 3T                       | 433   | JD       |
| wifi+蓝牙        | BCM94360CD 1750M（Fenvi T919）✅                           | 250   | TB       |
| 散热器           | 利民FS140                                                 | 209   | JD       |
| 电源             | 海韵（SEASONIC）FOCUS GX750 750W电源                      | 659   | JD       |
| 机箱             | 追风者 300 Air                                            | 219   | TB       |
| 散热风扇         | ID-COOLING XF-12025-SD-K 无光 x 3                         | 16x3  | JD       |

除显示器外，都是双十一前购买，加上一些优惠：6724元（不包括显示器）

`**如果你满足以上3️⃣点，可以参考我的配置**`

⚠️友情提示：

- `连接线的坑`：京东买了毕亚兹的DP转HDMI，会闪屏，注入UUID无解，目前无法解决，HDMI转HDMI显示正常。

- `SATA接口`：如果使用两个m,2的固态，注意靠近cpu的m.2接口与SATA1接口冲突，装了固态后，SATA1接口不可用。

### 小白建议

我自己也算是个小白，先看了视频，再去看官方教程捣鼓，最后慢慢的修复问题

`**如果不懂，建议先看上B站看一下视频，了解大致流程**`

[【司波图】CometLake十代Intel平台台式机Opencore黑苹果通用配置教程（附安装包）](https://www.bilibili.com/video/BV1uf4y1X7MT)

[【司波图】Intel Coffee Lake平台完美黑苹果系统安装教程（Opencore+Catalina15.4）](https://www.bilibili.com/video/BV1hA411t7dr)

### 一、准备工作

下面的工具若无法下载的可以在Tools目录下试图寻找

- [QCOpenCoreConfig](https://github.com/ic005k/QtOpenCoreConfig)：配置文件plist编辑器（windows版）

- [ProperTree](https://github.com/corpnewt/ProperTree)：配置文件plist编辑器（windows版和mac都可以）

- [OpenCore Configurator](https://mackie100projects.altervista.org/download/opencore-configurator-2-15-2-0/)：配置文件plist编辑器（mac版）

- [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)：生成三码（主板号、序列号、UUID）

- [GibMacOS](https://github.com/corpnewt/gibMacOS) ：下载系统镜像

- [MountEFI](https://github.com/corpnewt/MountEFI)：挂着磁盘EFI工具，也可以使用OpenConfigurator自带的方式挂着

- 8G及以上 U盘

- [安装python环境](https://www.python.org/downloads/release/python-390/)：有了的话忽略

### 二、制作启动U盘

[官方教程](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/)【需科学上网】

### 三、享用（修改配置参数）

下载后先使用debug版本的（有啰嗦模式），稳定后在换release版本的（体积小，关闭啰嗦模式）

将debug版本的EFI文件夹负责出来到桌面（任意位置）

1. 用GenSMBIOS生成三码（或其他方式），建议机型  iMac19,1

2. 查看自己电脑的mac地址

3. Opencore Configurator打开 EFI/OC/config.plist 文件

选择【PlatformInfo-机型平台设置】-DataHub -Generic - PlatformNVRAM

![GenSMBIOS生成的结果](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E4%B8%89%E7%A0%81.png)

上面以供参考，请自行生成！

| 选项                 | 填入值                                           |
| -------------------- | ------------------------------------------------ |
| System Serial Number | 序列号（Serial）                                 |
| System UUID          | UUID（SmUUID）                                   |
| MLB                  | 主板号（Board Serial）                           |
| ROM                  | 电脑MAC地址（没装系统的可以保留默认的），不要:号 |

更改后记得保存！！

4. 使用磁盘挂载工具挂载启动U盘的EFI，将修改好的EFI文件夹复制到U盘的EFI分区中，如果分区本来就有EFI就先删除。

5. 属于你的启动U盘制作完成

### 四、微星BIOS设置

开机不断按F11进入，选择高级模式（F7），切换到英文版

BIOS版本：[E7C82IMS.130](http://cn.msi.com/Motherboard/support/MAG-B460M-MORTAR)   2020/10/07

- 禁用

| 英文                             | 路径                                   | 设置状态 |
| -------------------------------- | -------------------------------------- | -------- |
| Fast Boot                        | Settings/Boot/Boot Configuration       | Disabled |
| Secure Boot                      | Settings/Security/Secure Boot          | Disabled |
| MSI Fast Boot                    | Settings/Boot/Boot Configuration       | Disabled |
| CFG Lock                         | Overclocking/CPU Features              | Disabled |
| Discrete Thunderbolt(TM) Support | Settings/Advance/Intel（R）Thunderbolt | Disabled |
| Intel VT-D Tech                  | Overclocking/CPU Features              | Disabled |
| IntelSGX                         | Overclocking/CPU Features              | Disabled |
| Serial/COM Port                  | 找不到，目前没发现有什么影响           |          |
| Paraller  Port                   | 找不到，目前没发现有什么影响           |          |
| Intel Platform Trust             | 找不到，目前没发现有什么影响           |          |

- 启用

| 英文                                    | 路径                                                        | 设置状态  |
| --------------------------------------- | ----------------------------------------------------------- | --------- |
| Above 4G memory/Crypto Currentcy mining | Settings/Advanced/PCIe/PCI Sub-System Settings              | Enabled   |
| Hyper-Threading                         | Overclocking/Advanced CPU Configuraton                      | Enabled   |
| XHCI  Hand-off                          | Settings/Advanced/USB Configuration                         | Enabled   |
| Legacy USB Device                       | Settings/Advanced/USB Configuration                         | Enabled   |
| Resume By USB Device                    | Settings/Advanced/Wake Up Event Setup                       | Enabled   |
| BIOS CSM/UEFI Mode                      | Settings/Advanced/                                          | UEFI      |
| SATA Mode                               | Settings/Advanced/Integrated Peripherals/SATA Configuration | AHCI Mode |
| Integrated Grahics Adapter              | Settings/Advanced/intergrated Graphics Configuration        | PEG       |
| Integrated Grahics Share Memory         | Settings/Advanced/intergrated Graphics Configuration        | 64MB      |
| IGD Multi-Monitor                       | Settings/Advanced/intergrated Graphics Configuration        | Enabled   |

改完后按F10保存，此时会重新启动

`提示：`
如果使用docker，BIOS设置`Intel virtual tech`为enable.

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

### 八、仍无法解决的问题

1. 睡眠无法从键盘唤醒，鼠标倒是可以。

### 九、曾遇到棘手的问题

1. **添加驱动文件后，记得添加快照，只保存也没用！！！**

   十分重要，会出错，安装好之后，如果你再删除添加了固件而不再次添加快照就会进不来系统。

   添加快照，选择OC目录，就是让配置文件知道你有了更改了

   1. Opencore Configurator 是在 内核设置/添加/ 左下角一个不起眼的位置上

   2. ProperTree：mac中是`comand+R`

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

5. **Windows+Mac双系统时间不一致，Windows的系统时间不准**

   - 在Windows的命令行工具（以管理员的身份运行）

   ```bash
   Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
   ```

### 十、后续（写给自己看，核显+AMD独显（未测试））

以下内容参考：

 [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/config.plist/comet-lake.html#deviceproperties)

 [macOS BigSur 11.0安装中常见的问题及解决方法](https://blog.daliansky.net/Common-problems-and-solutions-in-macOS-BigSur-11.0-installation.html)

 [AMD Radeon Performance Enhanced SSDT](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/)

- 第一步：修改**AAPL,ig-platform-id**

  编辑配置文件，进入DeviceProperties/PciRoot(0x0)/Pci(0x2,0x0)/添加，将**AAPL,ig-platform-id**改成 0300C89B，（用独显输出）

  摘抄自于
  [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/config.plist/comet-lake.html#deviceproperties)
  
  | AAPL，ig-platform-id | 说明                                                   |
  | -------------------- | ------------------------------------------------------ |
  | 07009B3E             | 当使用台式机iGPU（独显）驱动显示器时使用               |
  | 00009B3E             | 如果它不起作用，则替代07009B3E                         |
  | 0300C89B             | 当台式机iGPU（独显）仅用于计算任务而不驱动显示器时使用 |

- 第二步：修改**boot-args**参数

  NVRAM-随机访问存储器设置/7C436110-AB2A-4BBB-A880-FE41995C9F82项中

  键：boot-args

  值：添加`agdpmod=pikera`，注意空格

  说明：

  摘自[OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/config.plist/comet-lake.html#nvram)

  摘自[OpenCore 参考手册](https://oc.skk.moe/9-nvram.html)

  - **通用引导参数**：

    | 引导参数        | 描述                                                         |
    | --------------- | ------------------------------------------------------------ |
    | **-v**          | 啰嗦模式                                                     |
    | **debug=0x100** | Debug 掩码                                                   |
    | **keepsyms=1**  | 这是debug = 0x100的辅助设置，显示 Panic 日志调试符号         |
    | **alcid=1**     | 用于设置AppleALC的layout-id，请参阅[支持的编解码器，](https://github.com/acidanthera/applealc/wiki/supported-codecs)以找出要用于特定系统的布局。有关更多信息，请参见[安装后页面](https://dortania.github.io/OpenCore-Post-Install/) |

  - **GPU特定的boot-args**：

    | 引导参数           | 描述                                                         |
    | ------------------ | ------------------------------------------------------------ |
    | **agdpmod=pikera** | 用于禁用Navi GPU（RX 5000系列）上的boardID，否则，您将获得黑屏。**如果您没有Navi，请不要使用**（例如Polaris和Vega卡不应该使用此功能） |
    | **-wegnoegpu**     | 用于禁用除集成英特尔iGPU之外的所有其他GPU，对于那些希望运行不支持其dGPU的较新版本的macOS的用户有用 |

- 第三步：使用Hackintool工具查看自己独显的设备地址（非必须）

  打开Hackintool-PCI项-找到设备名称为Navi10xxx对应的设备地址，复制。

  例如：

  ```shell
  PciRoot(0x0)/Pci(0x1,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0)/Pci(0x0,0x0) //仅供参考
  ```

  然后在DeviceProperties/项中添加

  `shikigva=80`

  ![独显硬解码](http://mrdonkey-hackintosh.oss-cn-beijing.aliyuncs.com/oc-msi-b460m-mortar-i7-10700/%E7%8B%AC%E6%98%BE%E7%A1%AC%E8%A7%A3%E7%A0%81.png)

  说明：`shikigva`：实现独显硬解码
  
  参考：
  
  [摘自macOS BigSur 11.0安装中常见的问题及解决方法-如遇 TV、Netflix 等带有 DRM 的视频解码黑屏问题，请尝试在启动参数中添加`shikigva=80`](https://blog.daliansky.net/Common-problems-and-solutions-in-macOS-BigSur-11.0-installation.html)

- 第四步：释放显卡性能（非必要）

  适用于`RX5500/5500XT`、`RX5700/RX5700XT`、`RX580`、`RX Vega64`

  [AMD Radeon Performance Enhanced SSDT(<https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/>)

### 十、升级OpenCore

参考： [Updating OpenCore and macOS](https://dortania.github.io/OpenCore-Post-Install/universal/update.html)
主要是用新的efi替换掉旧的efi的中必要的文件即可。
先把更新好的EFI放到U盘启动，U盘启动正常后再放到电脑的EFI里。
如果直接使用该项目升级的话，记在`config.plist`文件里的机型平台设置填自己的三码~~

```shell
# 在终端输入下方命令，查看oc的版本
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
# 输出如下 0.6.4版本，即可
4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version	REL-064-2020-12-07
```

### 十一、感谢

[Dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html)

[bilibili 催眠UP主：司波图](https://space.bilibili.com/28457?from=search&seid=8395905450845074970)

[bilibili UP主 硬件茶谈](https://space.bilibili.com/14871346?spm_id_from=333.788.b_765f7570696e666f.1)

[bilibili UP 喵喵折App](https://space.bilibili.com/338748561?from=search&seid=8570295898912758487)

[黑果小兵的部落阁](https://blog.daliansky.net/)

[Xjn´s Blog](https://blog.xjn819.com/?p=543)

[OpenCore 简体中文参考手册](https://oc.skk.moe/)

[OpenCore 支持的内核驱动 (Kext) 及其用途](https://oc.skk.moe/kextlist.html)

[szc188](https://github.com/szc188)/**[MSI-B460M-MORTAR-10700K-5500XT-OC](https://github.com/szc188/MSI-B460M-MORTAR-10700K-5500XT-OC)**]

[xiaoka-li](https://github.com/xiaoka-li)/**[Hackintosh-CVN-B460i-10100](https://github.com/xiaoka-li/Hackintosh-CVN-B460i-10100)**]

### 十二、梯子

[Slower](https://slower.tsnet.net/auth/register?code=qxno)：这是我正在使用的一款，支持多终端（Windows+Mac、IOS+Android）...目前使用没什么问题。

欢迎填写我的推荐码：`qxno`

- 遇到的问题
  
 1. 使用梯子利用终端下载依然很慢（或超时）
    自行搜索🔍`终端配置ssr代理`

 2. 终端代理配置好了，正常下载，但是使用idea（我用的是webstorm）将本地工程推送到GitHub上时，添加不了remote远程分支或者出现`Invalid authentication data. Connection refused.`错误
      我发现原因是终端设置了代理（必须得去掉终端的代理），在idea中设置代理。。。很奇怪。目前没遇到更好的解决方式。
