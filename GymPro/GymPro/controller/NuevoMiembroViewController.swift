import UIKit

class NuevoMiembroViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtEdad: UITextField!
    @IBOutlet weak var txtFechaInicio: UITextField!
    @IBOutlet weak var txtPlan: UITextField!
    @IBOutlet weak var txtSexo: UITextField!
    
    // Opciones del PickerView de plan y sexo
    let planes = ["Mensual", "Trimestral", "Semestral", "Anual"]
    let sexos = ["Masculino","Femenino"]
    var planSeleccionado = "Mensual"
    let pickerSexo = UIPickerView() // PickerView para el sexo
    var sexoSeleccionado = "Masculino"
    let pickerPlan = UIPickerView() // PickerView para el plan
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPickerPlan()
        configurarPickerSexo()
        configurarDatePicker()
    }
    // Configuro el PickerView de plan como teclado del TextField
    func configurarPickerPlan() {
        pickerPlan.tag = 1 // Tag para identificar el picker
        pickerPlan.dataSource = self
        pickerPlan.delegate = self
        txtPlan.inputView = pickerPlan // Al tocar txtPlan aparece el picker        
        txtPlan.text = "Mensual" // Valor por defecto
    }
    
        func configurarPickerSexo() {
            pickerPlan.tag = 2 // Tag para identificar el picker
            pickerSexo.dataSource = self
            pickerSexo.delegate = self
            txtSexo.inputView = pickerSexo // Al tocar txtSexo aparece el picker
            txtSexo.text = "Masculino" //valor por defexto
        }
    
    // Configuro el DatePicker como teclado del TextField de fecha
    func configurarDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(fechaSeleccionada(_:)), for: .valueChanged)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtFechaInicio.text = formatter.string(from: Date()) // Fecha actual por defecto
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
        return 1
    }
    
    // Método que define cuántas filas tiene el PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === pickerPlan {
                    return planes.count // 4 planes
        } else {
                    return sexos.count  //2 sexos
                }
    }
    
    // Método que define el texto de cada fila del PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === pickerPlan{
            return planes [row] // Retorna el plan correspondiente
        } else {
            return sexos[row] // Retorna el sexo correspondiente
                }
            }
    
    // Método que se ejecuta cuando el usuario selecciona una opción
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === pickerPlan {
            planSeleccionado = planes[row]  // Guardo el plan seleccionado
            txtPlan.text = planes[row]      //Muestro el sexo en el txt
        } else {
            sexoSeleccionado = sexos[row]  // Guardo el sexo seleccionado
            txtSexo.text = sexos[row]      // Muestro el sexo en el TextField
        }
    }
    
        func soloNumeros(_ texto: String) -> Bool {
            return texto.allSatisfy { $0.isNumber }
        }
        
        func soloLetras(_ texto: String) -> Bool {
            return texto.allSatisfy { $0.isLetter || $0.isWhitespace }
        }
    
    @IBAction func btnGrabar(_ sender: UIButton) {
        // Lee los valores de los TextFields
        let dni = txtDni.text ?? ""
        let nombre = txtNombre.text ?? ""
        let apellido = txtApellido.text ?? ""
        let edadTexto = txtEdad.text ?? ""
        let fechaInicio = txtFechaInicio.text ?? ""
        
        // Valido que ningún campo esté vacío
        if dni.isEmpty || nombre.isEmpty || apellido.isEmpty || edadTexto.isEmpty || fechaInicio.isEmpty {
            mensajeError(men: "Por favor rellena todos los campos")
            return
            }
        
        // Valido que el DNI tenga exactamente 8 números
        if !soloNumeros(dni) || dni.count != 8 {
                    mensajeError(men: "El DNI debe tener exactamente 8 números")
                    return
                }
        
        // Valido que el nombre solo tenga letras
        if !soloLetras(nombre) {
                    mensajeError(men: "El nombre solo debe contener letras")
                    return
                }
                
        // Valido que el apellido solo tenga letras
        if !soloLetras(apellido) {
            mensajeError(men: "El apellido solo debe contener letras")
            return }
        
        // Valido que el DNI no esté registrado previamente
        if MiembroController().existeDni(dni: dni) {
                mensajeError(men: "Ya existe un miembro con ese DNI")
                return
            }
        
        // Creo el objeto Miembro con los datos del formulario
        let edad = Int16(edadTexto) ?? 0
        let miembro = Miembro(dni: dni, nombre: nombre, apellido: apellido,
                              edad: edad, plan: planSeleccionado, fechaInicio: fechaInicio, sexo: sexoSeleccionado)
        
        // Llamo a MiembroController para guardar en CoreData
        let salida = MiembroController().save(bean: miembro)
        
        if salida == 1 {
            mensajeExito(men: "Miembro registrado correctamente")
        } else {
            mensajeError(men: "Error al registrar el miembro")
        }
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }

    // Muestra alerta de error — se queda en la pantalla
    func mensajeError(men: String) {
        let ventana = UIAlertController(title: "⚠️ Error", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(ventana, animated: true)
    }

    // Muestra alerta de éxito — regresa al listado al aceptar
    func mensajeExito(men: String) {
        let ventana = UIAlertController(title: "✅ GymPro", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(ventana, animated: true)
    }
}
