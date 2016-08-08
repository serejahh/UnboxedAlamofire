# UnboxedAlamofire

[![Build Status](https://travis-ci.org/serejahh/UnboxedAlamofire.svg?branch=master)](https://travis-ci.org/serejahh/UnboxedAlamofire)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/UnboxedAlamofire.svg)](https://img.shields.io/cocoapods/v/UnboxedAlamofire.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/UnboxedAlamofire.svg?style=flat)](http://cocoadocs.org/docsets/UnboxedAlamofire)

[Alamofire](https://github.com/Alamofire/Alamofire) + [Unbox](https://github.com/JohnSundell/Unbox): the easiest way to download and decode JSON into swift objects.

## Features

- [x] Unit tested
- [x] Fully documented
- [x] Mapping response to objects
- [x] Mapping response to array of objects
- [x] Keypaths
- [x] Nested keypaths

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

## Installation

### [CocoaPods](https://cocoapods.org/)

```
pod 'UnboxedAlamofire', '~> 1.0'
```

### [Carthage](https://github.com/Carthage/Carthage)

```
github "serejahh/UnboxedAlamofire" ~> 1.0
```
