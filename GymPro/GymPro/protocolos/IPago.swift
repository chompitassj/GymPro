import UIKit

protocol IPago {
    func save(bean: Pago) -> Int
    func findAll() -> [PagoEntity]
    func delete (bean: PagoEntity) -> Int
}
