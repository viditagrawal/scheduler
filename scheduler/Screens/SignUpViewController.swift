//
//  SignUpViewController.swift
//  scheduler
//
//  Created by vidit agrawal on 4/21/23.
//

import UIKit
import SwiftUI
<<<<<<< Updated upstream
=======



func calculateSimilarity(a: [Double], b: [Double]) -> Double {
    let dotProduct = zip(a, b).reduce(0.0, { $0 + $1.0 * $1.1 })
    let normProduct = (sqrt(a.map { $0 * $0 }.reduce(0.0, +)) * sqrt(b.map { $0 * $0 }.reduce(0.0, +)))
    return dotProduct / normProduct
}

let headers = [
  "accept": "application/json",
  "content-type": "application/json",
  "authorization": "Bearer m41doASsy8NROlwnw6TXLIhH0dhXV8XQEaYvYKvk"
]

func getEmbedding(text: String) -> [Double]{
    var embedOutput: [Double] = []
    do {
        let parameters = [
            "texts": [text],
          "truncate": "END"
        ] as [String : Any]

        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.cohere.ai/v1/embed")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
            let stringResponse = String(data: data!, encoding: .utf8)
    //                      print(stringResponse?.split(separator: ":"))
            var firstParse = stringResponse?.split(separator: ":")[3]
            var embedding = firstParse?.split(separator:"[")[0].split(separator:"]")[0].split(separator: ",");
            var embeddingArray: [Double] = []
              print("EMBEDDING: \(embedding)")
            //for j in embedding!{
              //  embeddingArray.append(Double(j)!)
            //}
            print(embeddingArray)
            embedOutput = embeddingArray
          }
        })

        dataTask.resume()
    } catch{
        print("did not do what i wanted")
    }
    return embedOutput
}


>>>>>>> Stashed changes
class SignUpViewController: UIViewController {
    @IBOutlet weak var theContainer : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: SignUpSwiftUIView())
        addChild(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
        // Do any additional setup after loading the view.
    }
    
    var courseDict = [String : Course]()
        
        override func viewWillAppear(_ animated: Bool) {
            let urls = ["https://api.ucsb.edu/academics/curriculums/v3/classes/search?quarter=20232&pageNumber=1&pageSize=500&includeClassSections=true", "https://api.ucsb.edu/academics/curriculums/v3/classes/search?quarter=20232&pageNumber=2&pageSize=500&includeClassSections=true","https://api.ucsb.edu/academics/curriculums/v3/classes/search?quarter=20232&pageNumber=3&pageSize=500&includeClassSections=true", "https://api.ucsb.edu/academics/curriculums/v3/classes/search?quarter=20232&pageNumber=4&pageSize=500&includeClassSections=true", "https://api.ucsb.edu/academics/curriculums/v3/classes/search?quarter=20232&pageNumber=5&pageSize=500&includeClassSections=true"]
            for url in urls {
                let url = URL(string: url)!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "accept")
                request.addValue("3.0", forHTTPHeaderField: "ucsb-api-version")
                request.addValue("JN6ET5dspuidWtBFOoR7vF7ub48OgWCO", forHTTPHeaderField: "ucsb-api-key")
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data returned")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Status code: \(httpResponse.statusCode)")
                    }
                    
                    if let responseString = String(data: data, encoding: .utf8) {
                        //print("Response: \(responseString)")
                    }
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let classes = dict["classes"] as? [[String: Any]] {
                            for classDict in classes {
                                if let quarter = classDict["quarter"] as? String,
                                   let courseId = classDict["courseId"] as? String,
                                   let title = classDict["title"] as? String,
                                   let description = classDict["description"] as? String,
                                   let units = classDict["unitsFixed"] as? Int{
                                    //print("Quarter: \(quarter), Course ID: \(courseId)")
                                    //print("Title: \(title)")
                                    //print("Description: \(description)")
                                    
                                    var temp = Course(title: title, description: description, instructor: "", beginTime: "", endTime: "", unitsFixed: units, courseID: courseId, enrollCode: "")
                                    
                                    
                                    if let classSections = classDict["classSections"] as? [[String: Any]] {
                                        for classSection in classSections{
                                            if let section = classSection["section"] as? String,
                                               let enrolledTotal = classSection["enrolledTotal"] as? Int,
                                               let instructor = classSection["instructors"] as? [[String: Any]],
                                               let times = classSection["timeLocations"] as? [[String: Any]],
                                               let enroll = classSection["enrollCode"] as? String{
                                                //print("  Section: \(section), Enrolled Total: \(enrolledTotal)")
                                                //print(" Enroll Code: \(enroll)")
                                                temp.enrollCode = enroll
                                                for section in instructor{
                                                    if let instr = section["instructor"] as? String{
                                                        //print ("Instructor: \(instr)")
                                                        temp.instructor = instr
                                                    }
                                                }
                                                
                                                for time in times{
                                                    if let begin = time["beginTime"] as? String,
                                                       let end = time["endTime"] as? String{
                                                        //print("Times: \(begin) to \(end)")
                                                        temp.beginTime = begin
                                                        temp.endTime = end
                                                    }
                                                }
                                                
                                                self.courseDict[temp.enrollCode] = temp
                                                
                                                
                                                
                                            }
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    
                }
                task.resume()
            }
            sleep(3)
            print(self.courseDict.count)
            for (title, course) in self.courseDict{
                print(title)
            }
        }
<<<<<<< Updated upstream
    
=======
>>>>>>> Stashed changes

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
