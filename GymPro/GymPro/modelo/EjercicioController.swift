import UIKit
import CoreData

// Clase que gestiona los datos de Ejercicio en CoreData
// Implementa el protocolo IEjercicio
class EjercicioController: IEjercicio {
    
    // Método que guarda un ejercicio favorito en CoreData
       // Recibe un objeto Ejercicio y retorna 1 si éxito, -1 si error
    func save(bean: Ejercicio) -> Int {
        var salida = -1
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        // Creo un nuevo objeto EjercicioEntity en CoreData
        let tabla = EjercicioEntity(context: contextoBD)
        // Asigno los valores del bean a la entidad
        tabla.nombre = bean.nombre
        tabla.musculo = bean.musculo
        tabla.dificultad = bean.dificultad
        tabla.instrucciones = bean.instrucciones
        do {
            try contextoBD.save() // Guardo en la base de datos
            salida = 1
        } catch let ex as NSError {
            print(ex.localizedDescription) //Imprime el error
        }
        return salida
    }
    
    // Método que trae todos los ejercicios guardados en CoreData
    func findAll() -> [EjercicioEntity] {
        var lista: [EjercicioEntity] = []
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        do {
            // fetchRequest es como un SELECT * en SQL — trae todos los registros
            let datos = EjercicioEntity.fetchRequest()
            lista = try contextoBD.fetch(datos)
        } catch let ex as NSError {
            print(ex.localizedDescription)
        }
        return lista
    }
    
    // Método que elimina un ejercicio de CoreData
        // Recibe el objeto EjercicioEntity a eliminar
    func delete(bean: EjercicioEntity) -> Int {
        var salida = -1
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        do {
            contextoBD.delete(bean) // Marco el objeto para eliminar
            try contextoBD.save() // Confirmo la eliminación
            salida = 1
        } catch let ex as NSError {
            print(ex.localizedDescription)
        }
        return salida
    }
}
