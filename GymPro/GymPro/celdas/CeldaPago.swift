import UIKit

class CeldaPago: UITableViewCell {
    
    @IBOutlet weak var lblConcepto: UILabel!
    @IBOutlet weak var lblMonto: UILabel!
    @IBOutlet weak var lblNombreMiembro: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
