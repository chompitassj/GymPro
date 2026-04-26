import UIKit
import CoreData

// Clase que gestiona los datos de Pago en CoreData
// Implementa el protocolo IPago
class PagoController: IPago {
    // Método que guarda un nuevo pago en CoreData
        // Recibe un objeto Pago y retorna 1 si éxito, -1 si error
    func save(bean: Pago) -> Int {
        var salida = -1
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        // Creo un nuevo objeto PagoEntity en CoreData
        let tabla = PagoEntity(context: contextoBD)
        // Asigno los valores del bean a la entidad
        tabla.monto = bean.monto
        tabla.fecha = bean.fecha
        tabla.concepto = bean.concepto
        tabla.dniMiembro = bean.dniMiembro
        do {
            try contextoBD.save() // Guardo en la base de datos
            salida = 1
        } catch let ex as NSError {
            print(ex.localizedDescription) //imprime el error
        }
        return salida
    }
    
    // Método que trae todos los pagos guardados en CoreData
    func findAll() -> [PagoEntity] {
        var lista: [PagoEntity] = [] //arreglo vacio
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        do {
            // fetchRequest es como un SELECT * en SQL — trae todos los registros
            let datos = PagoEntity.fetchRequest()
            lista = try contextoBD.fetch(datos)
        } catch let ex as NSError {
            print(ex.localizedDescription)
        }
        return lista
    }
    // Método que elimina un pago de CoreData
        // Recibe el objeto PagoEntity a eliminar
    func delete(bean: PagoEntity) -> Int {
        var salida = -1
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        do {
            contextoBD.delete(bean) // Marco el objeto para eliminar
            try contextoBD.save() //confirmo la eliminacion
            salida = 1
        } catch let ex as NSError {
            print(ex.localizedDescription)
        }
        return salida
    }
}
