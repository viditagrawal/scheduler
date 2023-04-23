//
//  FriendRecSwiftUIView.swift
//  scheduler
//
//  Created by Justin Cao on 4/23/23.
//

import Foundation
import SwiftUI


struct Friend: Identifiable{
    var id: UUID = UUID()
    var name:String
    var mutualFriends:Int
    var username:String
}
struct FriendRecSwiftUIView: View {
    var friends:[Friend] = [
        Friend(name: "JOE", mutualFriends: 2, username: "SDS"),
        Friend(name: "BOB", mutualFriends: 25, username: "DFSD"),
        Friend(name: "BOB", mutualFriends: 25, username: "DFSD"),
        Friend(name: "BOB", mutualFriends: 25, username: "DFSD"),
        Friend(name: "BOB", mutualFriends: 25, username: "DFSD"),
        Friend(name: "BOB", mutualFriends: 25, username: "DFSD"),
        Friend(name: "asas", mutualFriends: 21, username: "FD")]
    
    var body: some View {
        NavigationView {
            ScrollView{
                ForEach(friends, id: \.id) {friend in
                    FriendRow(friend: friend ).previewLayout(.sizeThatFits).padding()
                    
                }
                
            }.navigationBarTitle("Friends")
            
            
            Text("hello")
        }
    }
}


struct FriendRecSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRecSwiftUIView()
    }
}

struct FriendRow: View {
    var friend:Friend
    var body: some View {
        NavigationLink(destination: Text(friend.name)){
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    
                    VStack (alignment: .leading){
                        Text(friend.name)
                            .foregroundColor(.primary)
                        Text("\(friend.mutualFriends) mutual friends").foregroundColor(.secondary)
                    }
                    HStack{
                        Button(action: {
                            print("add Friend")
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5).frame(height: 35).foregroundColor(.blue)
                                Text("Add friend").font(.system(size:13)).foregroundColor(.white)
                            }
                            
                        }
                        Button(action: {
                            print("Remove")
                        }) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 5).frame(height: 35).foregroundColor(.gray)
                                Text("Remove").font(.system(size:13)).foregroundColor(.white)
                            }
                        }
                        Spacer(minLength: 150)
                    }
                }
                
            }
        }
    }
}
