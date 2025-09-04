//
//  LaunchViewModelFlowTests.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import Foundation
import Testing
@testable import PuppyQuiz

@MainActor
struct LaunchViewModelFlowTests {

    @Test
    func loadInitialData_success_warmsCache_andSeedsItems() async throws {
        let serviceBackup = BreedListService.service
        let networkBackup = Network.client
        defer {
            BreedListService.service = serviceBackup
            Network.client = networkBackup
        }

        BreedListService.service = BreedListService()

        let mock = MockNetwork()
        mock.providedBreedList = BreedList(
            message: ["hound": ["plott"], "malinois": []],
            status: "success"
        )
        mock.randomImages = [
            RandomImage(message: "https://images.dog.ceo/breeds/malinois/n02105162_4120.jpg", status: "success"),
            RandomImage(message: "https://images.dog.ceo/breeds/hound-plott/hhh-23456.jpg", status: "success"),
            RandomImage(message: "https://images.dog.ceo/breeds/malinois/n02105162_5000.jpg", status: "success"),
        ]
        Network.client = mock

        let viewModel = LaunchViewModel()
        await viewModel.loadInitialData()

        #expect(viewModel.hasError == false)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.initialQuizItems.count >= 3)
        // Ensure options are created for at least one item
        #expect(viewModel.initialQuizItems.contains(where: { !$0.options.isEmpty }))
    }

    @Test
    func loadInitialData_failure_setsErrorAndStopsLoading() async {
        let serviceBackup = BreedListService.service
        defer { BreedListService.service = serviceBackup }

        BreedListService.service = FailingBreedListService()

        let viewModel = LaunchViewModel()
        await viewModel.loadInitialData()

        #expect(viewModel.hasError == true)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.initialQuizItems.isEmpty)
    }
}
