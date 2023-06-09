//
//  CourseRecSwiftUIView.swift
//  scheduler
//
//  Created by Justin Cao on 4/22/23.
//

import Foundation
import SwiftUI

struct ContentView: View { //p sure this whole class does nothing
    @State private var text = ""

    var body: some View {
        TextField("", text: $text)
            .padding()
            .border(Color.gray)
    }
}

struct CourseRecSwiftUIView: View {
    @State private var text = ""
    
    @State var queriedYet = false
    @State var courses = ["", "", "", "", ""]
    
    
    var body: some View {
        ZStack{
            BackgroundView()
            VStack {
                
                
                Text("Course Finder")
                    .fontWeight(.bold)
                    .padding()
                    .font(Font.custom("GT-Walsheim-Pro-Trial-Medium", size: 35))
                Spacer(minLength: 1)
                TextField("Describe your interests", text: $text, onCommit: {
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
                                        let json = try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as![String:String]
                                        print("Json: ",json)
                                        let sortedKeys = Array(json.keys).sorted(by: >)
                                        print("SortedKeys: ",sortedKeys)
                                        var result = [String]()
                                        for key in sortedKeys
                                        {
                                            print(courseDict[json[key]!]?.description)
    //                                        print(c)
                                            do{
                                                var description = courseDict[json[key]!]?.description
                                                try result.append((json[key]! ?? "") + ": " + (description ?? "No Description") )
                                            }
                                            catch{
                                                result.append(json[key] ?? "")
                                            }
                                            
                                                
                                            
                                        }
                                        self.courses = result
                                        self.queriedYet = true
                                        print(courses)
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
                    RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)
                )
                .shadow(radius: 2)
                Spacer(minLength: 75)
                ScrollView{
                    Text(courses[0])
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1)
                        )
                    Spacer(minLength: 25)
                    Text(courses[1])
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1)
                        )
                    Spacer(minLength: 25)
                    Text(courses[2])
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1)
                        )
                    Spacer(minLength: 25)
                    Text(courses[3])
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1)
                        )
                    Spacer(minLength: 25)
                    Text(courses[4])
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1)
                        )
                }
                .opacity(queriedYet ? 1 : 0)
                .frame(width: CGFloat(300), height: CGFloat(525))
                Spacer(minLength: 50) //was 600
            }
            
        }
        
       
        
    }
    
}


struct BackgroundView: View {
    var body: some View {
        ZStack {
            Image("LeafLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all).opacity(0.2)
            // Add your other UI elements here
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
