import UIKit

// UITableViewDataSource provee los datos a la tabla
// UITableViewDelegate maneja las interacciones del usuario con la tabla
class PagosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tvPagos: UITableView!
    
    // Arreglo que almacena los pagos traídos de CoreData
    var lista: [PagoEntity] = []
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        tvPagos.dataSource = self // Asigno el origen de datos
        tvPagos.delegate = self // Asigno el delegado
        tvPagos.rowHeight = 110 // Altura de cada celda
    }
    
    // Se ejecuta cada vez que aparece la pantalla
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lista = PagoController().findAll() // Traigo todos los pagos de CoreData
        tvPagos.reloadData() // Recargo la tabla
    }
    
    // Método que le dice al TableView cuántas filas debe mostrar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count // Retorna el total de pagos
    }
    
    // Método que construye cada celda de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reutilizo la celda y la casteo a CeldaPago
        let fila = tvPagos.dequeueReusableCell(withIdentifier: "celdaPago",
                    for: indexPath) as! CeldaPago
        let pago = lista[indexPath.row]
        // Busco el miembro correspondiente al DNI del pago
        let miembros = MiembroController().findAll()
        let miembro = miembros.first { $0.dni == pago.dniMiembro }
        // Muestro el nombre del miembro, concepto y monto
        fila.lblNombreMiembro.text = "👤 \(miembro?.nombre ?? "") \(miembro?.apellido ?? "")"
        fila.lblConcepto.text = "CONCEPTO: \(pago.concepto ?? "")"
        fila.lblMonto.text = "MONTO: S/. \(pago.monto)"
         return fila
    }
    
    // Método que permite eliminar un pago deslizando la celda hacia la izquierda
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                       forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Elimino el pago de CoreData
                let resu = PagoController().delete(bean: lista[indexPath.row])
                if resu == 1 {
                    lista.remove(at: indexPath.row) // Elimino del arreglo
                    tvPagos.deleteRows(at: [indexPath], with: .automatic) // Elimino la celda
                }
            }
        }
    // Método que cambia el texto del botón eliminar a español
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Eliminar"
    }

    @IBAction func btnNuevoPago(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevoPago", sender: nil)
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
