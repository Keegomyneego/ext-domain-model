//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String {
    return _currency.rawValue
  }
  private var _currency : Currency

  public enum Currency : String {
    case CAN = "CAN"
    case EUR = "EUR"
    case GBP = "GBP"
    case USD = "USD"

    public func exchangeRate() -> Double {
      switch self {
      case .CAN: return 1.25
      case .EUR: return 1.5
      case .GBP: return 0.5
      case .USD: return 1
      }
    }
  }

  init!(amount: Int, currency: String) {
    guard let myCurrency = Currency(rawValue: currency) else {
      print("init failed: unrecognized currency '\(currency)'")
      return nil
    }

    self.amount = amount
    self._currency = myCurrency
  }

  public func convert(_ to: String) -> Money {
    guard let toCurr = Currency(rawValue: to) else {
      print("target currency '\(to)' unrecognized")
      return self
    }

    return convert(toCurr)
  }
  
  public func add(_ to: Money) -> Money {
    let newAmount = to.amount + self.convert(to._currency).amount

    return Money(amount: newAmount, currency: to.currency)
  }

  public func subtract(_ from: Money) -> Money {
    let newAmount = from.amount - self.convert(from._currency).amount

    return Money(amount: newAmount, currency: from.currency)
  }

  private func convert(_ to: Currency) -> Money {
    let newAmount = (Double(amount) / _currency.exchangeRate()) * to.exchangeRate()

    return Money(amount: Int(newAmount), currency: to.rawValue)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
  }
  
  open func raise(_ amt : Double) {
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { }
    set(value) {
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { }
    set(value) {
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
  }
  
  open func haveChild(_ child: Person) -> Bool {
  }
  
  open func householdIncome() -> Int {
  }
}



