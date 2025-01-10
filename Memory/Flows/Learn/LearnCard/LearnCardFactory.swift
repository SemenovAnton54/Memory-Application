//
//  LearnCardFactory.swift
//  Memory
//

import AVFoundation

struct LearnCardFactory {
    enum LearnMode {
        case learnNew
        case review
    }

    struct Arguments {
        let folderId: Int
        let mode: LearnMode
    }

    struct Dependencies {
        let speechUtteranceService: SpeechUtteranceServiceProtocol
        let appEventsClient: AppEventsClientProtocol
        let rememberItemsService: RememberItemsServiceProtocol
    }

    let dependencies: Dependencies

    func makeStore(
        arguments: Arguments,
        router: LearnCardRouterProtocol
    ) -> DefaultStateMachine<LearnCardState, LearnCardEvent, LearnCardViewState> {
        let learnService: LearnCardsServiceProtocol

        switch arguments.mode {
        case .learnNew:
            learnService = MemoryApp.learnNewItemsService
        case .review:
            learnService = MemoryApp.reviewItemsService
        }

        let store = DefaultStateMachine(
            initialState: LearnCardState(nextCardRequest: FeedbackRequest(), statisticsRequest: FeedbackRequest()),
            reduce: LearnCardReducer().reduce,
            present: LearnCardPresenter().present,
            feedback: [
                makeRoutingLoop(router: router),
                makeFetchNextCardRequestLoop(folder: arguments.folderId, learnService: learnService),
                makeCardItemForgottenRequestLoop(learnService: learnService),
                makeCardItemRememberedRequestLoop(learnService: learnService),
                makePlayTextRequestLoop(),
                makeRememberItemEventsLoop(),
                makeFetchUpdateCardRequestLoop(),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias LearnCardFeedbackLoop = FeedbackLoop<LearnCardState, LearnCardEvent>

extension LearnCardFactory {
    func makeRememberItemEventsLoop() -> LearnCardFeedbackLoop {
        feedbackLoop { _ in
            dependencies
                .appEventsClient
                .subscribe(for: RememberItemEvent.self)
                .compactMap { event in
                    switch event {
                    case let .rememberItemUpdated(id), let .rememberItemDeleted(id):
                        .rememberItemUpdated(id: id)
                    default:
                        nil
                    }
                }
                .eraseToAnyPublisher()
        }
    }

    func makeFetchUpdateCardRequestLoop() -> LearnCardFeedbackLoop {
        react(request: \.fetchUpdatedCardRequest) { request in
            do {
                let item = try await dependencies.rememberItemsService.fetchItem(id: request.id)

                return .updatedCardItemFetched(.success(item))
            } catch {
                return .updatedCardItemFetched(.failure(error))
            }
        }
    }

    func makeFetchNextCardRequestLoop(folder: Int, learnService: LearnCardsServiceProtocol) -> LearnCardFeedbackLoop {
        react(request: \.nextCardRequest) { request in
            do {
                let item = try await learnService.fetchCardItem(for: folder, filters: nil)

                return .nextCardItemFetched(.success(item))
            } catch {
                return .nextCardItemFetched(.failure(error))
            }
        }
    }

    func makeCardItemForgottenRequestLoop(learnService: LearnCardsServiceProtocol) -> LearnCardFeedbackLoop {
        react(request: \.cardItemForgottenRequest) { id in
            do {
                let item = try await learnService.itemCardForgotten(id: id)

                return .cardItemRepeatLevelChanged(.success(item))
            } catch {
                return .cardItemRepeatLevelChanged(.failure(error))
            }
        }
    }

    func makeCardItemRememberedRequestLoop(learnService: LearnCardsServiceProtocol) -> LearnCardFeedbackLoop {
        react(request: \.cardItemRememberedRequest) { id in
            do {
                let item = try await learnService.itemCardRemembered(id: id)

                return .cardItemRepeatLevelChanged(.success(item))
            } catch {
                return .cardItemRepeatLevelChanged(.failure(error))
            }
        }
    }

    func makePlayTextRequestLoop() -> LearnCardFeedbackLoop {
        react(request: \.playTextRequest) { text in
            dependencies.speechUtteranceService.play(text)

            return .playingTextStarted
        }
    }
}
