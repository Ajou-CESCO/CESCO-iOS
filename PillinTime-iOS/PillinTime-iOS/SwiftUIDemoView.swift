//
//  SwiftUIDemoView.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/16/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State var tabSelection: Int = 0
    @State var tabArray = ["Profile", "Settings"]
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection){
                ForEach(0 ..< tabArray.count, id: \.self) { indexValue in
                    NavigationLink(destination: DetailView()){
                        VStack{
                            Text("\(tabArray[indexValue]) tab -- Click to jump next view")
                        }
                    }
                    .tabItem {
                        Image(systemName: "\(indexValue).circle.fill")
                        Text(tabArray[indexValue])
                    }
                    .tag(indexValue)
                    
                }
            }
            .navigationBarTitle(tabArray[tabSelection])
        }
    }
}
struct DetailView: View {
    var body: some View {
        Text("Detail View")
//            .navigationBarTitle("NavigatedView")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitle("helllo")
    }
}

#Preview {
    TabBarView()
}
