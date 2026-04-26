import UIKit

// UIPickerViewDataSource provee los datos al PickerView
// UIPickerViewDelegate maneja las interacciones del usuario con el PickerView
class NuevoPagoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var txtDniMiembro: UITextField!
    @IBOutlet weak var txtConcepto: UITextField!
    @IBOutlet weak var txtMonto: UITextField!
    @IBOutlet weak var txtFecha: UITextField!
    
    // Arreglo que almacena los miembros traídos de CoreData
    var miembros: [MiembroEntity] = []
    // Variable que almacena el miembro seleccionado en el PickerView
    var miembroSeleccionado: MiembroEntity?
    let pickerMiembro = UIPickerView() // PickerView para seleccionar el miembro
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        miembros = MiembroController().findAll() // Traigo todos los miembros de CoreData
        configurarPickerMiembro() // Configuro el picker de miembros
        configurarDatePicker() // Configuro el calendario de fecha
    }
    
    // Configuro el PickerView de miembros como teclado del TextField
    func configurarPickerMiembro() {
           pickerMiembro.dataSource = self
           pickerMiembro.delegate = self
           txtDniMiembro.inputView = pickerMiembro // Al tocar aparece el picker
        // Muestro el primer miembro por defecto
        if let primero = miembros.first {
               miembroSeleccionado = primero
               txtDniMiembro.text = "\(primero.nombre ?? "") \(primero.apellido ?? "") — \(primero.dni ?? "")"
           }
       }
    
    // Configuro el DatePicker como teclado del TextField de fecha
    func configurarDatePicker() {
         let datePicker = UIDatePicker()
         datePicker.datePickerMode = .date
         datePicker.preferredDatePickerStyle = .wheels
         datePicker.addTarget(self, action: #selector(fechaSeleccionada(_:)), for: .valueChanged)
         
         // Fecha actual por defecto
         let formatter = DateFormatter()
         formatter.dateFormat = "dd/MM/yyyy"
         txtFecha.text = formatter.string(from: Date())
         txtFecha.inputView = datePicker // Al tocar aparece el calendario
    }
    // Se ejecuta cuando el usuario selecciona una fecha en el DatePicker
     @objc func fechaSeleccionada(_ datePicker: UIDatePicker) {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd/MM/yyyy"
         txtFecha.text = formatter.string(from: datePicker.date)
     }
    
    // Método que define cuántas columnas tiene el PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Solo una columna
    }
    
    // Método que define cuántas filas tiene el PickerView
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return miembros.count // Una fila por cada miembro
        }
    
    // Método que define el texto de cada fila del PickerView
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let m = miembros[row]
            // Muestro nombre, apellido y DNI del miembro
            return "\(m.nombre ?? "") \(m.apellido ?? "") — \(m.dni ?? "")"
        }
    
    // Método que se ejecuta cuando el usuario selecciona un miembro
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            miembroSeleccionado = miembros[row] // Guardo el miembro seleccionado
            let m = miembros[row]
            txtDniMiembro.text = "\(m.nombre ?? "") \(m.apellido ?? "") — \(m.dni ?? "")"
        }
    // Botón GRABAR — valida y guarda el nuevo pago
    @IBAction func btnGrabar(_ sender: UIButton) {
        // Verifico que haya un miembro seleccionado
        guard let miembro = miembroSeleccionado else {
                        mensajeError(men: "No hay miembros registrados")
                        return
                    }        
        // Leo los valores de los TextFields
        let concepto = txtConcepto.text ?? ""
        let montoTexto = txtMonto.text ?? ""
        let fecha = txtFecha.text ?? ""
        
        // Valido que los campos no estén vacíos
        if concepto.isEmpty || montoTexto.isEmpty {
                        mensajeError(men: "Por favor rellena todos los campos")
                        return
                    }
        // Valido que el monto sea un número válido mayor a 0
        guard let monto = Double(montoTexto), monto > 0 else {
                mensajeError(men: "El monto debe ser un número válido mayor a 0")
                return
            }
        // Creo el objeto Pago con los datos del formulario
        let pago = Pago(monto: monto, fecha: fecha,
                        concepto: concepto, dniMiembro: miembro.dni ?? "")
        // Llamo a PagoController para guardar en CoreData
        let salida = PagoController().save(bean: pago)
        
        if salida == 1 {
            mensajeExito(men: "Pago registrado correctamente")
        } else {
            mensajeError(men: "Error al registrar el pago")
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

    
