//
//  ContentView.swift
//  Task2
//
//  Created by Philipp on 25.01.2022.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var selectedDate = Date()
    @Environment(\.scenePhase) var scenePhase
    @State private var AppText = "First opened"
    @State var showsAlert = false
    @State var showLoadingView = false
    
    @State var timeRemaining = 10
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init() {
        print("Your app is starting up. App initialiser.")
        requestPermission()
    }
    
    var body: some View {
        LoadingView(isShowing: $showLoadingView) {
            VStack {
                Spacer()
                Text(AppText)
                    .padding()
                Form {
                        DatePicker("Pick Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        Button(action: { showLoadingView = true }) {
                            Text("Loading View")
                                .onReceive(timer) { _ in
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
                                    } else {
                                        showLoadingView = false
                                    }
                                }
                    }
                    }
                Spacer()
                HStack {
                    Image("philipp")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 15, height: 15)
                    Link("Developer", destination: URL(string: "https://github.com/lord-anonymoose")!)
                        .padding(5)
                        .foregroundColor(.gray)
                }
            }
            .alert(isPresented: self.$showsAlert) {
                Alert(title: Text("App resumed"))
            }
            .onChange(of: scenePhase) { newScenePhase in
                  switch newScenePhase {
                  case .active:
                    print("App is active")
                    AppText = "App resumed"
                    self.showsAlert = true
                  case .inactive:
                    print("App is inactive")
                    AppText = "App is inactive"
                  case .background:
                    print("App is in background")
                    AppText = "Working in the background"
                    sendNotification()
                  @unknown default:
                    print("Oh - interesting: I received an unexpected new value.")
                  }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func requestPermission () {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}

func sendNotification () {
    let content = UNMutableNotificationContent()
    content.title = "Still here"
    content.subtitle = "App is working in the background"
    content.sound = UNNotificationSound.default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request)
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
