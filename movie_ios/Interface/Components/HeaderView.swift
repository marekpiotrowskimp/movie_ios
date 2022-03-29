import UIKit

class HeaderView: UIView {
    
    // MARK: - setup components
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.normal14
        label.textColor = UIColor(named: "text_yellow")
        return label
    }()
    
    // MARK: -Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "light_gray")
        addSubview(headerLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
