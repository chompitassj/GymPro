import UIKit

class DetalleMiembroViewController: UIViewController {
    
    @IBOutlet weak var lblDni: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblApellido: UILabel!
    @IBOutlet weak var lblEdad: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblFechaInicio: UILabel!
    @IBOutlet weak var lblSexo: UILabel!
    @IBOutlet weak var imgMiembro: UIImageView!
  
    // Variable que recibe el miembro seleccionado desde MiembrosViewController
    var bean: MiembroEntity!
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarDatos() // Cargo los datos del miembro
    }
    
    // Se ejecuta cada vez que aparece la pantalla
    // Así se actualizan los datos cuando vuelvo de editar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarDatos() // Recargo los datos actualizados
    }
    // Método que carga y muestra los datos del miembro en los labels
    func cargarDatos() {
            lblDni.text = "DNI: \(bean.dni ?? "")"
            lblNombre.text = "NOMBRE: \(bean.nombre ?? "")"
            lblApellido.text = "APELLIDO: \(bean.apellido ?? "")"
            lblEdad.text = "EDAD: \(bean.edad)"
            lblPlan.text = "PLAN: \(bean.plan ?? "")"
            lblFechaInicio.text = "INICIO: \(bean.fechaInicio ?? "")"
            lblSexo.text = "SEXO: \(bean.sexo ?? "")"
        // Muestro la imagen según el sexo del miembro
        if bean.sexo == "Masculino" {
                imgMiembro.image = UIImage(named: "Hombre")
            } else {
                imgMiembro.image = UIImage(named: "Mujer")
            }
        }
    
    @IBAction func btnEditar(_ sender: UIButton) {
           performSegue(withIdentifier: "editarMiembro", sender: nil)
       }
       
    // Método que se ejecuta antes de navegar a otra pantalla
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "editarMiembro" {
               // Creo objeto de EditarMiembroViewController
               let v2 = segue.destination as! EditarMiembroViewController
               // Paso el miembro actual a la pantalla de edición
               v2.bean = bean
           }
       }
    // Botón ELIMINAR — muestra confirmación antes de eliminar
    @IBAction func btnEliminar(_ sender: UIButton) {
        let ventana = UIAlertController(title: "GymPro",
                                        message: "¿Seguro que deseas eliminar este miembro?",
                                        preferredStyle: .alert)
        // Si acepta elimina el miembro de CoreData
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: { _ in
            let resu = MiembroController().delete(bean: self.bean)
            if resu == 1 {
                self.dismiss(animated: true) // Regresa al listado
            } else {
                self.mensaje(men: "Error al eliminar el miembro")
            }
        }))
        // Si cancela cierra la alerta sin eliminar
        ventana.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(ventana, animated: true)
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // Muestra una alerta con un mensaje de error
    func mensaje(men: String) {
        let ventana = UIAlertController(title: "GymPro", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(ventana, animated: true)
    }
}
