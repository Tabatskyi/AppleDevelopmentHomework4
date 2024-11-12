import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        var allStudents: [Student] = []
        do {
            let model = try ModelParser(name: "students")
            allStudents = model.getStudents()
        } catch { print(error); }

        let allStudentsVC = StudentListViewController(title: "Students", students: allStudents)
        let navigationController = UINavigationController(rootViewController: allStudentsVC)

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
