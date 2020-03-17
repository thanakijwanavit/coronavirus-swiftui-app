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

struct MainRow: View {
    @State var coronaData:CoronaData
    
    var body: some View {
        GeometryReader { g in
            HStack(alignment: .firstTextBaseline ,spacing:g.size.width/20){
                Text(self.coronaData.country)
                    .frame(width: g.size.width/5, alignment: .leading)
                    .font(.system(size: g.size.width * 0.038, weight: .semibold, design: .rounded))
                Text(self.coronaData.infections.string)
                    .frame(width: g.size.width/5)
                Text(self.coronaData.death.string)
                    .frame(width: g.size.width/5)
                Text(self.coronaData.recovered.string)
                    .frame(width: g.size.width/5)

                }
                .padding()
                .font(.system(size: g.size.width * 0.038, weight: .light, design: .rounded))
        }
    }
}
struct HeaderRow: View {
    
    var body: some View {
        GeometryReader { g in
            HStack(alignment: .firstTextBaseline ,spacing:g.size.width/20){
                Text("Country")
                    .frame(width: g.size.width/5, alignment: .leading)
                Text("Infection")
                    .frame(width: g.size.width/5)
                Text("Death")
                    .frame(width: g.size.width/5)
                Text("Recovered")
                    .frame(width: g.size.width/5)

                }
                .padding()
                .font(.system(size: g.size.width * 0.038, weight: .bold, design: .rounded))
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
