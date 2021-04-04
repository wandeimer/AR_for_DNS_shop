import Foundation
import UIKit

final class NewsCoordinator: BaseCoordinator{
    weak var navigationController: UINavigationController?
    weak var delegate: NewsToAppCoordinatorDelegate?
    
    override func start() {
        super.start()
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        if let container = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            print("OK")
            container.coordinatorDelegate = self
            navigationController?.pushViewController(container, animated: false)
        }
        else {
            print("Not OK")
        }
    }
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
}

protocol NewsCoordinatorDelegate {
    func navigateToFlutter()
}

extension NewsCoordinator: NewsCoordinatorDelegate{
    func navigateToFlutter(){
        self.delegate?.navigateToFlutterViewController()
    }
}
