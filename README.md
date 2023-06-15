# AlexIronsourceDemo_iOS

# 集成

Tip: If necessary, please refer to [the English documentation](https://github.com/Alex-only/AlexIronSourceDemo_iOS/blob/main/README_EN.md)

## 一. 接入TopOn SDK

请参考[TopOn SDK集成文档](https://docs.toponad.com/#/zh-cn/ios/GetStarted/TopOn_Get_Started)接入TopOn SDK，建议接入**TopOn v6.2.30及以上版本**



## 二. 引入Alex Adapter

1.将 Ironsource 文件夹下源代码 或者 AlexIronsourceSDKAdapter.framework 拖入项目中
![截屏2023-05-25 15 16 14](https://github.com/Alex-only/AlexIronSourceDemo_iOS/assets/124124788/b7108484-fe3d-4ff0-8fbb-dd4bf61d4404)

<img width="982" alt="截屏2023-05-25 15 23 23" src="https://github.com/Alex-only/AlexIronSourceDemo_iOS/assets/124124788/5a755c0b-02bd-4c97-abb1-afdfa448c59b">


2.Podfile 添加以下指令, 然后执行 pod install 

  pod 'IronSourceSDK','7.3.0.0'

  pod 'AnyThinkiOS','6.2.30'

3.Adapter中使用的Key说明如下：

```
"sdk_key": 广告平台的SDK Key
"unit_id": 广告平台的广告位ID
"unit_type": 广告位类型，0: Banner, 1: MREC
```

### 三. 后台配置

1、按照SDK对接文档接入同时，需要在后台添加自定义广告平台

![image1](https://user-images.githubusercontent.com/124124788/217697673-6991552e-d4de-466d-976c-cc3903cdc60e.png)


2、选择【自定义广告平台】，填写广告平台名称、账号名称，按照SDK的对接文档填写Adapter.  
   ps:(广告平台名称需要写上Ironsource，便于区分广告平台，建议名称格式：Ironsource_XXXXX)

![image2](https://user-images.githubusercontent.com/124124788/217697688-3bc7cc6b-ea95-4887-948c-7eeb30402fbe.png)

将对应adapter的类名填入相关位置

<img width="697" alt="截屏2023-06-14 19 52 58" src="https://github.com/Alex-only/AlexIronSourceDemo_iOS/assets/124124788/d13cf102-f252-4e53-8de8-5b36f97dca8b">

3、记录广告平台ID

![image3](https://user-images.githubusercontent.com/124124788/217697699-a08a413b-0e91-4dcb-bb44-56a1ef4c0e39.png)

4、广告平台添加完成后，需要等待15min左右，再添加广告源（添加广告源时按照对应样式配置即可）

5、可编辑广告平台设置，选择是否开通报表api并拉取数据

### 四. Ironsource接入其他广告平台

如果不需要通过Ironsource接入其他广告平台，可跳过此部分内容。以接入Mintegral为例：

1、先到 [TopOn后台](https://docs.toponad.com/#/zh-cn/android/download/package)，查看接入的TopOn版本兼容的Mintegral版本是多少？（TopOn v6.1.65版本兼容的Mintegral版本为v16.3.61）

2、然后到 [Ironsource后台](https://dash.applovin.com/documentation/mediation/android/mediation-adapters#adapter-network-information)，根据接入的Ironsource SDK版本（v11.6.0）和Mintegral版本（v16.3.61），查找对应的Adapter版本（即v16.3.61.0）

**注意：**

（1）如果找不到Mintegral v16.3.61版本对应的Adapter，可通过查看Adapter的Changelog，找到对应的Adapter版本

（2）需确保TopOn和Max都兼容Mintegral SDK
![image4](https://user-images.githubusercontent.com/124124788/222310868-8742a84c-61ef-4538-a907-1c94b085eab7.png)



