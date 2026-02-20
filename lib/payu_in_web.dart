import 'dart:convert';
import 'package:web/web.dart';
import 'package:crypto/crypto.dart';

/// This plugin was built keeping payments within the Indian subcontinent in mind.
/// Please checkout the documentation on [PayU](https://docs.payu.in/docs/custom-checkout-merchant-hosted).
class FlutterPayuWeb {
  /// Using [pg] and [bankcode] you may launch any supported payment flows directly.
  ///
  /// Use [enforcePaymentMethod] to limit available payment methods for your users.
  /// The format follows: `'netbanking|creditcard|debitcard'`.
  static void checkout({
    required String merchantKey,
    required String salt,
    required String transactionId,
    required double amountAsDouble,
    required String product,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String sUrl,
    required String fUrl,
    bool isProd = false,
    bool launchNewTab = false,
    String udf1 = "",
    String udf2 = "",
    String udf3 = "",
    String udf4 = "",
    String udf5 = "",
    String udf6 = "",
    String udf7 = "",
    String udf8 = "",
    String udf9 = "",
    String udf10 = "",
    String address1 = "",
    String address2 = "",
    String city = "",
    String state = "",
    String country = "",
    String zipcode = "",
    String pg = "",
    String bankcode = "",
    String vpa = "",
    String ccnum = "",
    String ccname = "",
    String ccvv = "",
    String ccexpmon = "",
    String ccexpyr = "",
    String enforcePaymentMethod = "",
    List<PayUTPVBeneficiary>? beneficiaryDetails,
  }) {
    // Assertions for TPV-NB
    assert(
      beneficiaryDetails != null
          ? ((pg == "NB" || pg == "TESTNB") && bankcode.contains("TPV"))
          : true,
      "Please check the Payu TPV documentation at https://docs.payu.in/docs/net-banking-integration-for-tpv",
    );
    // Assertions for NetBanking
    assert(
      (pg == "NB" || pg == "TESTNB")
          ? (bankcode.isNotEmpty &&
              (isProd
                  ? (!pg.startsWith("TEST") && !bankcode.startsWith("TEST"))
                  : (pg.startsWith("TEST") && bankcode.startsWith("TEST"))))
          : true,
      "Please check the Payu Netbanking documentation at https://docs.payu.in/docs/collect-payments-with-net-banking-seamless",
    );
    // Assertions for Cards
    assert(
      (pg == "CC" || pg == "TESTCC")
          ? (bankcode.isNotEmpty &&
              ccnum.isNotEmpty &&
              ccname.isNotEmpty &&
              ccvv.isNotEmpty &&
              ccexpmon.isNotEmpty &&
              ccexpyr.isNotEmpty)
          : true,
      "Please check the Payu Cards documentation at https://docs.payu.in/docs/collect-payments-with-cards-seamless",
    );
    // Assertions for UPI
    assert(
      (pg == "UPI" || pg == "TESTUPI")
          ? (bankcode == "UPI" && vpa.isNotEmpty)
          : true,
      "Please check the Payu Cards documentation at https://docs.payu.in/docs/collect-payments-with-upi-seamless",
    );
    final amount = amountAsDouble.toStringAsFixed(2);
    final txnid = transactionId;

    // Doesn't include the beneficiary details block because at the
    // time of testing and release the hash wasn't being calculated right
    // with inclusion but, was found working without.
    final hashingString =
        "$merchantKey|$txnid|$amount|$product|$firstName|$email|$udf1|$udf2|$udf3|$udf4|$udf5||||||$salt";
    final hash = sha512.convert(utf8.encode(hashingString));

    final checkoutUrl = isProd
        ? "https://secure.payu.in/_payment"
        : "https://test.payu.in/_payment";

    final form = (document.createElement('form') as HTMLFormElement)
      ..method = 'POST'
      ..action = checkoutUrl
      ..target = launchNewTab ? '_blank' : '_self';

    final fields = {
      'key': merchantKey,
      'txnid': txnid,
      'productinfo': product,
      'amount': amount,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
      'surl': sUrl,
      'furl': fUrl,
      'pg': pg,
      'bankcode': bankcode,
      'ccnum': ccnum,
      'ccname': ccname,
      'ccvv': ccvv,
      'ccexpmon': ccexpmon,
      'ccexpyr': ccexpyr,
      'udf1': udf1,
      'udf2': udf2,
      'udf3': udf3,
      'udf4': udf4,
      'udf5': udf5,
      'udf6': udf6,
      'udf7': udf7,
      'udf8': udf8,
      'udf9': udf9,
      'udf10': udf10,
      'hash': hash,
      if (enforcePaymentMethod.isNotEmpty) ...{
        'enforce_paymethod': enforcePaymentMethod,
      },
      if (beneficiaryDetails != null && beneficiaryDetails.isNotEmpty) ...{
        "beneficiarydetail":
            jsonEncode(_getBeneficiaryDetails(beneficiaryDetails))
      },
      if (vpa.isNotEmpty) ...{
        "vpa": vpa,
      },
    };

    fields.forEach(
      (key, value) {
        final input = (document.createElement('input') as HTMLInputElement)
          ..type = 'hidden'
          ..name = key
          ..value = value.toString();
        form.append(input);
      },
    );

    document.body?.append(form);
    form.submit();
    form.remove();
  }

  static Map<String, String> _getBeneficiaryDetails(
      List<PayUTPVBeneficiary> beneficiaryDetails) {
    final accounts = List.empty(growable: true);
    final ifsc = List.empty(growable: true);
    for (var item in beneficiaryDetails) {
      accounts.add(item.beneficiaryAccountNumber);
      ifsc.add(item.ifscCode);
    }
    return {
      "beneficiaryAccountNumber": accounts.join("|"),
      "ifscCode": ifsc.join("|"),
    };
  }
}

class PayUTPVBeneficiary {
  final String beneficiaryAccountNumber;
  final String ifscCode;

  PayUTPVBeneficiary({
    required this.beneficiaryAccountNumber,
    required this.ifscCode,
  });

  Map<String, String> get asMap => {
        "beneficiaryAccountNumber": beneficiaryAccountNumber,
        "ifscCode": ifscCode,
      };
}
