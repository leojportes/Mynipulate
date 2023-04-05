//
//  FilterSegmentedControl.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

enum ButtonFilterType: String {
    case all = "Todos"
    case penultimateYear = "2021"
    case lastYear = "2022"
    case thisYear = "2023"
    case custom = "Personalizado"
}

final class FilterSegmentedControl: UIView, ViewCodeContract {

    private var didSelectIndexClosure: (ButtonFilterType) -> Void?
    private var didSelectDateClosure: (String) -> Void?
    
    var segmentedControlButtons: [UIButton] = []
    
    let all = SegmentedControlButton(title: ButtonFilterType.all.rawValue) .. {
        $0.backgroundColor = .neutral
    }
    let today = SegmentedControlButton(title: ButtonFilterType.penultimateYear.rawValue)
    let sevenDays = SegmentedControlButton(title: ButtonFilterType.lastYear.rawValue)
    let thirtyDays = SegmentedControlButton(title: ButtonFilterType.thisYear.rawValue)
    let custom = SegmentedControlButton(title: ButtonFilterType.custom.rawValue)

    var currentIndexFilter: ButtonFilterType = .all {
        didSet {
            if currentIndexFilter == .all {
                handleSegmentedControlButtons()
                all.backgroundColor = .neutral
            }
        }
    }
    
    // MARK: - Init
    init(
        didSelectIndexClosure: @escaping (ButtonFilterType) -> Void,
        didSelectDateClosure: @escaping (String) -> Void
    ) {
        self.segmentedControlButtons = [all, today, sevenDays, thirtyDays, custom]
        self.didSelectIndexClosure = didSelectIndexClosure
        self.didSelectDateClosure = didSelectDateClosure
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: segmentedControlButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: .zero, height: 30)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.locale = Locale(identifier: "pt-BR")
        date.calendar = Calendar(identifier: .gregorian)
        date.timeZone = TimeZone(identifier: "pt-BR")
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()

    func setupHierarchy() {
        addSubview(container)
        container.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 30),

            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 30),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupConfiguration() {
        configurePickerView()
        segmentedControlButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(handleSegmentedControlButtons(sender:)),
                for: .touchUpInside
            )
        }
    }

    func configurePickerView() {
        custom.addSubview(datePicker)
        datePicker
            .topAnchor(in: custom)
            .leftAnchor(in: custom)
            .rightAnchor(in: custom)
            .heightAnchor(250)
            .bottomAnchor(in: custom)
        datePicker.tintColor = .neutralHigh
        datePicker.alpha = 0.02
        datePicker.isUserInteractionEnabled = true

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let minimumDate = formatter.date(from: "01/09/2022")
        datePicker.minimumDate = minimumDate
        datePicker.calendar.locale = Locale(identifier: "pt-BR")
        datePicker.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        datePicker.addTarget(self, action: #selector(editingDidBeginPicker), for: .editingDidBegin)
        datePicker.addTarget(self, action: #selector(editingDidEndPicker(sender:)), for: .editingDidEnd)
    }

    // MARK: - Actions methods
    @objc
    func editingDidBeginPicker() {
        handleSegmentedControlButtons()
        custom.backgroundColor = .neutral
    }

    @objc
    func editingDidEndPicker(sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateString = df.string(from: sender.date)
        self.didSelectDateClosure(dateString)
    }

    @objc
    func handleSegmentedControlButtons(sender: UIButton? = nil) {
        for button in segmentedControlButtons {
            if button == sender {
                button.backgroundColor = .neutral
                let title = button.titleLabel?.text ?? .empty
                self.didSelectIndexClosure(ButtonFilterType(rawValue: title) ?? .all)
            } else {
                button.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
            }
        }
    }
}

class SegmentedControlButton: UIButton {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 14)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
        self.roundCorners(cornerRadius: 15)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        self.layer.borderColor = UIColor.black.cgColor
    }

}
