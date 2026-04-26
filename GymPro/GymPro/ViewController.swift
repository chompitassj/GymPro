import UIKit

// Controlador que maneja la pantalla de Login
class ViewController: UIViewController {
    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Botón INGRESAR — valida las credenciales del administrador
    @IBAction func btnIngresar(_ sender: UIButton) {
        // Leo los valores de los TextFields
        let usuario = txtUsuario.text ?? ""
        let password = txtPassword.text ?? ""
        
        // Valido que los campos no estén vacíos
        if usuario.isEmpty || password.isEmpty {
            mensaje(men: "Por favor rellena todos los campos")
            return
        }
        
        // Verifico que el usuario y contraseña sean correctos
        if usuario == "admin" && password == "123456Sa" {
            // Si son correctos navego al Dashboard
            performSegue(withIdentifier: "dashboard", sender: nil)
        } else {
            // Si son incorrectos muestro un mensaje de error
            mensaje(men: "Usuario o contraseña incorrectos")
        }
    }
    
    // Muestra una alerta con un mensaje
    func mensaje(men: String) {
        let ventana = UIAlertController(title: "GymPro", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(ventana, animated: true)
    }
}
