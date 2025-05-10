# payu_in_web

Web-only PayU payment gateway implementation for Flutter projects. The gateway was built following through the guidelines implemented by PayU India.

Please check-out the PayU IN documentation at https://docs.payu.in/docs/custom-checkout-merchant-hosted.

Cusotm implementation of `pg`, `bankcode` and `enforcePaymentMethod` allows for further flow customisation.

## Usage

```dart
    FlutterPayuWeb.checkout(
      merchantKey: "",
      salt: "",
      transactionId: "PAYUTST${DateTime.timestamp().millisecondsSinceEpoch}",
      amountAsDouble: 10,
      product: "demo",
      firstName: "TEST",
      lastName: "USER",
      email: "testuser@dummy.com",
      phone: "9090909090",
      sUrl: "https://cbjs.payu.in/sdk/success",
      fUrl: "https://cbjs.payu.in/sdk/failure",
      launchNewTab: true,
      pg: "TESTNB",
      bankcode: "TESTHDFC",
      enforcePaymentMethod: 'netbanking|creditcard|debitcard',
    );
```

## Future plans

I've implemented the gateway to be directly injected with raw values into fields. If this package gets enough likes I'll make the gateway implmentation include enums and thus, make the implementation more developer friendly.