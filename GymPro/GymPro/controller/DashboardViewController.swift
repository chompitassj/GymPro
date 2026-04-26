import UIKit

class DashboardViewController: UIViewController {
    // Conexiones con los labels del Storyboard
    @IBOutlet weak var lblClima: UILabel!
    @IBOutlet weak var lblTotalMiembros: UILabel!
    @IBOutlet weak var lblTotalPagos: UILabel!
    @IBOutlet weak var lblIngresos: UILabel!
    
    // Se ejecuta una sola vez cuando carga la pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
      obtenerClima()
    }
    // Se ejecuta cada vez que aparece la pantalla
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           actualizarEstadisticas()
       }
       
       func actualizarEstadisticas() {
           // Traigo todos los miembros y pagos de CoreData
           let miembros = MiembroController().findAll()
           let pagos = PagoController().findAll()
           // Sumo todos los montos de los pagos
           let totalIngresos = pagos.reduce(0) { $0 + $1.monto }
           
           // Muestro las estadísticas en los labels
           lblTotalMiembros.text = "👥 Miembros: \(miembros.count)"
           lblTotalPagos.text = "📋 Pagos: \(pagos.count)"
           lblIngresos.text = "💰 Ingresos: S/. \(String(format: "%.2f", totalIngresos))"
           
           // Verifico si hay membresías vencidas
           verificarVencidos(miembros: miembros)
       }
       
       func verificarVencidos(miembros: [MiembroEntity]) {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
           let hoy = Date()
           var vencidos: [String] = [] // Lista de miembros vencidos
           
           // Recorro todos los miembros
           for miembro in miembros {
               if let fechaStr = miembro.fechaInicio,
                  let fechaInicio = formatter.date(from: fechaStr) {
                   // Calculo los días desde la fecha de inicio hasta hoy
                   let dias = Calendar.current.dateComponents([.day],
                               from: fechaInicio, to: hoy).day ?? 0
                   // Defino la duración según el plan
                   let duracion: Int
                   switch miembro.plan {
                   case "Mensual": duracion = 30
                   case "Trimestral": duracion = 90
                   case "Semestral": duracion = 180
                   case "Anual": duracion = 365
                   default: duracion = 30
                   }
                   // Si los días superan la duración del plan está vencido
                   if dias > duracion {
                       vencidos.append("\(miembro.nombre ?? "") \(miembro.apellido ?? "")")
                   }
               }
           }
           // Si hay miembros vencidos muestro una alerta
           if !vencidos.isEmpty {
               let nombres = vencidos.joined(separator: "\n")
               let ventana = UIAlertController(
                   title: "⚠️ Membresías Vencidas",
                   message: "Los siguientes miembros tienen membresía vencida:\n\n\(nombres)",
                   preferredStyle: .alert)
               ventana.addAction(UIAlertAction(title: "Ver Miembros", style: .default, handler: { _ in
                   self.performSegue(withIdentifier: "miembros", sender: nil)
               }))
               ventana.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
               present(ventana, animated: true)
           }
       }
    // Método que consume la API Open-Meteo para obtener el clima de Lima
    func obtenerClima(){
        // URL de la API con las coordenadas de Lima
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=-12.05&longitude=-77.04&current_weather=true"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                // Decodifico la respuesta JSON al struct ClimaResponse
                let json = try JSONDecoder().decode(ClimaResponse.self, from: data)
                let temp = json.current_weather.temperature
                let clima = self.descripcionClima(codigo: json.current_weather.weathercode)
                // Actualizo el label en el hilo principal
                DispatchQueue.main.async {
                    self.lblClima.text = "\(clima) Lima — \(temp)°C"
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume() // Inicio la petición   
    }
    // Método que convierte el código del clima en un emoji    
    func descripcionClima(codigo: Int) -> String {
        switch codigo {
        case 0: return "☀️"
        case 1, 2, 3: return "⛅️"
        case 45, 48: return "🌫️"
        case 51, 53, 55: return "🌦️"
        case 61, 63, 65: return "🌧️"
        case 71, 73, 75: return "❄️"
        case 80, 81, 82: return "🌧️"
        case 95: return "⛈️"
        default: return "🌤️"
        }
    }
    
    @IBAction func btnMiembros(_ sender: UIButton) {
        performSegue(withIdentifier: "miembros", sender: nil)
    }
    
    @IBAction func btnEjercicios(_ sender: UIButton) {
        performSegue(withIdentifier: "ejercicios", sender: nil)
    }
    
    @IBAction func btnPagos(_ sender: UIButton) {
        performSegue(withIdentifier: "pagos", sender: nil)
    }

    }

// Struct que modela la respuesta JSON de la API Open-Meteo
struct ClimaResponse: Codable {
    var current_weather: CurrentWeather
}
// Struct que modela el clima actual
struct CurrentWeather: Codable {
    var temperature: Double
    var weathercode: Int
}
