import UIKit

class DetalleEjercicioViewController: UIViewController {
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblMusculo: UILabel!
    @IBOutlet weak var lblDificultad: UILabel!
    @IBOutlet weak var lblInstrucciones: UILabel!
    
    // Variable que recibe el ejercicio seleccionado desde EjerciciosViewController
    var ejercicio: Ejercicio!
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        // Muestro los datos del ejercicio en los labels
        lblNombre.text = "NOMBRE: \(ejercicio.nombre)"
        lblMusculo.text = "MÚSCULO: \(ejercicio.musculo)"
        lblDificultad.text = "DIFICULTAD: \(ejercicio.dificultad)"
        lblInstrucciones.text = ejercicio.instrucciones
        lblInstrucciones.numberOfLines = 0 // Permite mostrar texto en múltiples líneas
    }
    
    // Botón GUARDAR FAVORITO — guarda el ejercicio en CoreData
    @IBAction func btnGuardar(_ sender: UIButton) {
        let salida = EjercicioController().save(bean: ejercicio)
        if salida == 1 {
            mensaje(men: "Ejercicio guardado en favoritos")
        } else {
            mensaje(men: "Error al guardar el ejercicio")
        }
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // Muestra una alerta con un mensaje
    func mensaje(men: String) {
        let ventana = UIAlertController(title: "GymPro", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(ventana, animated: true)
    }
}
