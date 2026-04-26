import UIKit

class MiembrosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tvMiembros: UITableView!
    // Arreglo que almacena los miembros traídos de CoreData
    var lista: [MiembroEntity] = []
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        tvMiembros.dataSource = self  // Asigno el origen de datos
        tvMiembros.delegate = self   // Asigno el delegado
        tvMiembros.rowHeight = 80    // Altura de cada celda
    }
    
    // Se ejecuta cada vez que aparece la pantalla
    // Así se actualiza la lista cuando vuelvo de otra pantalla
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lista = MiembroController().findAll() // Traigo todos los miembros de CoreData
        tvMiembros.reloadData() // Recargo la tabla con los nuevos datos
    }
    
    // Método que le dice al TableView cuántas filas debe mostrar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count // Retorna el total de miembros
    }
    
    // Método que construye cada celda de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reutilizo la celda celdaMiembro y la convierto a CeldaMiembro
        let fila = tvMiembros.dequeueReusableCell(withIdentifier: "celdaMiembro",
                    for: indexPath) as! CeldaMiembro
        // Asigno el nombre completo y el plan al miembro correspondiente
        fila.lblNombre.text = "\(lista[indexPath.row].nombre ?? "") \(lista[indexPath.row].apellido ?? "")"
        fila.lblPlan.text = "Plan: \(lista[indexPath.row].plan ?? "")"
        return fila  // Retorno la celda configurada
    }
    
    // Método que se ejecuta cuando el usuario toca una celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navego a la pantalla de detalle del miembro
        performSegue(withIdentifier: "detalleMiembro", sender: nil)
    }
    
    // Método que se ejecuta antes de navegar a otra pantalla
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalleMiembro" {
            // Creo objeto de DetalleMiembroViewController
            let v2 = segue.destination as! DetalleMiembroViewController
            // Paso el miembro seleccionado a la pantalla de detalle
            v2.bean = lista[tvMiembros.indexPathForSelectedRow!.row]
        }
    }
    
    @IBAction func btnNuevoMiembro(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevoMiembro", sender: nil)
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
