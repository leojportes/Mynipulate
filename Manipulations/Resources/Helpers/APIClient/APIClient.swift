//
//  APIClient.swift
//  Manipulations
//
//  Created by Leonardo Portes on 17/09/23.
//

import Foundation
import Network
import UIKit

class APIClient {
    private let networkCheck = NetworkCheck()

    enum Method: String {
        case get = "GET"
        case post = "POST"
        case update = "PUT"
    }

    /// Delete request.
    func performRequestToDelete(
        endpoint: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let loadingView = LoadingView() .. {
            $0.isLoading = true
        }
        addLoadingView(loadingView: loadingView)

        guard let url = URL(string: endpoint) else {
            removeLoadingView(loadingView: loadingView)
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (_, _, error) in
            self.removeLoadingView(loadingView: loadingView)

            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("Deletado com sucesso!"))
            }
        }.resume()
    }

    func performRequest<T: Codable>(
        method: Method,
        endpoint: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        performRequest(method: method, endpoint: endpoint, requestData: nil as Data?, completion: completion)
    }

    func performRequest<T: Decodable>(
        method: Method,
        endpoint: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        performRequest(method: method, endpoint: endpoint, requestData: nil as Data?, completion: completion)
    }

    func performRequest<T: Decodable, U: Encodable>(
        method: Method,
        endpoint: String,
        requestData: U?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {

        // Check if has network conection
        if networkCheck.currentStatus != .satisfied {
            DispatchQueue.main.async {
                let currentController = UIViewController.findCurrentController()
                currentController?.showAlertToSettings()
            }
        }

        let loadingView = LoadingView() .. {
            $0.isLoading = true
        }
        addLoadingView(loadingView: loadingView)
        guard let url = URL(string: endpoint) else {
            self.addAlertError()
            return completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let requestData = requestData {
            do {
                let jsonData = try JSONEncoder().encode(requestData)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                self.addAlertError()
                return completion(.failure(error))
            }
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.addAlertError()
                return completion(.failure(error))
            }

            guard let data = data else {
                self.addAlertError()
                return completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                if let httpResponse = response as? HTTPURLResponse {
                    let requestData = RequestData(
                        statusCode: httpResponse.statusCode,
                        url: httpResponse.url?.description ?? ""
                    )
                    print("URL: ", requestData.url)
                    print("StatusCode: ", requestData.statusCode)
                    print(httpResponse.allHeaderFields)
                    MNUserDefaults.setRequestData(model: requestData, forKey: .requestData)
                }
                self.removeLoadingView(loadingView: loadingView)
                return completion(.success(decodedData))
            } catch {
                self.addAlertError()
                return completion(.failure(error))
            }
        }.resume()
    }

    private func addAlertError(_ message: String = "Algo de errado aconteceu, tente novamente!") {
        DispatchQueue.main.async {
            let currentController = UIViewController.findCurrentController()
            currentController?.showAlert(title: "Oops!", message: message) {
                currentController?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func addLoadingView(loadingView: LoadingView) {
        DispatchQueue.main.async {
            let currentController = UIViewController.findCurrentController()
            currentController?.view.addSubview(loadingView)
            let currentView = currentController?.view ?? UIView()
            loadingView.leftAnchor(in: currentView)
            loadingView.rightAnchor(in: currentView)
            loadingView.topAnchor(in: currentView, layoutOption: .useMargins)
            loadingView.bottomAnchor(in: currentView, layoutOption: .useMargins)
        }
    }

    private func removeLoadingView(loadingView: LoadingView) {
        DispatchQueue.main.async { [weak self] in
            self?.removeLoadingViewWithAnimation(loadingView)
        }
    }

    private func removeLoadingViewWithAnimation(_ loadingView: LoadingView) {
        UIView.animate(withDuration: 0.1, animations: {
            loadingView.alpha = 0.0
        }) { _ in
            loadingView.isLoading = false
            loadingView.removeFromSuperview()
        }
    }
}

protocol NetworkCheckObserver: AnyObject {
    func statusDidChange(status: NWPath.Status)
}

class NetworkCheck {

    struct NetworkChangeObservation {
        weak var observer: NetworkCheckObserver?
    }

    static let shared: NetworkCheck = NetworkCheck()
    private var monitor = NWPathMonitor()

    private var observations = [ObjectIdentifier: NetworkChangeObservation]()
    var currentStatus: NWPath.Status {
        get {
            return monitor.currentPath.status
        }
    }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let observations = self?.observations else { return }
            for (id, observations) in observations {
                // If any observer is nil, remove it from the list of observers
                guard let observer = observations.observer else {
                    self?.observations.removeValue(forKey: id)
                    continue
                }

                DispatchQueue.main.async(execute: {
                    observer.statusDidChange(status: path.status)
                })
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }

    func addObserver(observer: NetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = NetworkChangeObservation(observer: observer)
    }

    func removeObserver(observer: NetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}

public struct RequestData: Codable {
    let statusCode: Int
    let url: String
    // Outros dados relevantes ao seu request
}
