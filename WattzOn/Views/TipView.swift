//
//  TipView.swift
//  WattzOn
//
//  Created by Debanhi Medina on 18/10/24.
//

import SwiftUI
import Charts

struct TipView: View {
    @EnvironmentObject var router: Router
    
    @State var tipVM = TipsViewModel()
    
    var body: some View {
        VStack {
            Text("Tips")
                .font(.title)
                .multilineTextAlignment(.trailing)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                ForEach(tipVM.arrTip) { tip in
                    Button(action: {
                        router.navigate(to: .tipDetailView(tip: tip))
                    }) {
                        Text(tip.tipName)
                            .foregroundColor(.black)
                            .frame(width: 220, height: 90)
                            .background(tip.color.opacity(0.4)) //tip.color
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.3), radius: 7, x: 0, y: 5)
                    }

                    }
                }
                .padding()
            }


            Text("Tareas diarias")
                .font(.system(size: 22, weight: .medium))
                .padding(.top)

            HStack(spacing: 10) {
                ForEach(["Apagar la luz", "No prender el clima", "Cargar electrónicos a las 2pm"], id: \.self) { task in
                    ZStack {
                        Rectangle()
                            .fill(Color.wattz.opacity(0.6))
                            .frame(width: 120, height: 100)
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                        Text(task)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(.top)
            Spacer()
            
            VStack(spacing: 20) {
                
                HStack{
                    Image(systemName: "moon")
                        .padding()
                    Text("Ahorro de luz")
                        .padding(.horizontal, 3)
                    Spacer()
                    Image("doughnut")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(.leading)
                    Spacer()
                }
                .frame(width: 300 , height: 50)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.yellow.opacity(0.2)))
                .cornerRadius(10)
                .shadow(radius: 10)
                
                HStack{
                    Image(systemName: "house")
                        .padding()
                    Text("Uso de electrodomésticos")
                        .padding(.horizontal, 1)
                    Spacer()
                    Image("doughnut")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    Spacer()
                }
                .frame(width: 300 , height: 50)
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.orange.opacity(0.2)))
                .shadow(radius: 10)
                
                HStack{
                    Image(systemName: "star")
                        .padding()
                    Text("Uso de dispositivos")
                        .padding(.horizontal, 3)
                    Spacer()
                    Image("doughnut")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    Spacer()
                }
                .frame(width: 300 , height: 50)
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.2)))
                .shadow(radius: 10)
                
            }
            .padding(.all)

            Spacer()
        }
        .padding()
        .navigationTitle("Tips")
    }
}

#Preview {
    TipView()
        .environmentObject(Router())
}
