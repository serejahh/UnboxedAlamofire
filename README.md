# UnboxedAlamofire

[Alamofire](https://github.com/Alamofire/Alamofire) + [Unbox](https://github.com/JohnSundell/Unbox): the easiest way to download and decode JSON into swift objects.

## Installation

### [CocoaPods](https://cocoapods.org/)

```
pod 'UnboxedAlamofire', '~> 1.0'
```

### [Carthage](https://github.com/Carthage/Carthage)

```
github "serejahh/UnboxedAlamofire" ~> 1.0
```

## Usage

Objects you request have to conform [Unboxable](https://github.com/JohnSundell/Unbox#basic-example) protocol.

### Get an object

``` swift
Alamofire.request(.GET, url).responseObject { (response: Response<Candy, NSError>) in
	let candy = response.result.value
}
```

### Get an array

``` swift
Alamofire.request(.GET, url).responseArray { (response: Response<[Candy], NSError>) in
	let candies = response.result.value
}
```

### KeyPath

Also you can specify a keypath in both requests:

``` swift
Alamofire.request(.GET, url).responseObject(keyPath: "response") { (response: Response<Candy, NSError>) in
	let candy = response.result.value
}
```
