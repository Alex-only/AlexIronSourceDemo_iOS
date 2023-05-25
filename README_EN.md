# AlexIronsourceDemo_iOS

# integration

## 1. Access TopOn SDK

Please refer to [TopOn SDK Integration Documentation](https://docs.toponad.com/#/en-us/ios/GetStarted/TopOn_Get_Started) to access TopOn SDK, it is recommended to access **TopOn v6.1.65 and above**



## 2. Introduce Alex Adapter

1. Drag the code under the Ironsource folder into the project

![截屏2023-05-25 15 16 14](https://github.com/Alex-only/AlexIronSourceDemo_iOS/assets/124124788/b7108484-fe3d-4ff0-8fbb-dd4bf61d4404)

2. Add the following instructions to Podfile, and then execute pod install
  pod 'IronSourceSDK','7.3.0.0'

  pod 'AnyThinkiOS','6.2.16'

3. The Key used in the Adapter is described as follows:

```
"sdk_key": SDK Key of the advertising platform
"unit_id": the advertising unit ID of the advertising platform
"unit_type": Ad unit type, 0: Banner, 1: MREC
```


### 3. Background configuration

1. You need to add a Custom Network.

![1](https://user-images.githubusercontent.com/124124788/222124007-1a773ce8-aa7a-4a36-842b-9a67577327bb.png)


2. Choose "Custom Network". Fill in Network Name/Account Name and Adapter's class names according to the contents above.
*Network Name needs to contain Ironsource to distinguish the Network. Example: Ironsource_XXXXX,

![2](https://user-images.githubusercontent.com/124124788/222124025-dd7700ad-3190-4c30-a63f-2c82e13005bb.png)


3. Mark the Network Firm ID

![3](https://user-images.githubusercontent.com/124124788/222124037-0f4ab1fd-9295-411e-b08b-21d2ac2667b3.png)

4. You can add the Ad Sources after adding the Network.

5. You can edit the placement setting to fill the report api key.

