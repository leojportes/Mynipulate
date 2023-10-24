//
//  MaskFormatter.swift
//  Manipulations
//
//  Created by Leonardo Portes on 18/09/23.
//

import Foundation

private enum MaskFormatterSymbols {
    static let digits = "d"
    static let nonDigits = "D"
    static let alphabeticSymbol = "a"
    static let freeInput = "@"
}

internal class MaskFormatter {
    // MARK: - Properties -

    private let fixedChars = MaskFormatterSymbols.self

    /// Holds the masks that you wish to apply to some text
    ///
    /// Only the first two masks will be considered
    ///
    /// If it is empty or both masks are set to "",
    /// no mask would be applied and the textfield would behave like a normal one
    var masks = [String]() {
        didSet {
            masks = removeEmptyMasks(from: masks)
            masks = orderByAscendingFixedCharCount(masks)
            masks = removeDuplicatedByInputCount(masks)

            if currentMask.isEmpty && !masks.isEmpty {
                currentMask = masks.first ?? ""
            }
        }
    }

    /// Holds the current mask being used
    ///
    /// If it is set to "" no mask would be applied and
    /// the textfield would behave like a normal one
    private var currentMask: String = ""

    /// Maximum length based on the mask set
    private var maxLength: Int {
        let maxString = masks.max(by: { $1.count > $0.count }) ?? ""
        return maxString.count
    }

    // MARK: - Constructors -

    init() {
        masks = []
    }

    // MARK: - Private Methods -

    // MARK: Masks setter helpers

    /// Remove empty string masks.
    ///
    /// - Parameter masks: The masks available for this field.
    /// - Returns: An array containing all non-empty masks.
    private func removeEmptyMasks(from masks: [String]) -> [String] {
        masks.filter { !$0.isEmpty }
    }

    /// Order a mask array by the fixed char count
    /// (the character count that the user will actually input)
    ///
    /// - Parameter masks: The masks available for this field.
    /// - Returns: A ascendingly ordered by fixed char count array.
    private func orderByAscendingFixedCharCount(_ masks: [String]) -> [String] {
        var patterns = masks
        patterns.sort { left, right in
            countFixedChar(on: left) < countFixedChar(on: right)
        }
        return patterns
    }

    /// Remove duplicated masks of a ascendingly ordered by fixed char count array.
    /// It will keep the first mask with said count.
    ///
    /// - Parameter masks: The masks available for this field, ascendingly ordered by fixed char count.
    /// - Returns: A filtered ordered array containing only masks with distinct fixed char count.
    private func removeDuplicatedByInputCount(_ masks: [String]) -> [String] {
        masks.enumerated().compactMap { index, mask -> String? in
            if index > 0 {
                let previousMask = masks[index - 1]
                if countFixedChar(on: mask) == countFixedChar(on: previousMask) {
                    return nil
                }
                return mask
            }
            return mask
        }
    }

    // MARK: Dynamic mask helpers

    /// Count how many fixed characters are in the mask.
    ///
    /// - Parameter mask: A mask
    /// - Returns: The amount of characters that matches a fixed character.
    private func countFixedChar(on mask: String) -> Int {
        let digitsCount = mask.countOccurrences(of: fixedChars.digits)
        let nonDigitsCount = mask.countOccurrences(of: fixedChars.nonDigits)
        let alphabeticSymbolCount = mask.countOccurrences(of: fixedChars.alphabeticSymbol)
        let freeInputCount = mask.countOccurrences(of: fixedChars.freeInput)

        return digitsCount + nonDigitsCount + alphabeticSymbolCount + freeInputCount
    }

    /// Count how many characters in the text are not automatically set by the mask.
    ///
    /// - Parameter text: A text input.
    /// - Returns: The amount of characters in the text that is not automatically set by the mask.
    private func countRealInputChar(text: String) -> Int {
        let textWithRealInputOnly = removeExtraCharacters(from: text, with: currentMask)
        return textWithRealInputOnly.count
    }

    /// Extract a set of unique characters that are in the mask and are not a fixed char.
    ///
    /// - Parameter mask: A mask.
    /// - Returns: An array containing all characters in the mask that are not a fixed char. Each character will only appear once.
    private func getExtraCharacters(from mask: String) -> [(offset: Int, element: Character)] {
        let result = mask.enumerated().filter { _, character -> Bool in
            character != Character(fixedChars.digits)
                && character != Character(fixedChars.nonDigits)
                && character != Character(fixedChars.alphabeticSymbol)
                && character != Character(fixedChars.freeInput)
        }

        return result
    }

    /// Remove all extra characters of a mask from a text. An extra character is a character in the mask that is not a fixed char.
    ///
    /// - Parameters:
    ///   - text: A text input.
    ///   - mask: A mask pattern.
    /// - Returns: The text input without the extra characters.
    private func removeExtraCharacters(from text: String, with mask: String) -> String {
        let extraCharacters = getExtraCharacters(from: mask)
        var textCharacters: [Character?] = Array(text)

        for extraChar in extraCharacters where extraChar.offset < textCharacters.count && extraChar.element == textCharacters[extraChar.offset] {
            textCharacters[extraChar.offset] = nil
        }

        let filteredTextCharacters = textCharacters.compactMap { $0 }
        return String(filteredTextCharacters)
    }

    /// Remove all extra characters of the current mask from a text.
    /// An extra character is a character in the mask that is not a fixed char.
    ///
    /// - Parameters:
    ///   - text: A text input.
    /// - Returns: The text input without the extra characters.
    func removeExtraCharacters(from text: String) -> String {
        removeExtraCharacters(from: text, with: currentMask)
    }

    /// Set the mask that best fits the text input.
    ///
    /// - Parameter currentTextForFormatting: The text that needs formatting.
    func setMask(for currentTextForFormatting: String) {
        currentMask = masks.isEmpty ? "" : findFitterMask(for: currentTextForFormatting)
    }

    /// Find the mask that best fits the text input.
    ///
    /// - Parameter currentTextForFormatting: The text that needs formatting.
    /// - Returns: The fitter mask for said text input, or an empty mask if there are none set.
    private func findFitterMask(for currentTextForFormatting: String) -> String {
        var fitterMask = ""
        let inputCount = countRealInputChar(text: currentTextForFormatting)

        for mask in masks {
            let charCount = countFixedChar(on: mask)
            if inputCount <= charCount {
                fitterMask = mask
                break
            }
        }

        if fitterMask.isEmpty && !masks.isEmpty {
            return masks.last ?? ""
        } else {
            return fitterMask
        }
    }

    // MARK: Text formatter helpers

    private func getOnlyDigitsString(_ string: String) -> String {
        string.removingCharacters(in: CharacterSet.decimalDigits.inverted)
    }

    private func getOnlyNonDigitsString(_ string: String) -> String {
        string.removingCharacters(in: CharacterSet.decimalDigits)
    }

    private func getOnlyLettersString(_ string: String) -> String {
        string.removingCharacters(in: CharacterSet.letters.inverted)
    }

    private func getCurrentFormatCharacter(at formatterIndex: String.Index) -> String {
        let formatPatternRange = formatterIndex ..< currentMask.index(after: formatterIndex)
        return String(currentMask[formatPatternRange])
    }

    private func getCurrentTextForFormattingCharacter(
        from currentTextForFormatting: String,
        at currentTextForFormattingIndex: String.Index
    ) -> String {
        let currentTextForFormattingPatternRange = currentTextForFormattingIndex ..< currentTextForFormatting.index(after: currentTextForFormattingIndex)
        return String(currentTextForFormatting[currentTextForFormattingPatternRange])
    }

    // MARK: - Internal Methods -

    /// Func that formats the text based on formatPattern
    ///
    /// Override this function if you want to customize the behaviour of
    /// the class
    func formatText(_ completeText: String?) -> String { // swiftlint:disable:this cyclomatic_complexity function_body_length
        var textForFormatting = ""

        if let text = completeText, !text.isEmpty {
            textForFormatting = text
        }

        setMask(for: textForFormatting)

        if maxLength <= 0 {
            return completeText ?? ""
        }

        var indexOfFormatPattern = currentMask.startIndex
        var indexOfTextForFormatting = textForFormatting.startIndex
        var finalText = ""

        if !textForFormatting.isEmpty {
            while true {
                let currentFormatCharacter = getCurrentFormatCharacter(at: indexOfFormatPattern)
                let currentCharacterForFormatting = getCurrentTextForFormattingCharacter(
                    from: textForFormatting,
                    at: indexOfTextForFormatting
                )

                let replacePatternCharacter: ((String) -> String) -> Void = { filter in
                    let filteredChar = filter(currentCharacterForFormatting)
                    if !filteredChar.isEmpty {
                        finalText += filteredChar
                        indexOfFormatPattern = self.currentMask.index(after: indexOfFormatPattern)
                    }
                    indexOfTextForFormatting = textForFormatting.index(after: indexOfTextForFormatting)
                }

                switch currentFormatCharacter {

                case fixedChars.digits:
                    replacePatternCharacter(getOnlyDigitsString)

                case fixedChars.nonDigits:
                    replacePatternCharacter(getOnlyNonDigitsString)

                case fixedChars.alphabeticSymbol:
                    replacePatternCharacter(getOnlyLettersString)

                case fixedChars.freeInput:
                    replacePatternCharacter({ _ in currentCharacterForFormatting })

                default:
                    if currentCharacterForFormatting == currentFormatCharacter {
                        indexOfTextForFormatting = textForFormatting.index(after: indexOfTextForFormatting)
                    }
                    finalText += currentFormatCharacter
                    indexOfFormatPattern = currentMask.index(after: indexOfFormatPattern)
                }

                if
                    indexOfFormatPattern >= currentMask.endIndex ||
                    indexOfTextForFormatting >= textForFormatting.endIndex
                {
                    break
                }
            }
        }

        if finalText.count > maxLength {
            return String(finalText[finalText.index(finalText.startIndex, offsetBy: maxLength)])
        }

        return finalText
    }
}
