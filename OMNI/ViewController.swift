//
//  ViewController.swift
//  OMNI
//
//  Created by Justin  Baskaran on 7/17/22.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var doorToggle: UISegmentedControl!
    @IBOutlet weak var lightsToggle: UISegmentedControl!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var switchPower: UISwitch!
    
    var constants :Constants = Constants();
    
    @IBOutlet weak var BingStatusText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getStatusBing();
        self.volumeSlider.isContinuous=false;
  

    }
    @IBAction func powerButton(_ sender: Any) {
 
        
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        var json=""
        if (self.switchPower.isOn){
            // prepare json data
            json =  "{'commands': [{'component': 'main','capability': 'switch','command': 'on'}]}"
        } else {
            json =  "{'commands': [{'component': 'main','capability': 'switch','command': 'off'}]}"
        }

        doRequest(url: url,data: json)
    }
    
  

    
    
    
    @IBAction func backwardButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = "{'commands':[{'component': 'main','capability': 'mediaPlayback','command': 'rewind'}]}"
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func playButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = "{'commands':[{'component':'main','capability':'mediaPlayback','command':'play'}]}"
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func pauseButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = "{'commands':[{'component':'main','capability':'mediaPlayback','command':'pause'}]}"
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func forwardButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = "{'commands':[{'component': 'main','capability': 'mediaPlayback','command': 'fastForward'}]}"
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func upButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = ""
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func rightButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json datae
        let json = "{'commands':[{'component':'main','capability':'mediaInputSource','command':'SendRemoteKey','argument':'KEY_RIGHT'}]}"
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func downButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = ""
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func leftButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = ""
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = "{\"capability\":\"mediaInputSource\",\"command\":\"setInputSource\"}"
    

        doRequest(url: url,data: json)
    }
    
    @IBAction func onVolumeChanged(_ sender: Any) {
        let value = self.volumeSlider.value;
        
        let url = "https://api.smartthings.com/v1/devices/"+constants.tv+"/commands"

        // prepare json data
        let json = "{\"commands\":[{\"component\":\"main\",\"capability\":\"audioVolume\",\"command\":\"setVolume\",\"arguments\":["+String(Int(floor(Double(value*100))))+"]}]}"
    

        doRequest(url: url,data: json)
              
    }
    
    // Samsung Smart Things Control
    @IBAction func onLightsToggleClick(_ sender: Any) {
        let url = "https://api.smartthings.com/v1/devices/"+constants.lightSwitch+"/commands"

        var json="";
        if (self.lightsToggle.titleForSegment(at: self.lightsToggle.selectedSegmentIndex) == "ON"){
            json = "{\"commands\":[{\"component\":\"main\",\"capability\":\"switch\",\"command\":\"on\"}]}"
        } else {
            json = "{\"commands\":[{\"component\":\"main\",\"capability\":\"switch\",\"command\":\"off\"}]}"
        }
        doRequest(url: url,data: json)

    }
    
    func doRequest(url: String, data: String ) {
        let token = constants.apiToken;
        let url = URL(string: url)!

        // prepare json data
        let json = data;

        // create post request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = json.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
               print(responseJSON)
            }
        }

        task.resume()
    }
    
    
    // Bing Rewards Spammer Function
    func getStatusBing(){
      
        let url = URL(string: self.constants.bingSpammerURL)!
        let task = URLSession.shared.dataTask(with: url) { [self](data, response, error) in
            guard let data = data else { return }
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let stringDate = dateFormatter.string(from: date)
            let valueOfString = String(data: data, encoding: .utf8)!;
            if (valueOfString.range(of: stringDate) != nil){
                DispatchQueue.main.async { [self] in
                    self.BingStatusText.text  = "DONE";
                }
               
            } else {
                DispatchQueue.main.async { [self] in
                    self.BingStatusText.text  = "NOT DONE";
                }
            }
        }
        task.resume()
    }
    
    
 
    
    
    // Stocks Robinhood API
 

}

