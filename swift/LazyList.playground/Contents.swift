//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let arr = ["A", "B", "C", "D", "E"]
arr.first
print(arr.filter{ $0.characters.count == 1 }.map{ $0.lowercased() }.first)

let list: List<String> = ["A", "B", "C", "D", "E"]

print(list.filter{ $0.characters.count == 1 }.map{ $0.lowercased() }.car)

func factorialRec(number: Int) -> Int {
    if number == 1 {
        return number
    } else {
        return factorialRec(number: number - 1) * number
    }
}


func factorialTailRec(_ number: Int, _ factorial: Int = 1) -> TailCall<Int> {
    if number == 1 {
        return TailCall.done(factorial)
    }
    return TailCall.call{ factorialTailRec(number - 1, factorial * number) }
}

factorialTailRec(5).invoke()

let a: Int? = 1

a ?? 3

