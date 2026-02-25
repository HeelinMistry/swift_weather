//
//  WeatherFavouritesView.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/24.
//

import SwiftUI

public struct WeatherFavouritesView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Binding var selectedTab: Int
    
    public var body: some View {
        if viewModel.favourites.isEmpty {
            Text("No saved places yet.")
        } else {
            
            List {
                ForEach(viewModel.favourites) { location in
                    Button(
                        action: {
                            viewModel.selectLocation(location)
                            selectedTab = 0
                        },
                        label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(location.name).font(.headline)
                                }
                                Spacer()
                            }
                        }
                    )
                }
                .onDelete(perform: viewModel.deleteFavourite)
            }
            .navigationTitle("Saved Places")
        }
    }
}
