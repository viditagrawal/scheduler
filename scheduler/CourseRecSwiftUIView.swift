//
//  CourseRecSwiftUIView.swift
//  scheduler
//
//  Created by Justin Cao on 4/22/23.
//

import Foundation
import SwiftUI


struct ContentView: View {
    @State private var text = ""

    var body: some View {
        TextField("Enter text here", text: $text)
            .padding()
            .border(Color.gray)
    }
}

var courses : [String] = []

struct CourseRecSwiftUIView: View {
    @State private var text = ""
    var body: some View {
        VStack {
            Text("NLP Course Search")
                .fontWeight(.bold)
                .padding()
                .font(Font.custom("Helvetica", size: 35))
            Spacer(minLength: 1)
            TextField("Enter text here", text: $text, onCommit: {
                // handle the input value here
                let url = URL(string: "http://149.142.226.188:5000")!
                var request = URLRequest(url: url)
                let postString = "text=\(text)"
                request.httpMethod = "POST"
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let data = data, let dataString = String(data: data, encoding: .utf8)
                    {
                        //print(type(of:dataString))
                        if let jsonData = dataString.data(using: .utf8){
                            
                            let json = try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [String: String]
                            
                            // extract the non-decimal values into an array
                            var result = [String]()
                            for (_, value) in json {
                                print(value)
                                result.append(value)
                            }
                            print(dataString)
                            print(result)
                        }
                        if let error = error {
                            // Handle HTTP request error
                        } else if data != nil {
                            // Handle HTTP request response
                        } else {
                            // Handle unexpected error
                        }
                    }
                    
                    
                }
                task.resume()
                
                })
            .padding(.horizontal, 5)
            .frame(width: CGFloat(300), height: CGFloat(50))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
            )
            .shadow(radius: 2)
            Spacer(minLength: 50)
            
            Spacer(minLength: 600)
        }
        
        
    }
}


//
//var courseView = CourseRecSwiftUIView()
//var observedArray: [String] = [] {
//    didSet {
//        // Loop through the elements in the array
//        for element in observedArray {
//            // Check if the element already has a corresponding label in the view
//            if myView.viewWithTag(element.hashValue) == nil {
//                // If not, create a new label with the element as the text and add it to the view
//                let newLabel = UILabel()
//                newLabel.text = element
//                newLabel.tag = element.hashValue
//                myView.addSubview(newLabel)
//            }
//        }
//    }
//}
//
//observedArray = myArray


struct CourseRecSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CourseRecSwiftUIView()
    }
}
