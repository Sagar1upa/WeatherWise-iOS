//
//  CitySearchView.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//
import SwiftUI

struct CitySearchView: View {
    @State private var viewModel: CitySearchViewModel

    private let weatherRepository: any WeatherRepository
    private let recommendationsUseCase: any GetActivityRecommendationsUseCase

    init(viewModel: CitySearchViewModel, weatherRepository: any WeatherRepository, recommendationsUseCase: any GetActivityRecommendationsUseCase) {
        _viewModel = State(initialValue: viewModel)
        self.weatherRepository = weatherRepository
        self.recommendationsUseCase = recommendationsUseCase
    }

    var body: some View {
        NavigationStack {
            ZStack {
                background

                content
            }
            .navigationTitle("WeatherWise")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: Binding(
                    get: { viewModel.query },
                    set: { viewModel.updateQuery($0) }
                ), prompt: "Search for a city")
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            idleView
                .transition(.opacity.combined(with: .scale))

        case .searching:
            searchingView
                .transition(.opacity)

        case let .loaded(cities):
            cityList(cities)
                .transition(.opacity)

        case .empty:
            emptyView
                .transition(.opacity.combined(with: .scale))

        case let .failed(error):
            errorView(error)
                .transition(.opacity.combined(with: .scale))
        }
    }

    private var background: some View {
        LinearGradient(colors: [Color.blue.opacity(0.10), Color.indigo.opacity(0.04), Color(.systemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }

    private var idleView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 110, height: 110)
                    .shadow(color: .blue.opacity(0.25), radius: 20, y: 10)

                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 8) {
                Text("Discover Your Perfect Day")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Search a city to discover the best activities for the next 7 days.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 320)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var searchingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)

            Text("Finding cities...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func cityList(_ cities: [City]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(cities.enumerated()), id: \.element.id) { index, city in

                    NavigationLink {
                        ActivityRecommendationsView(city: city, weatherRepository: weatherRepository, recommendationsUseCase: recommendationsUseCase)
                    } label: {
                        cityCard(city)
                    }
                    .buttonStyle(.plain)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeOut(duration: 0.35).delay(Double(index) * 0.04), value: viewModel.state)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
    }

    private func cityCard(_ city: City) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 52, height: 52)

                Image(systemName: "location.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(city.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(city.country)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.tertiary)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 20).fill(.regularMaterial))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.primary.opacity(0.06), lineWidth: 1))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 5)
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)

            VStack(spacing: 6) {
                Text("No Cities Found")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Try searching with a different city name.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func errorView(_ error: AppError) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 42))
                .foregroundStyle(.orange)

            VStack(spacing: 8) {
                Text("Something Went Wrong")
                    .font(.title3)
                    .fontWeight(.bold)

                Text(error.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Try Again") {
                viewModel.retry()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(32)
        .frame(maxWidth: 360)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
