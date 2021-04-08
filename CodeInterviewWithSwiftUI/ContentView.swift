//
//  ContentView.swift
//  CodeInterviewWithSwiftUI
//
//  Created by James Hillhouse IV on 4/6/21.
//

import SwiftUI




struct ContentView: View {
    // Don't forget that String? == Optional<String> != String
    // Using @AppStorage means that the app, no matter how many versions are launched on a device,
    // say on an iPad or Mac, will reflect the same state of storage. Think of it as a mirror effect.
    //@AppStorage("selectedView") var selectedView: String?

    // @SceneStorage means individual instances of the applications rather than the whole application.
    @SceneStorage("selectedView") var selectedView: String?


    var body: some View {
        NavigationView {
            TabView(selection: $selectedView) {
                TwoSumsView()
                    .tag(TwoSumsView.tag)
                    .tabItem {
                        Text("2Sums")
                            
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
