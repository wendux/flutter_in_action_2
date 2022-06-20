import 'package:flutter/material.dart';

class ImageAndIconRoute extends StatelessWidget {
  const ImageAndIconRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var img = const AssetImage("imgs/avatar.png");
    return SingleChildScrollView(
      child: Column(
          children: <Image>[
        Image(
          image: img,
          height: 50.0,
          width: 100.0,
          fit: BoxFit.fill,
        ),
        Image(
          image: img,
          height: 50,
          width: 50.0,
          fit: BoxFit.contain,
        ),
        Image(
          image: img,
          width: 100.0,
          height: 50.0,
          fit: BoxFit.cover,
        ),
        Image(
          image: img,
          width: 100.0,
          height: 50.0,
          fit: BoxFit.fitWidth,
        ),
        Image(
          image: img,
          width: 100.0,
          height: 50.0,
          fit: BoxFit.fitHeight,
        ),
        Image(
          image: img,
          width: 100.0,
          height: 50.0,
          fit: BoxFit.scaleDown,
        ),
        Image(
          image: img,
          height: 50.0,
          width: 100.0,
          fit: BoxFit.none,
        ),
        Image(
          image: img,
          width: 100.0,
          color: Colors.blue,
          colorBlendMode: BlendMode.difference,
          fit: BoxFit.fill,
        ),
        Image(
          image: img,
          width: 100.0,
          height: 200.0,
          repeat: ImageRepeat.repeatY,
        )
      ].map((e) {
        return Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 100,
                child: e,
              ),
            ),
            Text(e.fit.toString())
          ],
        );
      }).toList()),
    );
  }
}

class IconFontsRoute extends StatelessWidget {
  const IconFontsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text(
          '\uE287' * 20,
          style: const TextStyle(
            fontFamily: "MaterialIcons",
            fontSize: 24.0,
            color: Colors.green,
          ),
        ),
        showIcons(),
      ],
    );
  }

  Widget showIcons() {
    String icons = "";
    // accessible: 0xe03e
    icons += "\uE03e";
    // error:  0xe237
    icons += " \uE237";
    // fingerprint: 0xe287
    icons += " \uE287";

    return Text(
      icons,
      style: const TextStyle(
        fontFamily: "MaterialIcons",
        fontSize: 24.0,
        color: Colors.green,
      ),
    );
  }
}
