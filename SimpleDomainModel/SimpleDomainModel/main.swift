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
public struct Money : CustomStringConvertible {
  public var amount : Int
  public var currency : String {
    return _currency.rawValue
  }
  private var _currency : Currency

  public var description : String {
    return "\(currency)\(amount)"
  }

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

  init(amount: Int, currency: String) {
    self.amount = amount
    self._currency = Currency(rawValue: currency)!
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
open class Job : CustomStringConvertible {
  fileprivate var title : String
  fileprivate var type : JobType

  public var description : String {
    return "\(title)"
  }

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hourlyIncome):
      return Int(hourlyIncome * Double(hours))
    case .Salary(let annualIncome):
      return annualIncome
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hourlyIncome):
      self.type = .Hourly(hourlyIncome + amt)
    case .Salary(let annualIncome):
      self.type = .Salary(Int(Double(annualIncome) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person : CustomStringConvertible {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  public var description : String {
    return "\(firstName) \(lastName)"
  }

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
      if age >= 16 {
        _job = value
      }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
      if age >= 18 {
        _spouse = value
      }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    let jobString = job?.title ?? "nil"
    let spouseString = spouse?.firstName ?? "nil"

    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobString) spouse:\(spouseString)]"
  }
}

////////////////////////////////////
// Family
//
open class Family : CustomStringConvertible {
  private static let legalAge = 21

  private let spouses: [Person] = []
  fileprivate var members : [Person] = []

  public var description : String {
    return "The family of \(members)"
  }

  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse != nil || spouse2.spouse != nil {
      print("both spouses must be unmarried before creating a family")
      return
    }

    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    members = [spouse1, spouse2]
  }
  
  open func haveChild(_ child: Person) -> Bool {
    let spousesAreOfLegalAge = spouses.reduce(true, { $0 && ($1.age >= Family.legalAge) })

    if spousesAreOfLegalAge {
      members.append(child)
      return true
    } else {
      return false
    }
  }
  
  open func householdIncome() -> Int {
    return members.reduce(0, { $0 + ($1.job?.calculateIncome(2000) ?? 0) })
  }
}



