import UIKit

protocol IEjercicio {
    func save(bean: Ejercicio) -> Int
    func findAll() -> [EjercicioEntity]
    func delete(bean: EjercicioEntity) -> Int
}
