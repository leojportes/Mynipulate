//
//  PDFBuilder.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit
import PDFKit

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}

class PDFBuilder: NSObject {
    
    var pdfView: PDFView!
    var pdfContents : Array<PDFContent> = Array<PDFContent>()
    private var pdfFiledata : Data?
    static let shared = PDFBuilder()
    
    // MARK: - Private methods
    private override init() { /* empty init */ }
    
    private func getPDFData() -> Data {
        // default page format
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: UIGraphicsPDFRendererFormat())
        let data = renderer.pdfData { context in
            
            for content in pdfContents {
                content.renderContent(pdfSize: pageRect.size, context: context)
            }
        }
        return data
    }
    
    func createPDF() {
        pdfFiledata = getPDFData()
    }
    
    // MARK: - Public methods
    
    func savePdf(titleFile: String) {
        
        if let data = pdfFiledata {
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
            docURL = docURL?.appendingPathComponent("\(titleFile).pdf")
            do {
                try data.write(to: docURL! as URL)
                print("PDF save successfully")
                didSelectPreview(url: docURL! as URL)
                self.pdfContents.removeAll()
            } catch {
                print("Fail to save the pdf!!!")
                UIViewController.findCurrentController()?.showAlert(title: "Error", message: "Fail to save the pdf!!!")
            }
        }
    }

    func didSelectPreview(url: URL) {
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIViewController.findCurrentController()?.present(activityController, animated: true)
        activityController.completionWithItemsHandler = { _, _, _, _ in
            UIViewController.findCurrentController()?.dismiss(animated: true)
        }
    }
    
    func configureTable(configDict : NSMutableDictionary, headerArray : [String]?, dataArray : [[ColumnCell]]) {
        let table = Table(configDict:configDict, tableDataItems:dataArray , tableDataHeaderTitles:headerArray)
        pdfContents.append(table)
    }
}
