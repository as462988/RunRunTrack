<img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/icon.jpg" width="100" height="120"/>

# 餐車在哪兒

每一台餐車，都有背後的故事...<br> 
這是一款專屬給餐車與吃貨的小天地

## 功能

### 關於餐車
#### 找尋餐車
在首頁可以查看所有營業中的餐車並找尋他們的位置
* Google Map 自定義的 **GMSMarker** 顯示已營業的餐車位置<br>
* 設計自定義的 `UICollectionViewFlowLayout` 呈現卡片式的餐車資訊，並且在切換卡片時跳轉至該餐車位置<br>
* 引用 `Core Location` ＆ `Contacts` 的 `postalAddress` 轉換經緯度為精確的地址<br>
* 使用 [HandleOpenURL](https://github.com/as462988/WhereIsTheTruck/blob/master/RunRunTruck/Model/HandleOpenURL.swift) 開啟 URL 的方式，讓用戶可以開啟 GoogleMap 的 App，導航到該餐車的位置。

<img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/Lobby.gif" width="180" height="360"/><img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/List.PNG" width="180" height="360"/><img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/Detail.PNG" width="180" height="360"/>

#### 即時聊天室

* 實作**Firebase Snapshot Listener** 即時的顯示用戶發送的訊息，增添使用者間的互動。
* 針對用戶需求加入點擊頭像的封鎖功能

<img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/ChatRoomGif.gif" width="180" height="360"/>

### 成就系統

* 透過掃描 QR Code 的方式蒐集餐車發送的徽章
* 引用 **CASpringAnimation**達成收到徽章時的動畫
<img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/Hnet-image.gif" width="180" height="360"/>

### 個人頁面

#### 註冊與登入
使用 **Sign In With Apple & Firebase Authorization** 作為用戶登入&註冊的方式，並使用 **[KeyChain](https://github.com/as462988/WhereIsTheTruck/blob/master/RunRunTruck/Model/Keychain.swift)** 儲存用戶的登入狀態。

<img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/SingIn.PNG" width="180" height="360"/>

#### 我是吃貨

* 提供修改照片的功能，設計 [OpenChoseCameraManager]() 開啟選擇相簿內的照片，並針對上傳的照片調整大小。
* 探索餐車與喜愛餐車的顯示，設計在 CollectionView 的 cell 中再使用 CollectionView 呈現，並在兩個 view 間傳值。
* 對喜愛餐車開店的提醒通知，並在點擊通知後跳轉至該餐車的資訊。

``` swift
func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
     //添加點擊通知後要做的事情
}
```
<img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/ProfileGif.gif" width="180" height="360"/><img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/uploadImageGif.gif" width="180" height="360"/><img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/SettingGif.gif" width="180" height="360"/>

#### 我是老闆

* 使用 Google Map 選取開店時的位置，同時在開店時發送開店通知給喜愛餐車的用戶
* 建立 QR Code 的徽章，並在限時內關閉 QR Code
``` swift
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
```
<img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/ProfileBoss.PNG" width="180" height="360"/><img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/Open.PNG" width="180" height="360"/><img src="https://github.com/as462988/WhereIsTheTruck/blob/master/screenshot/Qrcode.PNG" width="180" height="360"/>

### Third-party Libraries
* [GoogleMaps](https://developers.google.com/maps/documentation/ios-sdk/start) - 顯示餐車位置及用戶位置
* [Firebase](https://firebase.google.com/docs/ios/setup)
  * Auth - 驗證用戶註冊與登入資訊，並針對錯誤進行處理
  * Storage - 儲存用戶上傳後的照片，並顯示於畫面
  * Messaging - 訊息推播工具，用來發送老闆開店資訊
* [Kingfisher](https://github.com/onevcat/Kingfisher) - 善用快取的方式處理網路圖片並呈現在 App
* [SwiftLint](https://github.com/realm/SwiftLint) - 檢查 codeing Style 的工具
* [Crashlytics](https://firebase.google.com/docs/crashlytics) - 掌握 App 的 Crash報告
* [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) - 解決鍵盤彈起時遮住輸入框的工具
* [lottie-ios](https://github.com/airbnb/lottie-ios) - 呈現動畫效果
* [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD) - 顯示狀態的提示窗

## Requirements
* Xcode 11
* iOS 13 SDK
* An iPhone running iOS 13.0 
A code signing key from Apple is required to deploy apps to a device.

## Download
[<img src="https://github.com/as462988/WhereIsTheTruck/blob/develop/screenshot/appstore.png" width="180"/>](https://itunes.apple.com/app/owncloud/id1481326966)
