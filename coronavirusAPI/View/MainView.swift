//
//  MainView.swift
//  coronavirusAPI
//
//  Created by nic Wanavit on 3/16/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            CoronaCollection()
                .tabItem{
                    Image(systemName: "square.grid.2x2")
                    Text("Corona Collection")
                }
                .tag(0)
            
            
            CoronaTable()
                .tabItem{
                    Image(systemName: "list.dash")
                    Text("Corona List")
                }
                .tag(1)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MainView()
                .environmentObject(SampleCoronaDataList.coronaData)
        }
    }
}
