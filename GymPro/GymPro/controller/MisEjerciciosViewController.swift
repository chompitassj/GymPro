import UIKit

// UITableViewDataSource provee los datos a la tabla
// UITableViewDelegate maneja las interacciones del usuario con la tabla
class MisEjerciciosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tvEjercicios: UITableView!
    // Arreglo que almacena los ejercicios guardados en CoreData
    var lista: [EjercicioEntity] = []
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        tvEjercicios.dataSource = self // Asigno el origen de datos
        tvEjercicios.delegate = self   // Asigno el delegado
        tvEjercicios.rowHeight = 80 // Altura de cada celda
    }
    // Se ejecuta cada vez que aparece la pantalla
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lista = EjercicioController().findAll() // Traigo ejercicios de CoreData
        tvEjercicios.reloadData() // Recargo la tabla
    }
    
    // Método que le dice al TableView cuántas filas debe mostrar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count // Retorna el total de ejercicios guardados
    }
    
    // Método que construye cada celda de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reutilizo la celda y la combierto a CeldaEjercicio
        let fila = tvEjercicios.dequeueReusableCell(withIdentifier: "celdaEjercicio",
                    for: indexPath) as! CeldaEjercicio
        // Asigno el nombre y músculo del ejercicio correspondiente
        fila.lblNombre.text = lista[indexPath.row].nombre ?? ""
        fila.lblMusculo.text = "Músculo: \(lista[indexPath.row].musculo ?? "")"
        return fila
    }
    
    // Método que permite eliminar un ejercicio deslizando la celda hacia la izquierda

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Elimino el ejercicio de CoreData
            let resu = EjercicioController().delete(bean: lista[indexPath.row])
            if resu == 1 {
                lista.remove(at: indexPath.row) // Elimino del arreglo
                tvEjercicios.deleteRows(at: [indexPath], with: .automatic) // Elimino la celda           
            }
        }
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
