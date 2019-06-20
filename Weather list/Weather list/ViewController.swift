//
//  ViewController.swift
//  Weather list
//
//  Created by 宮下翔伍 on 2019/06/16.
//  Copyright © 2019 宮下翔伍. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
   @IBOutlet weak var Spot: UILabel!
    @IBOutlet weak var Wea: UILabel!
    @IBOutlet weak var Min: UILabel!
    @IBOutlet weak var Max: UILabel!
    @IBOutlet weak var Wind: UILabel!
    struct openweather:Decodable {
        let coord : Coord
        let weather : [Weather]
        let base : String
        let main : Main
        let visibility : Int
        let wind : Wind
        let clouds : Clouds
        let dt : Int
        let sys : Sys
        let timezone : Int
        let id : Int
        let name : String
        let cod :Int
    }
    struct Coord:Decodable{
        let lon:Double
        let lat:Double
    }
    struct Weather:Decodable{
        let id:Int
        let main:String
        let description:String
        let icon:String
    }
    struct Main:Decodable{
        let temp:Double
        let pressure:Int
        let humidity:Int
        let temp_Min:Double
        let temp_Max:Double
        
        private enum Codingkeys: String,CodingKey{
            case temp
            case pressure
            case humiidity
            case temp_Min = "temp_min"
            case temp_Max = "temp_max"
        }
    }
    struct Wind:Decodable{
        let speed:Double
        let deg:Int
    }
    struct Clouds:Decodable{
        let all:Int
    }
    struct Sys:Decodable{
        let type:Int
        let id:Int
        let message:Double
        let country:String
        let sunrise:UInt32
        let sunset:UInt32
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
         let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?units=metric&q=Tokyo&APPID=2175e38652cbd59e30e5a095b9db8983")!
        
        //HTTP通信を行う
        let task = URLSession.shared.dataTask(with:url as URL , completionHandler:
            {(data, response, error) in
    
          //dataをアンラップしない為に条件式にする
           if let data = data, let response = response {
                print(response)
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                      print(json?["main"])
                    let main = (json?["main"] as? NSDictionary)!
                    let wind = (json?["wind"] as? NSDictionary)!
                    print(main)
                    print(json?["weather"])
                    let weather:Array<Dictionary<String, Any>> = (json?["weather"] as? Array<Dictionary<String, Any>>)!
                    let weather1:Dictionary<String, Any> = (weather[0] as? Dictionary<String, Any>)!
                   print(weather1["main"])
                    
             print(main["temp"] as? Double)
               let mintemp = Double(main["temp_min"] as? Double ?? 0)
               let maxtemp = Double(main["temp_max"] as? Double ?? 0)
                    let speed = Double(wind["speed"] as? Double ?? 0)
                   //ラベルの非同期を行う。
                    DispatchQueue.main.async {
                self.Spot.text = json?["name"] as? String ?? ""
                self.Wind.text = String(speed)
                self.Max.text = String("\(maxtemp)")
                self.Min.text = String("\(mintemp)")
                self.Wea.text = weather1["main"] as? String ?? ""
                    }
                   
                }catch{
                    print("Serialize Error")
                }
            }else{
                print(error ?? "Error")
            }
        })
        task.resume()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

