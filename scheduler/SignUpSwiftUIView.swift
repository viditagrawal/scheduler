//
//  SwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/21/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import UIKit

struct SignUpSwiftUIView: View {
    @State var email = ""
   @State var pass = ""
   @State var color = Color.black.opacity(0.7)
   @State var visible = false
   @State var alert = false
   @State var error = ""
   @State var title = ""
    
    var body: some View {
        Home()
        let image = UIImage(named: "minz")
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
//                if self.status{
//                    NavigationView {
//                        NavigationLink(destination: MyHomeViewController()){ Text("continue")
//
//                        }
//                    }
//                } else {
                    VStack{
                        
                        SignUp()
                    }
                     .onAppear{
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                            
                            self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        }
                    }
                }
//            }
        }
    }

        
    func ResetPassword(){
        if self.email != ""{

            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in

                if err != nil{
                    self.alert.toggle()
                    return
                }
                self.title = "Password Reset Sucessfully!"
                self.error = "A new password is sent to your email!"
                self.alert.toggle()
            }
        }
        else{

            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
    

struct SignUp: View{
    
    @State var email = ""
    @State var pass = ""
    @State var name = ""
    @State var perm = ""
    @State var user = ""
    
    @State var color = Color.black.opacity(0.7)
    
    @State var visible = false
    @State var revisible = false
    
    @State var alert = false
    @State var error = ""
    @State var isActive = false
    let borderColor = Color(red: 107.0/255.0, green: 164.0/255.0, blue: 252.0/255.0)
    
    var body: some View{
        
        NavigationView{
            VStack(alignment: .leading){
                
                GeometryReader{_ in
                    
                    VStack{
                        Image("minzLogo").frame(width: 300, height: 155, alignment: .center).aspectRatio(contentMode: .fit)     
                        
                        Text("Sign up a new account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 0)
                        
                        TextField("Full Name",text:self.$name)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius:6).stroke(self.borderColor,lineWidth:2))
                            .padding(.top, 4)
                        
                        TextField("Username",text:self.$user)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius:6).stroke(self.borderColor,lineWidth:2))
                            .padding(.top, 10)
                        
                        TextField("Email",text:self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 6)
                            .stroke(self.borderColor,lineWidth: 2))
                        .padding(.top, 10)
                        
                        TextField("Id Number",text:self.$perm)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 6)
                            .stroke(self.borderColor,lineWidth: 2))
                        .padding(.top, 10)
                        
                        
                        
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
                        
                        
                        
                        
                        // Sign up button
                        VStack {
                            NavigationLink(destination: MyHomeViewController().navigationBarBackButtonHidden(), isActive: $isActive) {
                                    EmptyView()
                                }
                                Button(action: {
                                    self.Register()
                                    self.isActive = true // assign value outside closure
                                }) {
                                Text("Sign up")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                }.background(.black)
                                .cornerRadius(6)
                                .padding(.top, 15)
                                .alert(isPresented: self.$alert){()->Alert in
                                    return Alert(title: Text("Sign up error"), message: Text("\(self.error)"), dismissButton:
                                            .default(Text("OK").fontWeight(.semibold)))
                                }
                            }
                            
                        
                        HStack(spacing: 5){
                            Text("Already have an account?")
                            
                            NavigationLink(destination: MyLoginViewController()){
                                Text("Log in")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            Text("now").multilineTextAlignment(.leading)
                            
                        }.padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
    }
    func Register(){
        
        if self.email != ""
        {
            Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                signIn(email: self.email, password: self.pass, completion: {_ in 
                    let db = Firestore.firestore()
                    print("please")
                    if let curruser = Auth.auth().currentUser{
                        let uid = curruser.uid
                        print(uid)
                        db.collection("data").document(uid).setData([
                            "perm": self.perm,
                            "name": self.name,
                            "email": self.email,
                            "user" : self.user,
                            "courses": []
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                })
                print(Auth.auth().currentUser?.uid)
            }
            
            
            
        }
        else{

            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }

    }}
}

func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        if let error = error {
            completion(.failure(error))
        } else if let result = result {
            completion(.success(result))
        }
    }
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

struct MyHomeViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeVC") as? UIViewController else {
                    fatalError("ViewController not implemented in storyboard")
                }
                return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // update the view controller if needed
    }
}


    

