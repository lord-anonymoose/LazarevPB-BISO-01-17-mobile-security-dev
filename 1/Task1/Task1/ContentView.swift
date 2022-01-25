//
//  ContentView.swift
//  Task1
//
//  Created by Philipp on 25.01.2022.
//

import SwiftUI

class Contact {
    var image: String
    var firstName: String
    var lastName: String
    var organisation: String
    var phone: String
    var email:String
    
    init() {
        image = "tcook"
        firstName = "Tim"
        lastName = "Cook"
        organisation = "Apple Inc."
        phone = "1-800-275-2273"
        email = "tcook@apple.com"
    }
}

var contact: Contact  = Contact()


struct ContentView: View {
    var body: some View {
        VStack {
            Image(contact.image)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                    
            HStack {
                Text("\(contact.firstName) \(contact.lastName)")
                    .font(.largeTitle)
            }
            
            HStack {
                Text("Organisation")
                Spacer()
                Text(contact.organisation).foregroundColor(.gray)
            }.padding(.bottom, 5)
            
            HStack {
                Image(systemName: "phone.fill")
                Text("Phone")
                Spacer()
                Link(contact.phone, destination: URL(string: "tel:\(contact.phone)")!)
            }.padding(.bottom, 5)
                    
            HStack {
                Image(systemName: "envelope.fill")
                Text("Email")
                Spacer()
                Link(contact.email, destination: URL(string: "mailto:\(contact.email)")!)
            }.padding(.bottom, 5)
                    
            Spacer()
            
            Button(action: { print("Action cancelled!")}) {
                HStack {
                    Image(systemName: "clear")
                    Text("Cancel")
                }.foregroundColor(.red)
            }
        }.padding(40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
