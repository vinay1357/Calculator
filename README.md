# Calculator Swift Package
> A package that provides a calculator view and shows its result. Operators are feature flag driven, we can show and hide the operator on the basis of our requirements.


> 
>
## Screenshots

![](ipad_Potrait.png)
![](ipad.png)
![](iphone_Landscape.png)
![](iphone_Potrait.png)

### Features

1. Basic Operators
   +, _ , / *, sin and cos operators are available
   
2. Online Operator
    We used https://coinlayer.com/ API's to calculate the bit coin online operator
   
4. Feature Flag Driven
    Operators are drived from the the File "FeatureFlag.json"
```swift
{
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

4. Theme
   The foreground and background color of the UI is coming from the theme, We can change the theme for the whole UI by just like below
```swift
public enum Theme {
    public static var currentTheme  = Theme.theme1
    case theme1
    case theme2
}

Theme.currentTheme = Theme.theme2
```
5. App Structure
   This package has two dependent packages

   1. Reusable UI component  - CalculatorUIComponent - [https://github.com/vinay1357/CalculatorUIComponent](https://github.com/vinay1357/CalculatorUIComponent)
   2. Color Schemes - ThemeKit - [https://github.com/vinay1357/Themekit](https://github.com/vinay1357/ThemeKit)

## Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Add this project to your `Package.swift`

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
