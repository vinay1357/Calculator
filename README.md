# Calculator Swift Package
> A package that provide a calculator view and shows its result. Operators are feature flag driven, we can show and hide the operator on the basis on our requirement
>
```swift
> {
    "calculator": {
        "showPlusOperatorr": true,
        "showMinusOperator": true,
        "showMultiplyOperator": true,
        "showDivisionOperator": true,
        "showEqualOperator": false,
        "showSinOperator": false,
        "showCosOperator": false,
        "showOnlineOperator": false
    }
}
```
> 
>
##Screenshots
![](ipad_Potrait.png)
![](ipad.png)
![](iphone_Landscape.png)
![](iphone_Potrait.png)



## Installation

Add this project on your `Package.swift`

```swift
import Calculator

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/vinay1357/Calculator", majorVersion: 0, minor: 0)
    ]
)
```


## Usage Example

A test app is avalable at https://github.com/vinay1357/Assignment_Calculator_Test_App


```swift
import Calculator

@main
struct Assignment_CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView()
        }
    }
}
```
