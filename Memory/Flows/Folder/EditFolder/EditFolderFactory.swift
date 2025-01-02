//
//  EditFolderFactory.swift
//  Memory
//

import Combine
import PhotosUI
import Photos

struct EditFolderFactory {
    enum EditFolderError: Error {
        case imageNotFound
    }

    struct Dependencies {
        let foldersService: FoldersServiceProtocol
    }

    let dependencies: Dependencies

    func makeStore(id: Int?, router: EditFolderRouterProtocol) -> DefaultMemorizeStore<EditFolderState, EditFolderEvent, EditFolderViewState> {
        var fetchFolderRequest: FeedbackRequest<Int>?

        if let id {
            fetchFolderRequest = .init(id)
        }

        let store = DefaultMemorizeStore(
            initialState: EditFolderState(id: id, fetchFolderRequest: fetchFolderRequest),
            reduce: EditFolderReducer().reduce,
            present: EditFolderPresenter().present,
            feedback: [
                makeLoadImageRequestLoop(),
                makeCreateNewFolderRequestLoop(),
                makeUpdateNewFolderRequestLoop(),
                makeLoadFolderRequestLoop(),
                makeRoutingLoop(router: router),
            ]
        )

        return store
    }
}

typealias EditFolderFeedbackLoop = FeedbackLoop<EditFolderState, EditFolderEvent>

extension EditFolderFactory {
    func makeLoadImageRequestLoop() -> EditFolderFeedbackLoop {
        react(request: \.loadImageRequest) { request in
            do {
                guard let data = try await request.loadTransferable(type: Data.self) else {
                    return .imageLoaded(.failure(EditFolderError.imageNotFound))
                }

                return .imageLoaded(.success(data))
            } catch {
                return .imageLoaded(.failure(error))
            }
        }
    }

    func makeCreateNewFolderRequestLoop() -> EditFolderFeedbackLoop {
        react(request: \.createNewFolderRequest) { newFolder in
            do {
                let model = try await dependencies.foldersService.createFolder(newFolder: newFolder)

                return .folderCreated(.success(model))
            } catch {
                return .folderCreated(.failure(error))
            }
        }
    }

    func makeUpdateNewFolderRequestLoop() -> EditFolderFeedbackLoop {
        react(request: \.updateFolderRequest) { folder in
            do {
                let model = try await dependencies.foldersService.updateFolder(folder: folder)

                return .folderUpdated(.success(model))
            } catch {
                return .folderUpdated(.failure(error))
            }
        }
    }

    func makeLoadFolderRequestLoop() -> EditFolderFeedbackLoop {
        react(request: \.fetchFolderRequest) { id in
            do {
                let model = try await dependencies.foldersService.fetchFolder(id: id)

                return .folderFetched(.success(model))
            } catch {
                return .folderFetched(.failure(error))
            }
        }
    }
}
