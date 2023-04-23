//
//  LoginSwiftUIView.swift
//  scheduler
//
//  Created by vidit agrawal on 4/22/23.
//

import SwiftUI
import UIKit
import FirebaseAuth

struct LoginSwiftUIView: View {
    var body: some View {
        Login()
        Image("minz")
        
    }
}

struct LoginSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSwiftUIView()
    }
}
struct Login: View{
    
    @State var email = ""
    @State var pass = ""
    @State var color = Color.black.opacity(0.7)
    @State var visible = false
    @State var alert = false
    @State var error = ""
    @State var title = ""
    @State var isActive = false
    let borderColor = Color(red: 107.0/255.0, green: 164.0/255.0, blue: 252.0/255.0)
    
    var body: some View{
        VStack(){
            Image("LeafLogo").frame(width: 300.0, height: 300.0, alignment: .top)
            
            Text("Sign in to your account")
                .font(Font.custom("GT-Walsheim-Pro-Trial-Condensed-Regular", size: 28))
                .fontWeight(.bold)
                .padding(.top, 15)
            
            TextField("Username or Email",text:self.$email)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius:6).stroke(borderColor,lineWidth:2))
                .padding(.top, 0).font(Font.custom("GT-Walsheim-Pro-Trial-Condensed-Regular", size: 16))
            
            HStack(spacing: 15){
                VStack{
                    if self.visible {
                        TextField("Password", text: self.$pass)
                            .autocapitalization(.none).font(Font.custom("GT-Walsheim-Pro-Trial-Condensed-Regular", size: 16))
                    } else {
                        SecureField("Password", text: self.$pass)
                            .autocapitalization(.none).font(Font.custom("GT-Walsheim-Pro-Trial-Condensed-Regular", size: 16))
                    }
                }
                
                Button(action: {
                    self.visible.toggle()
                }) {
                    //Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                        .opacity(0.8)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 6)
                .stroke(borderColor,lineWidth: 2))
            .padding(.top, 5)
            
            HStack{
                Spacer()
                Button(action: {
                    //                        self.ResetPassword()
                    self.visible.toggle()
                }) {
                    Text("Forget Password")
                        .fontWeight(.medium)
                        .foregroundColor(Color("Dominant"))
                }.padding(.top, 10.0).font(Font.custom("GT-Walsheim-Pro-Trial-Condensed-Regular", size: 10))
            }
            
            // Sign in button
            NavigationLink(destination: MyHomeViewController().navigationBarBackButtonHidden(), isActive: $isActive) {
                    EmptyView()
                }
                Button(action: {
                    self.Verify()
                    self.isActive = true // assign value outside closure
                }) {
                Text("Sign in")
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
    
            
            HStack(spacing: 5){
                Text("Don't have an account ?")
                
                NavigationLink(destination: MySignUpViewController()){
                    Text("Sign up")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Text("now").multilineTextAlignment(.leading)
                
            }.padding(.top, 25)
        }
        .padding(.horizontal, 25)
        
    }
    
    func Verify(){
        if self.email != "" && self.pass != ""{
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in

                if err != nil{

                    self.error = err!.localizedDescription
                    self.title = "Login Error"
                    self.alert.toggle()
                    return
                }

                print("Login success!")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }else{
            self.title = "Login Error"
            self.error = "Please fill all the content property"
            self.alert = true
        }
    }
}

struct MySignUpViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpVC") as? UIViewController else {
                    fatalError("ViewController not implemented in storyboard")
                }
                return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // update the view controller if needed
    }
}
