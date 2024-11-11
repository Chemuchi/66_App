//
//  ViewController.swift
//  Bus66
//
//  Created by 정재형 on 11/10/24.
//

import UIKit
//import FLAnimatedImage
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var LoadedTime: UILabel!
    
    @IBOutlet weak var NextBirae: UILabel!
    @IBOutlet weak var PreBirae: UILabel!
    
    @IBOutlet weak var NextPanam: UILabel!
    @IBOutlet weak var PrePanam: UILabel!
    
    @IBOutlet weak var scrollingLabel: UILabel!
    //@IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var gifImageView: SDAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GIF 로딩
        if let gifPath = Bundle.main.path(forResource: "ambersuger_dance", ofType: "gif"){
            let gifURL = URL(fileURLWithPath: gifPath)
            gifImageView.sd_setImage(with: gifURL)
        }
        //앱 로드시 시간 가져오기
        fetchTimes()
        
        //텍스트 스크롤링
        startScrollingText()
    }

    
    //새로고침
    @IBAction func Refresh(_ sender: Any) {
        fetchTimes()
    }
    
    //API 호출
    func fetchTimes() {
            // 불러온 시간 가져오기
            fetchData(from: "http://133.186.217.143/current") { loadedTime in
                DispatchQueue.main.async {
                    self.LoadedTime.text = "불러온 시간: \(loadedTime)"
                }
            }
            
            // 비래동 다음 출발 시간 가져오기
            fetchData(from: "http://133.186.217.143/nextbirae") { nextTime in
                DispatchQueue.main.async {
                    self.NextBirae.text = "다음 출발시간: \(nextTime)"
                }
            }
            
            // 비래동 이전 출발 시간 가져오기
            fetchData(from: "http://133.186.217.143/prebirae") { prevTime in
                DispatchQueue.main.async {
                    self.PreBirae.text = "이전 출발시간: \(prevTime)"
                }
            }
            
            // 판암역 다음 출발 시간 가져오기
            fetchData(from: "http://133.186.217.143/nextpanam") { nextTime in
                DispatchQueue.main.async {
                    self.NextPanam.text = "다음 출발시간: \(nextTime)"
                }
            }
            
            // 판암역 이전 출발 시간 가져오기
            fetchData(from: "http://133.186.217.143/prepanam") { prevTime in
                DispatchQueue.main.async {
                    self.PrePanam.text = "이전 출발시간: \(prevTime)"
                }
            }
    }
    
    
    func startScrollingText() {
        let originalFrame = scrollingLabel.frame
        let screenWidth = UIScreen.main.bounds.width

        // 텍스트가 화면 바깥에서 시작하도록 설정
        scrollingLabel.frame.origin.x = screenWidth

        UIView.animate(withDuration: 5.0, delay: 0, options: [.curveLinear, .repeat], animations: {
            self.scrollingLabel.frame.origin.x = -self.scrollingLabel.frame.width
        }) { _ in
            // 애니메이션이 완료되면 시작 위치로 되돌림
            self.scrollingLabel.frame = originalFrame
        }
    }
    
    
    //데이터 가져오기
    func fetchData(from urlString: String, completion: @escaping (String) -> Void){
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data , var result = String(data: data, encoding: .utf8) else {return}
            
            result = result.replacingOccurrences(of: "\"", with: "")
            
            completion(result)
        }
        task.resume()
    }
    
}

