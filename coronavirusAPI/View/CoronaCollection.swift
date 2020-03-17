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
                    ForEach(0..<self.coronaDataList.data.count , id: \.self){firstIndex in
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
            HStack{
                ImageCell(imageName: self.corona.code)
                Text(self.corona.country)
                    .font(.largeTitle)
                
            }
                .frame(width: width-50, alignment: .leading)
            
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

class ImageLoader: ObservableObject{
    @Published var image:UIImage
    
    init(imageName:String) {
        self.image = UIImage(named: "US")!
        self.updateImage(imageName: imageName) { (image) in
            guard let image = image else { debugPrint("updateImage returns nil");return}
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    func updateImage(imageName:String, completion: @escaping (UIImage?)->Void){
        DispatchQueue.global(qos: .background).async {
            if let image = FlagApiFunctions.getFlag(name: imageName){
                completion(image)
            }
            else {
                debugPrint("error loading image")
            }
        }
    }
}



struct ImageCell: View{
    @ObservedObject var imageLoader :ImageLoader
    
    init(imageName:String){
        self.imageLoader = ImageLoader(imageName: imageName)
    }
    
    var body: some View {
        Image(uiImage: imageLoader.image)
            .padding()
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
    var code:String = "US"
    var flag: UIImage = UIImage(named: "US")!
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
    }
}
