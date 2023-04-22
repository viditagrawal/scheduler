//
//  SwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/21/23.
//

import SwiftUI

struct SignUpSwiftUIView: View {
    var body: some View {
        Home()
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpSwiftUIView()
        }
    }

    struct Home: View {
        
        @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
        
        var body: some View{
            VStack{
                if self.status{
                    HomeScreen()
                    
                } else {
                    VStack{
                        SignUp()
                    }
                     .onAppear{
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                            
                            self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        }
                    }
                }
            }
        }
    }

    struct HomeScreen: View{
        var body: some View{
            VStack{
                
                Image("currency").resizable().frame(width: 300.0, height: 225.0, alignment: .center)
                
                Text("Signed in successfully")
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {
                    
//                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }) {
                    
                    Text("Sign out")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("Dominant"))
                .cornerRadius(4)
                .padding(.top, 25)
            }
        }
    }


    
        
//        func Verify(){
//            if self.email != "" && self.pass != ""{
////                Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
//
//                    if err != nil{
//
//                        self.error = err!.localizedDescription
//                        self.title = "Login Error"
//                        self.alert.toggle()
//                        return
//                    }
//
//                    print("Login success!")
//                    UserDefaults.standard.set(true, forKey: "status")
//                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
//                }
//            }else{
//                self.title = "Login Error"
//                self.error = "Please fill all the content property"
//                self.alert = true
//            }
//        }
        
//        func ResetPassword(){
//            if self.email != ""{
//
//                Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
//
//                    if err != nil{
//                        self.alert.toggle()
//                        return
//                    }
//                    self.title = "Password Reset Sucessfully!"
//                    self.error = "A new password is sent to your email!"
//                    self.alert.toggle()
//                }
//            }
//            else{
//
//                self.error = "Email Id is empty"
//                self.alert.toggle()
//            }
        }
    

struct SignUp: View{
    
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    
    @State var color = Color.black.opacity(0.7)
    
    @State var visible = false
    @State var revisible = false
    
    @State var alert = false
    @State var error = ""
    
    let borderColor = Color(red: 107.0/255.0, green: 164.0/255.0, blue: 252.0/255.0)
    
    var body: some View{
        
        NavigationStack{
            VStack(alignment: .leading){
                
                GeometryReader{_ in
                    
                    VStack{
                        Image("finance_app").resizable().frame(width: 300.0, height: 255.0, alignment: .center)
                        
                        Text("Sign up a new account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 15)
                        
                        TextField("Username or Email",text:self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius:6).stroke(self.borderColor,lineWidth:2))
                            .padding(.top, 0)
                        
                        HStack(spacing: 15){
                            VStack{
                                if self.visible {
                                    TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                //Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .opacity(0.8)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 6)
                            .stroke(self.borderColor,lineWidth: 2))
                        .padding(.top, 10)
                        
                        
                        // Confirm password
                        HStack(spacing: 15){
                            VStack{
                                if self.revisible {
                                    TextField("Confirm Password", text: self.$repass)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Confirm Password", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                self.revisible.toggle()
                            }) {
                                //Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .opacity(0.8)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 6)
                            .stroke(self.borderColor,lineWidth: 2))
                        .padding(.top, 10)
                        
                        
                        // Sign up button
                        Button(action: {
                            //                        self.Register()
                        }) {
                            Text("Sign up")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(.black)
                        .cornerRadius(6)
                        .padding(.top, 15)
                        .alert(isPresented: self.$alert){()->Alert in
                            return Alert(title: Text("Sign up error"), message: Text("\(self.error)"), dismissButton:
                                    .default(Text("OK").fontWeight(.semibold)))
                        }
                        
                        HStack(spacing: 5){
                            Text("Already have an account?")
                            
                            NavigationLink(destination: MyLoginViewController()){
                                Text("Log in")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            Text("now").multilineTextAlignment(.leading)
                            
                        }.padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
    }
    //        func Register(){
    //            if self.email != ""{
    //
    //                if self.pass == self.repass{
    //
    //                    Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
    //
    //                        if err != nil{
    //
    //                            self.error = err!.localizedDescription
    //                            self.alert.toggle()
    //                            return
    //                        }
    //
    //                        print("success")
    //
    //                        UserDefaults.standard.set(true, forKey: "status")
    //                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
    //                    }
    //                }
    //                else{
    //
    //                    self.error = "Password mismatch"
    //                    self.alert.toggle()
    //                }
    //            }
    //            else{
    //
    //                self.error = "Please fill all the contents properly"
    //                self.alert.toggle()
    //            }
    //
    //        }}
}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpSwiftUIView()
    }
}
struct MyLoginViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC") as? UIViewController else {
                    fatalError("ViewController not implemented in storyboard")
                }
                return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // update the view controller if needed
    }
}


    
