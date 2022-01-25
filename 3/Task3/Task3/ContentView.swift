//
//  ContentView.swift
//  Task3
//
//  Created by Philipp on 25.01.2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var currentDate = ""
    
    var body: some View {
            NavigationView {
            VStack (spacing: 10) {
                Button(action: {
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
                    currentDate = formatter.string(from: date)
                    print(currentDate)
                    print("Date printed")
                }, label: {
                    Text("Get current date")
                })
                NavigationLink(destination: DateTimeView(date:currentDate)) {
                    Text("Show Date")
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    var dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
    }
    static var previews: some View {
        ContentView()
    }
}

struct DateTimeView: View {
    @State var date: String
    @State var university = "РТУ МИРЭА"
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                TextField("University", text: $university)
                    .padding(5)
                NavigationLink(destination: UniversityView(university: university)) {
                    Text("Save data")
                        .fontWeight(.bold)
                }
                Spacer()
                Image(systemName: "globe")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text(date)
            }
        }
    }
}

struct UniversityView: View {
    @State var university = "University"
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.669986, longitude: 37.480409), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("Phone")
                    Spacer()
                    Link("+7 499 215-65-65", destination: URL(string: "tel:+74992156565")!)
                            }.padding(15)
                    Map(coordinateRegion: $region)
                        .frame(width: 400, height: 300)
                    Spacer()
            }
        .navigationBarTitle(university)
        .navigationBarBackButtonHidden(true)

    }
}
