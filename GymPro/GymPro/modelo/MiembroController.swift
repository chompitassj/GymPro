import UIKit
import CoreData

// Clase que gestiona los datos de Miembro en CoreData
// Implementa el protocolo IMiembr
class MiembroController: IMiembro {
    
    // Método que guarda un nuevo miembro en CoreData
       // Recibe un objeto Miembro y retorna 1 si éxito, -1 si error
    func save(bean: Miembro) -> Int {
        var salida = -1
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        // Creo un nuevo objeto MiembroEntity en CoreData
        let tabla = MiembroEntity(context: contextoBD)
        // Asigno los valores del bean a la entidad
        tabla.dni = bean.dni
        tabla.nombre = bean.nombre
        tabla.apellido = bean.apellido
        tabla.edad = bean.edad
        tabla.plan = bean.plan
        tabla.fechaInicio = bean.fechaInicio
        tabla.sexo = bean.sexo
        do {
            try contextoBD.save() // Guardo en la base de datos
            salida = 1 // Exito
        } catch let ex as NSError {
            print(ex.localizedDescription) //imprime el error
        }
        
        return salida
    }
    //Método que trae todos los miembros guardados en CoreData
    func findAll() -> [MiembroEntity] {
        var lista: [MiembroEntity] = [] // Arreglo vacío
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        do {
            // fetchRequest es como un SELECT * en SQL — trae todos los registros
            let datos = MiembroEntity.fetchRequest()
            lista = try contextoBD.fetch(datos)
        } catch let ex as NSError {
            print(ex.localizedDescription)
        }
        return lista
    }
    
    // Método que elimina un miembro de CoreData
        // Recibe el objeto MiembroEntity a eliminar
    func delete(bean: MiembroEntity) -> Int {
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
    
    // Método que actualiza un miembro en CoreData
       // CoreData trabaja por referencia, solo guardo los cambios
    func update(bean: MiembroEntity) -> Int {
        var salida = -1
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        do {
            try contextoBD.save() // Guardo los cambios en CoreData
            salida = 1
        } catch let ex as NSError {
            print(ex.localizedDescription)
        }
        return salida
    }
    // Método que verifica si ya existe un miembro con ese DNI
       // Retorna true si existe, false si no existe
    func existeDni(dni: String) -> Bool {
        // Accedo al AppDelegate para obtener el contexto de CoreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoBD = delegate.persistentContainer.viewContext
        let datos = MiembroEntity.fetchRequest()
        // NSPredicate es un filtro de búsqueda por DNI
        datos.predicate = NSPredicate(format: "dni == %@", dni)
        do {
            let resultado = try contextoBD.fetch(datos)
            return resultado.count > 0
        } catch {
            return false
        }
    }
}
