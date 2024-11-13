import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catImageVC = ViewController()
        catImageVC.tabBarItem = UITabBarItem(title: "Cat Image", image: UIImage(systemName: "photo"), tag: 0)
        
        let breedsVC = BreedsViewController()
        breedsVC.tabBarItem = UITabBarItem(title: "Breeds", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        viewControllers = [UINavigationController(rootViewController: catImageVC), UINavigationController(rootViewController: breedsVC)]
    }
}
