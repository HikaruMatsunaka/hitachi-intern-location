//2曲間で音量を調節する

//import UIKit
//import AVFoundation
//import CoreMotion
//
//class ViewController: UIViewController {
//
//    //初期化
//    var audioPlayer1 = AVAudioPlayer()
//    var audioPlayer2 = AVAudioPlayer()
//    let motionManager = CMMotionManager()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //音楽のファイルパス
//        let url1 = Bundle.main.bundleURL.appendingPathComponent("sample1.mp3")
//        let url2 = Bundle.main.bundleURL.appendingPathComponent("sample2.mp3")
//
//        do {
//            //音楽再生
//            audioPlayer1 = try AVAudioPlayer(contentsOf: url1)
//            audioPlayer2 = try AVAudioPlayer(contentsOf: url2)
//
//            audioPlayer1.prepareToPlay()
//            audioPlayer2.prepareToPlay()
//
//            // 音楽を繰り返し再生するように設定
//            audioPlayer1.numberOfLoops = -1
//            audioPlayer2.numberOfLoops = -1
//
//            audioPlayer1.play()
////            audioPlayer2.play()
//            //ボリュームの初期値
//        } catch {
//            print("Failed to load audio file")
//        }
//
//        //モーションの設定
//        if motionManager.isGyroAvailable {
//            //データの更新間隔(interval)
//            motionManager.gyroUpdateInterval = 0.1
//            //データの取得開始と更新時の設定
//            motionManager.startGyroUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
//                guard let rotation = data?.rotationRate else { return }
//
//                //角速度を持ってくる軸を指定
//                let roll = rotation.z
//                self?.updateVolumeBasedOnYaw(roll)
//            }
//        }
//    }
//
//
//
//    //データが更新されるたびに、音量も変化するよう設定
//    func updateVolumeBasedOnYaw(_ yaw: Double) {
//        //ボリュームの変数を定義
//        let volume1: Float
//        let volume2: Float
//        //分岐
//        if yaw > 0 {
//            let ratio = min(1, Float(yaw) / 10)
//            volume1 = 1 - ratio
//            volume2 = ratio
//        } else {
//            let ratio = min(1, Float(-yaw) / 10)
//            volume1 = ratio
//            volume2 = 1 - ratio
//        }
//        //ボリュームを代入
//        audioPlayer1.volume = volume1
//        //こっち側のボリュームを通常よりも小さく聞こえるように設定したい
//        audioPlayer2.volume = volume2
//        }
//}
//

//1曲で音量を調節する
//import UIKit
//import AVFoundation
//import CoreMotion
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var actionButton: UIButton!
//    var player: AVPlayer?
//    let motionManager = CMMotionManager()
//    var currentVolume: Float = 0.5
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //音楽のファイルパス
//        let url = Bundle.main.bundleURL.appendingPathComponent("sample1.mp3")
//        let playerItem = AVPlayerItem(url: url)
//        player = AVPlayer(playerItem: playerItem)
//        //再生
//        player?.play()
//        //ボリュームの初期値
//        player?.volume = currentVolume
//
//        if motionManager.isGyroAvailable {
//            motionManager.gyroUpdateInterval = 0.01
//            motionManager.startGyroUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
//                guard let rotation = data?.rotationRate else { return }
//
//                //軸を指定
//                let yaw = rotation.z
//                self?.updateVolumeBasedOnYaw(yaw)
//            }
//        }
//    }
//
//    func updateVolumeBasedOnYaw(_ yaw: Double) {
//        var volume: Float
//        if yaw > 0 {
//            volume = Float(min(1, currentVolume + (Float(yaw) / 20)))
//        } else {
//            volume = Float(max(0, currentVolume + (Float(yaw) / 20)))
//        }
//
//        currentVolume = volume
//        player?.volume = volume
//    }
//}

////位置に合わせて音量を変える
//import CoreLocation
//import AVFoundation
//import UIKit
//import MapKit
//
//class ViewController: UIViewController, CLLocationManagerDelegate {
//    @IBOutlet weak var mapView: MKMapView!
//    //初期化
//    //位置情報の機能を管理する'CLLocationManagerクラスのインスタンスを宣言する
//    var locationManager: CLLocationManager!
//    var audioPlayer: AVAudioPlayer?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // ロケーションマネージャーのセットアップ
//        setupLocationManager()
//
//        // 音楽ファイルのパスを取得
//        guard let filePath = Bundle.main.path(forResource: "sample1", ofType: "mp3") else {
//            print("音楽ファイルが見つかりません")
//            return
//        }
//
//        // AVAudioPlayerのインスタンスを作成
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
//            audioPlayer?.numberOfLoops = -1 // 無限ループ
//            audioPlayer?.prepareToPlay() // 音楽を再生する前に必要
//        } catch {
//            print("AVAudioPlayerの初期化に失敗しました: \(error.localizedDescription)")
//        }
//
//        // 音楽を再生
//        audioPlayer?.play()
//    }
//
//    //ButtonAction
//    @IBAction func stopButton(_ sender: Any) {
//        audioPlayer?.stop()
//    }
//    @IBAction func playButton(_ sender: Any) {
//        audioPlayer?.play()
//    }
//
//    func setupLocationManager(){
//        //locationManagerを初期化する。
//        locationManager=CLLocationManager()
//        //locationManagerオブジェクトが初期化に成功しているか確認
//        guard let locationManager = locationManager else {return}
//        //「アプリ使用中のみ許可」を使う
//        locationManager.requestWhenInUseAuthorization()
//        //ユーザの許可状態
//        let status = CLLocationManager.authorizationStatus()
//        //許可された場合
//        if status == .authorizedWhenInUse {
//            locationManager.distanceFilter = 10
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    // 位置情報が更新されたときに呼ばれるメソッド
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //初期位置
//        let location = locations.first
//        //緯度軽度の格納
//        // 緯度と経度から音量を計算
//        let latitude = location?.coordinate.latitude
//        let longitude = location?.coordinate.longitude
//        print("latitude: \(latitude!)\nlongitude: \(longitude!)")
//
//        //ここを調節する
//        let volume = (latitude! + longitude!) / 1000.0 // -90.0 〜 90.0, -180.0 〜 180.0 の範囲になるため、180で割る
//
//        // 音量を設定
//        audioPlayer?.volume = Float(volume)
//    }
////
////    // 位置情報の取得に失敗したときに呼ばれるメソッド
////    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
////        print("位置情報の取得に失敗しました: \(error.localizedDescription)")
////    }
//}


import CoreLocation
import AVFoundation
import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var audioPlayer: AVAudioPlayer?
    let kyuUnivLocation = CLLocation(latitude: 33.5816183, longitude: 130.4021879)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 音楽ファイルのパスを取得
        guard let filePath = Bundle.main.path(forResource: "sample1", ofType: "mp3") else {
            print("音楽ファイルが見つかりません")
            return
        }
        
        // AVAudioPlayerのインスタンスを作成
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            audioPlayer?.numberOfLoops = -1 // 無限ループ
            audioPlayer?.prepareToPlay() // 音楽を再生する前に必要
        } catch {
            print("AVAudioPlayerの初期化に失敗しました: \(error.localizedDescription)")
        }
        
        // ロケーションマネージャーのセットアップ
        setupLocationManager()
        
        // 音楽を再生
        audioPlayer?.play()
    }
    
    //ButtonAction
    @IBAction func stopButton(_ sender: Any) {
        audioPlayer?.stop()
        print("停止")
    }
    @IBAction func playButton(_ sender: Any) {
        audioPlayer?.play()
        print("再生")
    }
    
    func setupLocationManager(){
        locationManager=CLLocationManager()
        guard let locationManager = locationManager else {return}
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.distanceFilter = 10
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }

        //キャンパスの噴水に座標を指定
        let univLocation = CLLocation(latitude: 33.5604695959691, longitude: 130.42980526066953)
            let distance = univLocation.distance(from: location)
            print("Distance: \(distance)")
            
        //30m以内の場合は音量を最大(1.0)に、80m以上の場合は音量を最小(0.0)に設定
            var volume: Float = 0.0
            if distance < 30 {
                volume = 1.0
            } else if distance >= 80 {
                volume = 0.0
            } else {
                let diff = distance - 30
                let maxDiff = 80 - 30
                let ratio = 1.0 - (diff / Double(maxDiff))
                volume = Float(ratio)
            }
            
            audioPlayer?.volume = volume
    }
}
