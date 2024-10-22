import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency = "USD";

  CryptoVal btcVal = CryptoVal();
  CryptoVal ethVal = CryptoVal();
  CryptoVal ltcVal = CryptoVal();
  List<Widget> cryptoSections = [];
  Map<String, CryptoVal> cryptoVals = {};

  DropdownButton getAndroid() {
    List<DropdownMenuItem> dropdownMenuItems = [];
    for (String currency in currenciesList) {
      dropdownMenuItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }
    return DropdownButton(
        value: currency,
        items: dropdownMenuItems,
        onChanged: (value) {
          setState(() {
            setCryptoSections();

            currency = value!;
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    cryptoVals = {
      "BTC": btcVal,
      "ETH": ethVal,
      "LTC": ltcVal,
    };
    setCryptoSections();

    super.initState();

  }

  CupertinoPicker getIOS() {
    List<Widget> currencyWidgets = [];
    for (String currency in currenciesList) {
      currencyWidgets.add(Text(currency));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (value) {
          currency = currenciesList[value];
          setCryptoSections();
        },
        children: currencyWidgets);
  }


  void setVal(crypto, val){
    if(crypto == "ETH"){
        setState(() {
          ethVal = CryptoVal(val: val);
        });
    } else if(crypto == "BTC"){
      setState(() {
        btcVal = CryptoVal(val: val);
      });
    } else {
      setState(() {
        ltcVal = CryptoVal(val: val);
      });
    }
  }
  void setCryptoSections() async {
    Map<String, String> allVals = {};

    for (String crypto in cryptoList) {
      cryptoVals[crypto] = CryptoVal(val: "?");

      String url =
          "https://rest.coinapi.io/v1/exchangerate/${crypto}/$currency?apikey=4D0B96B2-C97C-4772-8CE1-6C89AA00AA11";
      var data = await http.get(Uri.parse(url));
      print(data.body);
      Map decodedData = jsonDecode(data.body);
      setState(() {
        print("we done out here");
        allVals[crypto] = "${decodedData['rate'].toStringAsFixed(2)} $currency";

        // cryptoVals[crypto] = CryptoVal(val:"${decodedData['rate']} $currency");
      });
    }
    allVals.forEach(
            (k,v) {
              setVal(k, v);

            }
    );


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 5, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 BTC = ${btcVal.val}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),Padding(
              padding: EdgeInsets.fromLTRB(18.0, 5, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 ETH = ${ethVal.val}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),Padding(
              padding: EdgeInsets.fromLTRB(18.0, 5, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 LTC = ${ltcVal.val}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: (Platform.isIOS) ? getIOS() : getAndroid(),
            ),
          ]),
    );
  }
}

// DropdownButton(
// value: currency,
// items: dropdownMenuItems,
// onChanged: (value) {
// setState(() {
// currency = value!;
// });
// },
// ),

class CryptoVal {

  CryptoVal({this.val = "?"});
  String val = "?";
}