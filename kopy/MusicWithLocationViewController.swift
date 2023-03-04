import CoreLocation
import AVFoundation
import UIKit
import MapKit

class MusicWithLocationController: UIViewController, CLLocationManagerDelegate {
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
    }
    @IBAction func playButton(_ sender: Any) {
        audioPlayer?.play()
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
            let univLocation = CLLocation(latitude: 33.595238, longitude: 130.226636) // 九州大学大橋キャンパスの座標
            
            let distance = univLocation.distance(from: location)
            print("Distance: \(distance)")
            
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
