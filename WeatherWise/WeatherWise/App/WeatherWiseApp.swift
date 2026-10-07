//
//  WeatherWiseApp.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import SwiftUI

@main
struct WeatherWiseApp: App {
    @State private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            CitySearchView(viewModel: CitySearchViewModel(searchCitiesUseCase: container.searchCitiesUseCase))
        }
    }
}
