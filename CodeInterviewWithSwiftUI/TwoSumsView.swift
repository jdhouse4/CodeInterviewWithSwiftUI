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


    var body: some View {
        VStack(alignment: .center, spacing: 20) {
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

            VStack(alignment: .leading, spacing: 40) {
                Spacer()

                HStack(alignment: .lastTextBaseline, spacing: 20) {
                    Text("""
                        Enter an array of positive, real numbers
                        (seperated by ", ") :
                        """)
                        .frame(width: 200)
                        .padding(5)

                    TextField("",
                              text: $numberString)
                    { isEditing in
                        self.isEditing = isEditing
                    } onCommit: {
                        self.array = readArray(from: self.numberString)
                        print("Array: \(self.array)")
                        self.arrayEntered = true
                    }
                }


                //
                // This area displays the above entered array of strings as rounded Int's.
                //
                HStack(alignment: .lastTextBaseline, spacing: 20) {
                    Text("Array: ")
                        .padding(5)


                    Text(arrayString)
                        .padding(5)

                }

                VStack(alignment: .leading, spacing: 40) {
                    //
                    // This area is for entering the desired sum.
                    //
                    HStack(alignment: .lastTextBaseline, spacing: 0) {

                        Text("Desired sum:")
                            .padding(5)

                        TextField("50",
                                  value: $desiredSum,
                                  formatter: NumberFormatter())
                        { isEditing in
                            self.isEditing = isEditing
                        } onCommit: {
                            self.result = self.twoSumsUsingLowAndHighIndices(of: self.array, sum: self.desiredSum)
                        }
                        //.frame(width: 100)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .padding(5)

                    }


                    /*
                     HStack(alignment: .lastTextBaseline, spacing: 10) {
                     Text("Result:")

                     Text(String(self.result))
                     .frame(width: 120, alignment: .trailing)
                     }
                     */


                    HStack(alignment: .lastTextBaseline, spacing: 10) {
                        Text("Solution:")
                            .padding(5)

                        Text(result ? resultString : "None")
                            //.frame(width: 100, alignment: .trailing)
                            .padding(5)
                    }
                }
                .opacity(self.arrayEntered ? 1 : 0.5)
                .disabled(self.arrayEntered ? false : true)

                Spacer()
            }
        }
    }



    func readArray(from string: String) -> [Int] {
        print("Initial array: \(string)")

        let characterSet    = CharacterSet(charactersIn: ", ")

        var stringArray     = string.components(separatedBy: characterSet)
        print("stringArray: \(stringArray)")

        // Clean-up by removing any "" from stringArray
        stringArray.removeAll(where: { $0 == "" })

        // This converts string array elements into rounded Floats in case the user entered a float.
        var floatArray: [Float] = []
        for item in stringArray {
            floatArray.append(Float(item)?.rounded(.toNearestOrAwayFromZero) ?? 0)
        }

        // This converts the Float array elements into Ints, which is the desired final output.
        var intArray: [Int]     = []

        for item in floatArray {
            intArray.append(Int(item))
        }

        intArray.sort()

        //self.arrayString = stringArray
        var someString = "["
        let stringOfNumbers = intArray.map { String($0) }
            .joined(separator: ", ")
        someString = "[" + stringOfNumbers + "]"
        self.arrayString = someString
        //print("Resuling array: \(self.arrayString)")

        print("Resultant Array of Int's: \(intArray)")

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
