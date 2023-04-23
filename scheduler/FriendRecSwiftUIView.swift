//
//  FriendRecSwiftUIView.swift
//  scheduler
//
//  Created by Justin Cao on 4/23/23.
//

import Foundation
import SwiftUI
class FriendDataSource : ObservableObject {
    @Published var friends: [Friend] = []
    
    func addFriend(_ friend: Friend) {
            // Add a new friend to the data source, and update `friends` array
        }
}
struct FriendRecSwiftUIView: View {
    var body: some View {
        Text("hello")
    }
}


struct FriendRecSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRecSwiftUIView()
    }
}
