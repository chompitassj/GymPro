
import UIKit

// UIPickerViewDataSource provee los datos al PickerView
// UIPickerViewDelegate maneja las interacciones del usuario con el PickerView
class EditarMiembroViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtEdad: UITextField!
    @IBOutlet weak var txtFechaInicio: UITextField!
    @IBOutlet weak var txtPlan: UITextField!
    @IBOutlet weak var txtSexo: UITextField!
    
    // Variable que recibe el miembro a editar desde DetalleMiembroViewController
    var bean: MiembroEntity!
    // Opciones del PickerView de plan y sexo
    let planes = ["Mensual", "Trimestral", "Semestral", "Anual"]
    let sexos = ["Masculino", "Femenino"]
    var planSeleccionado = "Mensual"
    var sexoSeleccionado = "Masculino"
    let pickerPlan = UIPickerView() // PickerView para el plan
    let pickerSexo = UIPickerView()
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarDatos() // Cargo los datos actuales del miembro
        configurarPickerPlan() // Configuro el picker de plan
        configurarPickerSexo() // Configuro el picker de sexo
        configurarDatePicker() // Configuro el calendario de fecha
    }
    
    // Método que carga los datos actuales del miembro en los TextFields
    func cargarDatos() {
        txtNombre.text = bean.nombre
        txtApellido.text = bean.apellido
        txtEdad.text = "\(bean.edad)"
        txtFechaInicio.text = bean.fechaInicio
        txtPlan.text = bean.plan
        txtSexo.text = bean.sexo
        planSeleccionado = bean.plan ?? "Mensual" // Plan actual del miembro
        sexoSeleccionado = bean.sexo ?? "Masculino" // Sexo actual del miembro
    }
    
    // Configuro el PickerView de plan como teclado del TextField
    func configurarPickerPlan() {
        pickerPlan.dataSource = self
        pickerPlan.delegate = self
        txtPlan.inputView = pickerPlan // Al tocar txtPlan aparece el picke
    }
    
    // Configuro el PickerView de sexo como teclado del TextField
    func configurarPickerSexo() {
        pickerSexo.dataSource = self
        pickerSexo.delegate = self
        txtSexo.inputView = pickerSexo // Al tocar txtSexo aparece el picker
    }
    
    // Configuro el DatePicker como teclado del TextField de fecha
    func configurarDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels // Estilo rueda
        datePicker.addTarget(self, action: #selector(fechaSeleccionada(_:)), for: .valueChanged)
        txtFechaInicio.inputView = datePicker // Al tocar aparece el calendario
    }
    
    // Se ejecuta cuando el usuario selecciona una fecha en el DatePicker
    @objc func fechaSeleccionada(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtFechaInicio.text = formatter.string(from: datePicker.date)
    }
    
    
    // Método que define cuántas columnas tiene el PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Solo una columna
    }
    
    // Método que define cuántas filas tiene el PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == pickerPlan ? planes.count : sexos.count
    }
    
    // Método que define el texto de cada fila del PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == pickerPlan ? planes[row] : sexos[row]
    }
    
    // Método que se ejecuta cuando el usuario selecciona una opción
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerPlan {
            planSeleccionado = planes[row] // Guardo el plan seleccionado
            txtPlan.text = planes[row] // Muestro el plan en el TextField
        } else {
            sexoSeleccionado = sexos[row] // Guardo el sexo seleccionado
            txtSexo.text = sexos[row]  // Muestro el sexo en el TextField
        }
    }
    
    // Método que valida que el texto solo tenga letras
    func soloLetras(_ texto: String) -> Bool {
        return texto.allSatisfy { $0.isLetter || $0.isWhitespace }
    }
    
    // Botón ACTUALIZAR — valida y actualiza el miembro en CoreData
    @IBAction func btnActualizar(_ sender: UIButton) {
        // Leo los valores de los TextFields
        let nombre = txtNombre.text ?? ""
        let apellido = txtApellido.text ?? ""
        let edadTexto = txtEdad.text ?? ""
        let fechaInicio = txtFechaInicio.text ?? ""
        
        if nombre.isEmpty || apellido.isEmpty || edadTexto.isEmpty || fechaInicio.isEmpty {
            mensajeError(men: "Por favor rellena todos los campos")
            return
        }
        
        if !soloLetras(nombre) {
            mensajeError(men: "El nombre solo debe contener letras")
            return
        }
        
        if !soloLetras(apellido) {
            mensajeError(men: "El apellido solo debe contener letras")
            return
        }
        
        // Actualizo los atributos del bean con los nuevos valores
        bean.nombre = nombre
        bean.apellido = apellido
        bean.edad = Int16(edadTexto) ?? 0
        bean.fechaInicio = fechaInicio
        bean.plan = planSeleccionado
        bean.sexo = sexoSeleccionado
        
        // Llamo a MiembroController para guardar los cambios en CoreData
        let salida = MiembroController().update(bean: bean)
        if salida == 1 {
            mensajeExito(men: "Miembro actualizado correctamente")
        } else {
            mensajeError(men: "Error al actualizar el miembro")
        }
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
    // Muestra alerta de éxito — regresa al detalle al aceptar
    func mensajeError(men: String) {
        let ventana = UIAlertController(title: "⚠️ Error", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(ventana, animated: true)
    }
    
    func mensajeExito(men: String) {
        let ventana = UIAlertController(title: "✅ GymPro", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(ventana, animated: true)
    }
}
