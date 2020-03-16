//
//  CollectionView.swift
//  coronavirusAPI
//
//  Created by nic Wanavit on 3/16/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct CoronaTable: View {
    @EnvironmentObject var coronaDataList:CoronaDataList

    var body: some View {
        GeometryReader { g in
        NavigationView{
            VStack{
            HeaderRow()
                .frame(width: g.size.width, height: g.size.width * 0.038, alignment: .center)
            Form{
                Section{
                    
                    ForEach(self.coronaDataList.data, id: \.self){corona in
                        MainRow(coronaData: corona)
                    }
                }
            }
            }
        .navigationBarTitle("Coronavirus Tracker ")
        }
        }
    }
}

struct CoronaTable_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoronaTable()
            
            CoronaTable()
                .environment(\.colorScheme, .dark)
            }
            .environmentObject(SampleCoronaDataList.coronaData)
    }
}
