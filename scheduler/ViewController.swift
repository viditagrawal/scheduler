//
//  ViewController.swift
//  scheduler
//
//  Created by vidit agrawal on 4/21/23.
//

import UIKit
import Foundation


// Get the embeddings



// Compare them
func calculateSimilarity(a: [Double], b: [Double]) -> Double {
    let dotProduct = zip(a, b).reduce(0.0, { $0 + $1.0 * $1.1 })
    let normProduct = (sqrt(a.map { $0 * $0 }.reduce(0.0, +)) * sqrt(b.map { $0 * $0 }.reduce(0.0, +)))
    return dotProduct / normProduct
}




struct Class{
    var name: String
    var description: String
    var embedding: [Double]
}
let class1 = Class(name: "CS111", description: "Class about numpy", embedding: [])

var classArray: [Class] = [class1]

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
            for j in embedding!{
                embeddingArray.append(Double(j)!)
            }
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



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var input = "I want to take a class about machine learning"
        var inputEmbed: [Double] = getEmbedding(text: input)
        for i in 0..<(classArray.count){
            print(i)
            var iEmbedding = getEmbedding(text: classArray[i].name + " " + classArray[i].description)
            classArray[i].embedding = iEmbedding
        }
    }


}

