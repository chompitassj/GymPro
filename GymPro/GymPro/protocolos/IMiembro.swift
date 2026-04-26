import UIKit

protocol IMiembro {
    func save(bean: Miembro) -> Int
    func findAll() -> [MiembroEntity]
    func delete(bean: MiembroEntity) -> Int
    func update(bean: MiembroEntity) -> Int
    func existeDni(dni: String) -> Bool
}
