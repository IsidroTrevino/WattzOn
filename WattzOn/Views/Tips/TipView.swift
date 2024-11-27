//
//  TipView.swift
//  WattzOn
//
//  Created by Debanhi Medina on 18/10/24.
//

// TipView.swift

import SwiftUI

struct TipView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var homeViewModel: HomeViewModel // Access HomeViewModel
    @StateObject var tipVM = TipsViewModel()
    @StateObject var tasksVM = DailyTasksViewModel()
    @StateObject var consumptionVM = ConsumptionViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Title
                Text("Tips")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                // Tips List
                ForEach(tipVM.arrTip) { tip in
                    Button(action: {
                        router.navigate(to: .tipDetailView(tip: tip))
                    }) {
                        TipCardView(tip: tip)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                }

                // Tareas diarias
                Text("Tareas diarias")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(tasksVM.tasks.indices, id: \.self) { index in
                            let task = tasksVM.tasks[index]
                            DailyTaskView(task: task)
                                .onTapGesture {
                                    withAnimation {
                                        tasksVM.tasks[index].isCompleted.toggle()
                                        if tasksVM.tasks[index].isCompleted {
                                            homeViewModel.incrementSavings(by: tasksVM.tasks[index].savingsAmount)
                                        } else {
                                            // Optionally, deduct savings if unchecked
                                            homeViewModel.incrementSavings(by: -tasksVM.tasks[index].savingsAmount)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }

                // Consumo por categoría
                Text("Consumo por categoría")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)

                ForEach(consumptionVM.categories) { category in
                    ConsumptionCategoryView(category: category)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }

                Spacer()
            }
        }
        .navigationTitle("Tips")
    }
}
