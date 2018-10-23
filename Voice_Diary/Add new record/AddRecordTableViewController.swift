//
//  AddRecordTableViewController.swift
//  Perdia
//
//  Created by Rawand Ahmed Shaswar on 10/19/17.
//  Copyright © 2017 DesertCoders Asia. All rights reserved.
//

import UIKit
//import FirebaseDatabase
//import FirebaseAuth
import Firebase
import Speech
import Alamofire
import SwiftyJSON
import CoreLocation

class AddRecordTableViewController: UITableViewController,UITextViewDelegate,UITextFieldDelegate,SFSpeechRecognizerDelegate , CLLocationManagerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    var locationManager:CLLocationManager!
    
    @IBOutlet var DescTextView: UITextView!
    @IBOutlet var TitleTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var weatherTextField: UITextField!
    
    @IBAction func STT(_ sender: Any) {
        if audioEngine.isRunning { // 현재 음성인식이 수행중이라면
            audioEngine.stop() // 오디오 입력을 중단한다.
            recognitionRequest?.endAudio() // 음성인식 역시 중단
            button.isEnabled = false
            button.setTitle("말하기!", for: .normal)
        } else {
            startRecording()
            button.setTitle("말하기 멈추기", for: .normal)
        }
    }
    //    @IBAction func speechToText(_ sender: Any) {
    //        if audioEngine.isRunning { // 현재 음성인식이 수행중이라면
    //            audioEngine.stop() // 오디오 입력을 중단한다.
    //            recognitionRequest?.endAudio() // 음성인식 역시 중단
    //            button.isEnabled = false
    //            button.setTitle("말하기!", for: .normal)
    //        } else {
    //            startRecording()
    //            button.setTitle("말하기 멈추기", for: .normal)
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //STT
        speechRecognizer?.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
             locationManager.requestWhenInUseAuthorization() //권한 요청
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
            //현재 위치 좌표 가져오기
            getCurrentLocation()
        }else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            getCurrentLocation()
        }
    }
    
    func startRecording() {
        //인식 작업이 실행 중인지 확인합니다. 이 경우 작업과 인식을 취소합니다.
        if recognitionTask != nil {
            
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        //오디오 녹음을 준비 할 AVAudioSession을 만듭니다. 여기서 우리는 세션의 범주를 녹음, 측정 모드로 설정하고 활성화합니다. 이러한 속성을 설정하면 예외가 발생할 수 있으므로 try catch 절에 넣어야합니다.
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker
            )
            
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        //recognitionRequest를 인스턴스화합니다. 여기서 우리는 SFSpeechAudioBufferRecognitionRequest 객체를 생성합니다. 나중에 우리는 오디오 데이터를 Apple 서버에 전달하는 데 사용합니다.
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // audioEngine (장치)에 녹음 할 오디오 입력이 있는지 확인하십시오. 그렇지 않은 경우 치명적 오류가 발생합니다.
        let inputNode = audioEngine.inputNode
        //        guard let inputNode = audioEngine.inputNode else {
        //            fatalError("Audio engine has no input node")
        //        }
        //recognitionRequest 객체가 인스턴스화되고 nil이 아닌지 확인합니다.
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        //사용자가 말할 때의 인식 부분적인 결과를보고하도록 recognitionRequest에 지시합니다.
        
        recognitionRequest.shouldReportPartialResults = true
        
        // 인식을 시작하려면 speechRecognizer의 recognitionTask 메소드를 호출합니다. 이 함수는 완료 핸들러가 있습니다. 이 완료 핸들러는 인식 엔진이 입력을 수신했을 때, 현재의 인식을 세련되거나 취소 또는 정지 한 때에 불려 최종 성적표를 돌려 준다.
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            //  부울을 정의하여 인식이 최종인지 확인합니다.
            var isFinal = false
            if result != nil {
                //결과가 nil이 아닌 경우 textView.text 속성을 결과의 최상의 텍스트로 설정합니다. 결과가 최종 결과이면 isFinal을 true로 설정하십시오.
                self.DescTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            //오류가 없거나 최종 결과가 나오면 audioEngine (오디오 입력)을 중지하고 인식 요청 및 인식 작업을 중지합니다. 동시에 녹음 시작 버튼을 활성화합니다.
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.button.isEnabled = true
            }
        })
        
        //recognitionRequest에 오디오 입력을 추가하십시오. 인식 작업을 시작한 후에는 오디오 입력을 추가해도 괜찮습니다. 오디오 프레임 워크는 오디오 입력이 추가되는 즉시 인식을 시작합니다.
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        // Prepare and start the audioEngine.
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        DescTextView.text = "아무거나 말해보세요!"
        
    }
    
    func getCurrentLocation(){

        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        
        print("latitude : " + String(describing: coor!.latitude) + "/ longitude : " + String(describing: coor!.longitude))
        
        //좌표를 grid 로 변경해서 날씨 데이터 가져오도록 함
        var gridData = convertGRID_GPS(lat_X: coor!.latitude, lng_Y: coor!.longitude)
        
        //현재 주소 가져오기
        let findLocation = CLLocation(latitude : coor!.latitude, longitude : coor!.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler:
            {(placemarks, error) in
                if let address: [CLPlacemark] = placemarks { if let name: String = address.last?.name
                {
                    print("getLocation() :  \(name)")
                    self.weatherTextField.text?.append(" - \(name) ")
                    self.updateWeatherInfo(lat : gridData.lat, lng : gridData.lng, nx : String(gridData.x), ny : String(gridData.y))
                    //전달 받은 데이터로 날씨 정보 업데이트 함
                  
                    }
                    
                } })
        //주소 가지고 오는 부분이 날씨보다 느려서 delay 추가
        sleep(1)
        
    }
    
    func updateWeatherInfo(lat: Double, lng : Double, nx: String, ny : String){
        let date = Date() // --- 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // --- 2
        let stringDate = dateFormatter.string(from: date) // --- 3
        var intdate = Int(stringDate)
        
        //http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/ForecastSpaceData?serviceKey=YH1dOA3pzcvTd49kZWzlwaQNkwsUMEccHdQS3Pbcwfs3vy9MsMwQy%2FOYEUuMhlDLl68GfERnemKNK%2BNu87WNsg%3D%3D&base_date=20180913&base_time=0200&nx=60&ny=127&numOfRows=100&_type=json
        var url = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/ForecastSpaceData"
        var params = ["serviceKey":"YH1dOA3pzcvTd49kZWzlwaQNkwsUMEccHdQS3Pbcwfs3vy9MsMwQy/OYEUuMhlDLl68GfERnemKNK+Nu87WNsg==",
                      "base_date":stringDate,
                      "base_time":"0200",
                      "nx":nx,
                      "ny":ny,
                      "numOfRows":"100",
                      "_type":"json"]
        
        var min : Int = 0
        var max : Int = 0
        var textResult = ""
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.queryString, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                var response = json["response"]
                var body = response["body"]
                var items = body["items"]
                var item = items["item"]
                item.array?.forEach({ (weatherData) in
                    let data = weatherData
                    
                    var date : String = data["fcstDate"].stringValue
                    if(data["category"] == "TMN" && date == stringDate){
                        min = data["fcstValue"].intValue
                        print("min \(min)")
                    }
                    
                    if(data["category"] == "TMX"){
                        max = data["fcstValue"].intValue
                        print("max \(max)")
                    }
                    
                    if(data["category"] == "SKY" && date == stringDate && data["fcstTime"] == "0900"){
                        var sky = data["fcstValue"].intValue
                        textResult = ""
                        switch(sky){
                        case 0..<3 :
                            textResult = "☀️"
                        case 3..<6 :
                            textResult = "🌤"
                        case 6..<8 :
                            textResult = "⛅️"
                        case 8..<10 :
                            textResult = "🌥"
                        default : textResult = "☀️"
                        }
                        
                        print("하늘 \(textResult)")
                        
                    }
                    
                })

                self.weatherTextField.text?.append("기온 \(min) / ")
                self.weatherTextField.text?.append("\(max) ")
                self.weatherTextField.text?.append(textResult)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    @IBAction func PassThem(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objSecond = storyboard.instantiateViewController(withIdentifier: "vc2") as! AddImageViewController
        objSecond.PTitle = TitleTextField.text!
        objSecond.PDesc = DescTextView.text
        objSecond.PWeather = weatherTextField.text!
        self.navigationController?.pushViewController(objSecond, animated: true)
        
        
    }
    
    func convertGRID_GPS(lat_X: Double, lng_Y: Double) -> LatXLngY {
        let RE = 6371.00877 // 지구 반경(km)
        let GRID = 5.0 // 격자 간격(km)
        let SLAT1 = 30.0 // 투영 위도1(degree)
        let SLAT2 = 60.0 // 투영 위도2(degree)
        let OLON = 126.0 // 기준점 경도(degree)
        let OLAT = 38.0 // 기준점 위도(degree)
        let XO:Double = 43 // 기준점 X좌표(GRID)
        let YO:Double = 136 // 기1준점 Y좌표(GRID)
        
        //
        // LCC DFS 좌표변환 ( code : "TO_GRID"(위경도->좌표, lat_X:위도,  lng_Y:경도), "TO_GPS"(좌표->위경도,  lat_X:x, lng_Y:y) )
        //
        
        let DEGRAD = Double.pi / 180.0
        let RADDEG = 180.0 / Double.pi
        
        let re = RE / GRID
        let slat1 = SLAT1 * DEGRAD
        let slat2 = SLAT2 * DEGRAD
        let olon = OLON * DEGRAD
        let olat = OLAT * DEGRAD
        
        var sn = tan(Double.pi * 0.25 + slat2 * 0.5) / tan(Double.pi * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        var sf = tan(Double.pi * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        var ro = tan(Double.pi * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
        var rs = LatXLngY(lat: 0, lng: 0, x: 0, y: 0)
        
        //        if mode == TO_GRID {
        rs.lat = lat_X
        rs.lng = lng_Y
        var ra = tan(Double.pi * 0.25 + (lat_X) * DEGRAD * 0.5)
        ra = re * sf / pow(ra, sn)
        var theta = lng_Y * DEGRAD - olon
        if theta > Double.pi {
            theta -= 2.0 * Double.pi
        }
        if theta < -Double.pi {
            theta += 2.0 * Double.pi
        }
        
        theta *= sn
        rs.x = Int(floor(ra * sin(theta) + XO + 0.5))
        rs.y = Int(floor(ro - ra * cos(theta) + YO + 0.5))
        //        }
        //        else {
        //            rs.x = Int(lat_X)
        //            rs.y = Int(lng_Y)
        //            let xn = lat_X - XO
        //            let yn = ro - lng_Y + YO
        //            var ra = sqrt(xn * xn + yn * yn)
        //            if (sn < 0.0) {
        //                ra = -ra
        //            }
        //            var alat = pow((re * sf / ra), (1.0 / sn))
        //            alat = 2.0 * atan(alat) - Double.pi * 0.5
        //
        //            var theta = 0.0
        //            if (abs(xn) <= 0.0) {
        //                theta = 0.0
        //            }
        //            else {
        //                if (abs(yn) <= 0.0) {
        //                    theta = Double.pi * 0.5
        //                    if (xn < 0.0) {
        //                        theta = -theta
        //                    }
        //                }
        //                else {
        //                    theta = atan2(xn, yn)
        //                }
        //            }
        //            let alon = theta / sn + olon
        //            rs.lat = alat * RADDEG
        //            rs.lng = alon * RADDEG
        //        }
        return rs
        
        
    }
    
    struct LatXLngY {
        public var lat: Double
        public var lng: Double
        
        public var x: Int
        public var y: Int
    }
}
