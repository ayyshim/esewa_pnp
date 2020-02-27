# esewa_pnp_example

[![pub package](https://img.shields.io/badge/pub-v.0.1.0-green)](https://pub.dartlang.org/packages/esewa_pnp) 

**esewa_pnp** is a flutter plugin that let&#x27;s developer to integrate native [eSewa](https://www.esewa.com.np) payment method into their flutter application with just few lines of code.

## How to install

* Add following attribute inside your AndroidMainfest.xml

  ```xml
   <application
      ...
  	android:theme="@style/Theme.AppCompat.Light.NoActionBar"
      ...>
  ...
  </application>
  
  ```

  

## Usage

1. Create a **ESewaConfiguration** object. Start with test environment. When application is ready, you can switch it to live (ENVIRONMENT_LIVE)

```dart
...

ESewaConfiguration _configuration = ESewaConfiguration(
	clientID: "<Client-ID>",
    secretKey: "<Secret-Key>",
    environment: ESewaConfiguration.ENVIRONMENT_TEST //ENVIRONMENT_LIVE
);
```

> `clientID` and `secretKey` values are provided by eSewa to its merchant/client and is unique for each. For development phase, you can use the following credentials:
>
> `clientID:` "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R"
>
> `secretKey:` "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ=="

2. Create **ESewaPnp** object and pass configuration.

```dart
...
ESewaPnp _eSewaPnp = ESewaPnp(configuration: _configuration);
```

3. Finally create the payment object

```dart
...
ESewaPayment _payment = ESewaPayment(
	amount: <ANY_INTEGER_VALUE>,
    productName: "<Product-Name>",
    productID: "<Unique-Product-ID>",
    callBackURL: "<Call-Back-URL>"
);
```

4. Now call `initPayment` method.

```dart
...
final _res = await _eSewaPnp.initPayment(payment: _payment);
```

`initPayment` will return an `Either` type (ref. [dart functional programming with dartz](https://pub.dev/packages/dartz)) . Response can be either `Failure` type or `Result` type.

`Failure` type indicates the payment process fail.

`Result` type indicates the successful payment.



5. Determine application behavior according to the response

```dart
...
_res.fold(
	(l) {
		// TODO:: Stuffs after failure.
	},
	(r) {
		// TODO:: Stuffs after successful payment.
	}
);
```



### ❌ Failure

Failure class is returned when payment process fails.

* `.message` [String] : returns the error message

### ✅ Result

Result class is returned when payment process successful.

* `.message` [String] : returns readable success message
* `.productId` [String] : returns product id of the product customer paid for
* `.productName` [String] : returns product name of the product customer paid for
* `.totalAmount` [String] : returns total amount customer paid
* `.date` [String] : returns the date of transaction
* `.status` [String] : returns the transaction status
* `.referenceId` [String] : returns the transaction reference id



## 👨‍🦱 Author

**[Ashim Upadhaya](https://www.github.com/ayyshim)**

> This plugin can only be used on android platform because I don't have mac.