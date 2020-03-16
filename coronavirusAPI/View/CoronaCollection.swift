//
//  ContentView.swift
//  coronavirusAPI
//
//  Created by nic Wanavit on 3/16/20.
//  Copyright © 2020 tenxor. All rights reserved.
//

import SwiftUI

struct CoronaCollection: View {
    @EnvironmentObject var coronaDataList:CoronaDataList
    var body: some View {
        GeometryReader { g in
        NavigationView{
            VStack{
            Form{
                Section{
                    ForEach(0..<self.coronaDataList.data.count/2 , id: \.self){firstIndex in
                        CollectionCell(width: g.size.width-20, index_: firstIndex)
                    }
                    .padding(.bottom)
                }
            }
            }
        .navigationBarTitle("Coronavirus Tracker ")
        }
        }
    }
}

struct CollectionCell:View {
    @EnvironmentObject var coronaDataList:CoronaDataList
    var width: CGFloat
    var index_:Int
    var corona:CoronaData{let mutableself = self; return mutableself.coronaDataList.data[index_]}
    var body: some View {
        VStack(spacing: 20){
            Text(self.corona.country)
                .font(.largeTitle)
                .frame(width: width-50, alignment: .center)
            
            HStack{
                HStack {
                    Text("infections:    ")
                    Text("\(self.corona.infections)")
                    .foregroundColor(.orange)
                }
                .frame(width: width/2, alignment: .leading)
                HStack {
                    Text("death:        ")
                    Text("\(self.corona.death)")
                        .foregroundColor(.gray)
                }
                .frame(width: width/2, alignment: .leading)
            }
            HStack{
                HStack {
                    Text("Still Infected:")
                    Text("\(self.corona.infections - self.corona.death - self.corona.recovered)")
                    .foregroundColor(.red)
                }
                .frame(width: width/2, alignment: .leading)
                
                
                
                HStack {
                    
                    Text("recovered:")
                    Text("\(self.corona.recovered)")
                    .foregroundColor(.green)
                }
                .frame(width: width/2, alignment: .leading)

            }
        }
        .font(.headline)
        .frame(width: width, alignment: .leading)
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


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                CoronaCollection()
                
                CoronaCollection()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS"))
                .previewDisplayName("iPhone XS")
                
                CoronaCollection()
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
            }
            Group {
                CoronaCollection()
                
                CoronaCollection()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS"))
                .previewDisplayName("iPhone XS")
                
                CoronaCollection()
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
            }
            .environment(\.colorScheme, .dark)
        }
            .environmentObject(SampleCoronaDataList.coronaData)
        
    }
}
#endif

class SampleCoronaDataList{
    static var totalCases = 0
    static var coronaData = CoronaDataList(coronaData: data)
    static var data:[CoronaData] = [
        CoronaData(country: "England", infections: 39, death: 1, recovered: 2),
        CoronaData(country: "myanmar", infections: 200, death: 9, recovered: 8),
        CoronaData(country: "US", infections: 500, death: 2, recovered: 2),
        CoronaData(country: "China", infections: 412, death: 42, recovered: 2),
    ]
}

class CoronaDataList: ObservableObject{
    
    
    @Published var data:[CoronaData]
    @Published var totalCases:Int = 2
    
    func update(){
        DispatchQueue.global(qos: .background).async {
            CoronaAPIFunctions.updateData(coronaDataList: self)
        }

    }
    
    init(coronaData:[CoronaData]) {
        self.data = coronaData
    }
}

struct CoronaData : Hashable {
    var country: String
    var infections: Int
    var death: Int
    var recovered: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
    }
}
