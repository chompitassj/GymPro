import UIKit

// UITableViewDataSource provee los datos a la tabla
// UITableViewDelegate maneja las interacciones del usuario con la tabla
class EjerciciosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tvEjercicios: UITableView!
    @IBOutlet weak var txtBuscar: UITextField!
    
// Arreglo que almacena los ejercicios traídos de la API
    var lista: [Ejercicio] = []
    
// Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        tvEjercicios.dataSource = self
        tvEjercicios.delegate = self
        tvEjercicios.rowHeight = 80
    }
    
    // Método que le dice al TableView cuántas filas debe mostrar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count // Retorna el total de ejercicios encontrados
    }
    
    // Método que construye cada celda de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reutilizo la celda y la convierto a CeldaEjercicio
        let fila = tvEjercicios.dequeueReusableCell(withIdentifier: "celdaEjercicio",
                    for: indexPath) as! CeldaEjercicio
        // Asigno el nombre y músculo del ejercicio correspondiente
        fila.lblNombre.text = lista[indexPath.row].nombre
        fila.lblMusculo.text = "Músculo: \(lista[indexPath.row].musculo)"
        return fila
    }
    
    // Método que se ejecuta cuando el usuario toca una celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detalleEjercicio", sender: nil)
    }
    
    // Método que se ejecuta antes de navegar a otra pantalla
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalleEjercicio" {
            // Creo objeto de DetalleEjercicioViewController
            let v2 = segue.destination as! DetalleEjercicioViewController
            // Paso el ejercicio seleccionado a la pantalla de detalle
            v2.ejercicio = lista[tvEjercicios.indexPathForSelectedRow!.row]
        }
    }
    
    // Botón BUSCAR — valida y llama a la API de ejercicios
    @IBAction func btnBuscar(_ sender: UIButton) {
        let musculo = txtBuscar.text ?? ""
        // Valido que el campo no esté vacío
        if musculo.isEmpty {
            mensaje(men: "Ingresa un músculo para buscar")
            return
        }
        buscarEjercicios(musculo: musculo) // Llamo a la API
    }
    
    @IBAction func btnMisEjercicios(_ sender: UIButton) {
        performSegue(withIdentifier: "misEjercicios", sender: nil)
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // Método que consume la API Ninjas para buscar ejercicios por músculo
    func buscarEjercicios(musculo: String) {
        // Formato el músculo en minúsculas y reemplazo espacios por guiones
        let muscuFormat = musculo.lowercased().replacingOccurrences(of: " ", with: "_")
        // URL de la API con el músculo como parámetro
        let urlString = "https://api.api-ninjas.com/v1/exercises?muscle=\(muscuFormat)"
        guard let url = URL(string: urlString) else { return }
        // Creo la petición con la API Key en el header
        var request = URLRequest(url: url)
        request.setValue("FzPWGFaNU9frgRuIxt1Xi5CBgjVKkSXCYJNo4mfe", forHTTPHeaderField: "X-Api-Key")
        // Hago la petición a la API usando URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                // Decodifico la respuesta JSON al arreglo de EjercicioAPI
                let json = try JSONDecoder().decode([EjercicioAPI].self, from: data)
                // Convierto los objetos EjercicioAPI a objetos Ejercicio
                self.lista = json.map {
                    Ejercicio(nombre: $0.name, musculo: $0.muscle,
                              dificultad: $0.difficulty, instrucciones: $0.instructions)
                }
                // Actualizo la tabla en el hilo principal
                DispatchQueue.main.async {
                    self.tvEjercicios.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume() // Inicio la petición
    }
    // Muestra una alerta con un mensaje
    func mensaje(men: String) {
        let ventana = UIAlertController(title: "GymPro", message: men,
                                        preferredStyle: .alert)
        ventana.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(ventana, animated: true)
    }
}

// Struct que modela la respuesta JSON de la API Ninjas
struct EjercicioAPI: Codable {
    var name: String
    var muscle: String
    var difficulty: String
    var instructions: String
}
