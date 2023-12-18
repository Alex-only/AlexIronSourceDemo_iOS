# AlexIronsourceDemo_iOS

# integration

## 1. Access TopOn SDK

Please refer to [TopOn SDK Integration Documentation](https://docs.toponad.com/#/en-us/ios/GetStarted/TopOn_Get_Started) to access TopOn SDK, it is recommended to access **TopOn v6.2.30 and above**



## 2. Introduce Alex Adapter

1. Drag the code under the Ironsource folder into the project

![截屏2023-05-25 15 16 14](https://github.com/Alex-only/AlexIronSourceDemo_iOS/assets/124124788/b7108484-fe3d-4ff0-8fbb-dd4bf61d4404)

2. Add the following instructions to Podfile, and then execute pod install
    pod 'IronSourceSDK','7.3.0.0'

  pod 'AnyThinkiOS','6.2.30'

3. The Key used in the Adapter is described as follows:

```
"sdk_key": SDK Key of the advertising platform
"unit_id": the advertising unit ID of the advertising platform
"unit_type": Ad unit type, 0: Banner, 1: MREC
```


### 3. Background configuration

1. After connecting according to the SDK docking document, you need to add a custom advertising platform in the background

![1](https://user-images.githubusercontent.com/124124788/222124007-1a773ce8-aa7a-4a36-842b-9a67577327bb.png)


2. Select [Custom Network], fill in the advertising platform name and account name, and fill in the Adapter according to the SDK docking document

  *The name of the advertising platform needs to be written with ironSource, which is convenient for distinguishing the advertising platform. The suggested name format: ironSource_XXXXX*

![image2](Assets/image2_en.png)



Note: If you use the aar method or directly use the source code method (without modifying the class name), please configure the following class name. If the class name is modified, please configure the modified class name

```
AlexISRewardedVideoAdapter
AlexISInterstitialAdapter
```

![image3](Assets/image3_en.png)


3. Record Network Firm ID

![3](https://user-images.githubusercontent.com/124124788/222124037-0f4ab1fd-9295-411e-b08b-21d2ac2667b3.png)

4. You can add the Ad Sources after adding the Network.

5. You can edit the placement setting to fill the report api key.

6. ironSource configuration

Create Placement

![image5](Assets/image5.png)

Activate ironSource bidding

![image6](Assets/image6.png)

Configure waterfall

![image7](Assets/image7.png)

### Step 4. ironSource integrates with other advertising platforms

If you do not need to access other advertising platforms through ironSource, you can skip this part. Take access to Mintegral as an example:

1、Go to [TopOn Backstage](https://docs.toponad.com/#/en-us/android/download/package) first, and check which version of Mintegral is compatible with the connected TopOn version? (The Mintegral version compatible with TopOn v6.2.30 is v7.3.6)

2、Then go to [ironSource Background](https://developers.is.com/ironsource-mobile/android/mediation-networks-android/#step-2), according to the ironSource SDK version (v7.3.0.0.0) and Mintegral version (v16.3.61), find the corresponding Adapter version (that is v7.3.6)

**Note:**

(1) If you cannot find the Adapter corresponding to Mintegral v16.3.61, you can find the corresponding Adapter version by [viewing the Changelog of the Adapter](https://developers.is.com/ironsource-mobile/android/mintegral-change-log/)

(2) Make sure both TopOn and ironSource are compatible with Mintegral SDK

![image4](https://user-images.githubusercontent.com/124124788/222310868-8742a84c-61ef-4538-a907-1c94b085eab7.png)
