import '../constant/navigation_constant.dart';
import 'package:flutter/material.dart';

class ErrorHandlePage {
  static Widget getErrorWidget(
      BuildContext context, FlutterErrorDetails error) {
    return Center(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.orangeAccent,
              size: 60,
            ),
            Text("Oops..."),
            Text("Something went wrong!"),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: Text("Go to home"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        NavigationConstant.DRAWER_PAGE,
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
