//
//  TwoSumsView.swift
//  CodeInterviewWithSwiftUI
//
//  Created by James Hillhouse IV on 4/6/21.
//

import SwiftUI




struct TwoSumsView: View {
    static let tag: String? = "TwoSums"
    
    @State private var desiredSum: Int      = 20
    @State private var result: Bool         = false
    @State private var resultString: String = ""
    @State private var array: [Int]         = [1, 2, 3, 4, 5, 7, 7, 11, 13, 21, 30]
    @State private var numberString         = "1, 2, 3"
    @State private var arrayString: String  = ""
    @State private var isEditing: Bool      = false
    @State private var arrayEntered: Bool   = false

    private var defaultHStackSpace: CGFloat = 5
    private var defaultVStackSpace: CGFloat = 20


    var body: some View {
        VStack(alignment: .center, spacing: 10) {

            VStack(alignment: .center, spacing: 10) {
                Text("Welcome to Two Sums!")
                    .font(.title)

                Text("Create an array of numbers")
                    .font(.headline)

                Text("""
                     And then see if any of the numbers
                     can be combined to the desired sum
                     """)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }


            VStack(alignment: .leading) {

                VStack(alignment: .leading, spacing: 10) {
                    Text("""
                        Enter an array of positive, real or integer numbers
                        (seperated by ", ") :
                        """)
                        .frame(width: 350, alignment: .leading)
                        .padding(.top, 100)
                        .padding(.leading, 5)


                    HStack(alignment: .lastTextBaseline, spacing: 5) {
                        Text("Numbers: ")
                            .frame(width: 100, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.trailing, 20)

                        TextField("",
                                  text: $numberString)
                        { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            self.array = readArrayEntry(from: self.numberString)
                            self.arrayEntered = true
                        }
                        .frame(width: 200)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                        .keyboardType(.numbersAndPunctuation)
                        .padding(.leading, 5)
                    }
                }


                //
                // This area displays the above entered array of strings as rounded Int's.
                //
                HStack(alignment: .lastTextBaseline, spacing: 5) {
                    Text("Your array: ")
                        .frame(width: 100, height: 30, alignment: .leading)
                        .padding([.top, .leading], 5)
                        .padding(.trailing, 20)
                        //.padding(.top, 10)

                    TextField("Your array will appear here.", text: $arrayString)
                        .frame(width: 200)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                        .disabled(true)
                        .padding(.leading, 5)
                }


                VStack(alignment: .leading, spacing: 10) {
                    //
                    // This area is for entering the desired sum.
                    //
                    HStack(alignment: .lastTextBaseline, spacing: 5) {

                        Text("Desired sum:")
                            .frame(width: 100, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.trailing, 20)

                        TextField("20",
                                  value: $desiredSum,
                                  formatter: NumberFormatter())
                        { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            self.result = self.twoSumsUsingLowAndHighIndices(of: self.array, sum: self.desiredSum)
                        }
                        .frame(width: 100, alignment: .trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numbersAndPunctuation)
                        .padding(.leading, 5)
                    }


                    HStack(alignment: .lastTextBaseline, spacing: 5) {
                        Text("Solution:")
                            .frame(width: 100, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.trailing, 20)

                        Text(result ? resultString : "None")
                            .frame(width: 150, alignment: .center)
                            .multilineTextAlignment(.trailing)
                            .padding(.leading, 5)
                    }
                }
                .opacity(self.arrayEntered ? 1 : 0.5)
                .disabled(self.arrayEntered ? false : true)

                Spacer()
            }
        }
    }



    fileprivate func createStringArray(from string: String) -> [String] {
        print("Initial array: \(string)")

        // Create a CharacterSet of items to remove from the string that shouldn't be there.
        // Please remember that CharacterSet is NOT a set of characters. It is instead a set of
        // UnicodeScalars. It should have been called UnicodeScalarSet. Due to history, this wasn't done. :-(
        var disallowedCharacters    = CharacterSet()
        disallowedCharacters.formUnion(.capitalizedLetters)
        disallowedCharacters.formUnion(.lowercaseLetters)
        disallowedCharacters.formUnion(.letters)
        disallowedCharacters.insert(charactersIn: "!@#$%^&*()")

        // Create a mutable copy of the entry string.
        var newString   = string

        // Now remove the disallowedCharacters from the mutated copy of string, which is newString.
        newString.unicodeScalars.removeAll(where: { disallowedCharacters.contains($0) })
        print("Cleaned-up string entry: \(newString)")


        // Create character set to use for seperating items in string with a "," and one space, ", ".
        let commaCharacterSet   = CharacterSet(charactersIn: ", ")

        var stringArray         = newString.components(separatedBy: commaCharacterSet)
        print("stringArray: \(stringArray)")


        // Clean-up by removing any "" from stringArray that are put in by reading with .components.
        // For example, reading the input of 1, 2, 3 entered into the textField will result in
        // ["1", "", "2", "", "3"]. This call results in cleaning-up and returning ["1", "2", "3"].
        stringArray.removeAll(where: { $0 == "" })
        print("Cleaned-up stringArray: \(stringArray)")

        return stringArray
    }



    fileprivate func createRoundedFloatArray(from stringArray: [String]) -> [Float] {
        // This converts string array elements into an array of rounded Floats in case the user entered Floats.
        var floatArray: [Float] = []


        // This...
        floatArray = stringArray.compactMap{ round(Float($0) ?? 0) }

        // does this! Pretty cool!
        /*
        for item in stringArray {
            //floatArray.append(Float(item)?.rounded(.toNearestOrAwayFromZero) ?? 0)
            floatArray.append(round(Float(item) ?? 0))
        }
        */


        /*
        var positiveDoubles: [Double] = []
        positiveDoubles = stringArray.compactMap{ round(Double($0) ?? 0) }

        var intArray: [Int] = []
        intArray = positiveDoubles.compactMap{ Int(round(Double($0))) }
        */

        return floatArray
    }



    fileprivate func createSortedUnsignedIntArray(from floatArray: [Float]) -> [Int] {
        // This converts the Float array elements into Ints, which is the desired final output.
        // The Int array is then sorted.
        var intArray: [Int]     = []

        // Cast items in floatArray as Int.
        intArray = floatArray.compactMap { Int($0) }

        // Go ahead and strip-out any negative elements from
        intArray = intArray.filter{ $0 > 0 }

        intArray.sort()
        print("Array of Int's: \(intArray)")

        return intArray
    }



    fileprivate func displayArrayString(from intArray: [Int]) {
        // This creates a new String representation of an [Int].
        var someString = "["
        let stringOfNumbers = intArray.map { String($0) }
            .joined(separator: ", ")
        someString = "[" + stringOfNumbers + "]"
        print("Resuling array: \(someString)")

        // arrayString is a @State variable that will let the user know how their entry looks.
        self.arrayString = someString
    }



    func readArrayEntry(from string: String) -> [Int] {
        let stringArray: [String]   = createStringArray(from: string)

        let floatArray: [Float]     = createRoundedFloatArray(from: stringArray)

        let intArray: [Int]         = createSortedUnsignedIntArray(from: floatArray)

        displayArrayString(from: intArray)

        return intArray
    }



    func twoSumsUsingLowAndHighIndices(of array: [Int], sum: Int) -> Bool {
        print("Input array: \(array)")
        var lowIndex  = 0
        var highIndex = array.count - 1

        while lowIndex < highIndex {
            let sumOfItems = array[lowIndex] + array[highIndex]

            if sumOfItems == sum {
                print("Sum of \(array[lowIndex]) and \(array[highIndex]) = \(sumOfItems), which is the desired sum of \(sum)")
                self.resultString = "\(array[lowIndex]) + \(array[highIndex]) = \(sumOfItems)"
                return true
            } else if sumOfItems < sum {
                lowIndex += 1
            } else if sumOfItems > sum {
                highIndex -= 1
            }
        }
        print("The low and high indices have crossed, so there is no solution from this array for the desired sum.")

        return false
    }
}




struct TwoSumsView_Previews: PreviewProvider {
    static var previews: some View {
        TwoSumsView()
    }
}
