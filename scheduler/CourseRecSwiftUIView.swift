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
                        print(dataString)
                    }
                    if let error = error {
                        // Handle HTTP request error
                    } else if let data = data {
                        // Handle HTTP request response
                    } else {
                        // Handle unexpected error
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
            Spacer(minLength: 600)
        }
        
        
    }
}

struct CourseRecSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CourseRecSwiftUIView()
    }
}
