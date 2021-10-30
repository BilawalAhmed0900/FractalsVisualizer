import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:equations/equations.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as ExternalImage;

import 'Polynomial.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: MainSafeArea(),
      ),
    );
  }
}

class MainSafeArea extends StatefulWidget {
  MainSafeArea({Key? key}) : super(key: key);

  @override
  _MainSafeAreaState createState() => _MainSafeAreaState();
}

class _MainSafeAreaState extends State<MainSafeArea> {
  bool processButtonEnabled = true;
  TextEditingController polynomialController = TextEditingController();
  TextEditingController stepsController =
      TextEditingController(text: 333.toString());
  TextEditingController widthController =
      TextEditingController(text: 1200.toString());
  TextEditingController heightController =
      TextEditingController(text: 900.toString());

  List<int> imageBytes = List<int>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    imageBytes.addAll(Base64Codec()
        .decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"));
  }

  @override
  void dispose() {
    polynomialController.dispose();
    stepsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
                flex: 2,
              ),
              Expanded(
                child: Text("Polynomial:"),
                flex: 9,
              ),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: polynomialController,
                    decoration: InputDecoration(
                        filled: true,
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        hintText:
                            "Example: write 7x4+8x2+9x-8 as (7,4);(0,3);(8,2);(9,1);(-8,0);"),
                  ),
                ),
                flex: 88,
              ),
              Expanded(
                child: SizedBox(),
                flex: 2,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
                flex: 2,
              ),
              Expanded(
                child: Text("Steps:"),
                flex: 9,
              ),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: stepsController,
                    decoration: InputDecoration(
                        filled: true,
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        hintText: "Default: 333"),
                  ),
                ),
                flex: 88,
              ),
              Expanded(
                child: SizedBox(),
                flex: 2,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
                flex: 5,
              ),
              Expanded(
                child: Image.memory(
                  Uint8List.fromList(imageBytes),
                  height: height * 0.78,
                  filterQuality: FilterQuality.high,
                ),
                flex: 90,
              ),
              Expanded(
                child: SizedBox(),
                flex: 5,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(),
                flex: 5,
              ),
              Expanded(
                child: Text("Width: "),
                flex: 6,
              ),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: widthController,
                    decoration: InputDecoration(
                        filled: true,
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        hintText: "Default: 1200"),
                  ),
                ),
                flex: 16,
              ),
              Expanded(
                child: SizedBox(),
                flex: 5,
              ),
              Expanded(
                child: Text("Height: "),
                flex: 6,
              ),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: heightController,
                    decoration: InputDecoration(
                        filled: true,
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        hintText: "Default: 900"),
                  ),
                ),
                flex: 16,
              ),
              Expanded(
                child: SizedBox(),
                flex: 56,
              ),
              Expanded(
                child: TextButton(
                  child:
                      Text(processButtonEnabled ? "Process" : "Processing..."),
                  onLongPress: null,
                  style: TextButton.styleFrom(backgroundColor: Colors.white10),
                  onPressed: processButtonEnabled
                      ? () {
                          setState(() {
                            processButtonEnabled = false;
                          });
                          processButton(
                                  polynomialController.text,
                                  stepsController.text,
                                  widthController.text,
                                  heightController.text,
                                  imageBytes,
                                  context)
                              .then((value) {
                            setState(() {
                              processButtonEnabled = true;
                            });
                          });
                        }
                      : null,
                ),
                flex: 10,
              ),
              Expanded(
                child: SizedBox(),
                flex: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showDialogOnContext(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      });
}

class Params {
  final int width, height, steps;
  final Polynomial polynomial, derivative;
  final List<Complex> roots;
  final HashMap<Complex, Color> mapRootToColor;
  final SendPort sendPort;

  Params(this.width, this.height, this.steps, this.polynomial, this.derivative,
      this.roots, this.mapRootToColor, this.sendPort);
}

num abstract(num n) {
  if (n < 0) return -n;

  return n;
}

void getFractalImage(Params params) {
  ExternalImage.Image image = ExternalImage.Image(params.width, params.height);

  int xMin = -params.width ~/ 2;
  int xMax = params.width ~/ 2;
  int yMin = -params.height ~/ 2;
  int yMax = params.height ~/ 2;
  for (int x = xMin; x < xMax; x++) {
    for (int y = yMin; y < yMax; y++) {
      Complex number = Complex(x.toDouble(), y.toDouble());
      for (int step = 0; step < params.steps; step++) {
        Complex derivativePutValue = params.derivative.putValue(number);
        if (!derivativePutValue.isZero) {
          number -= (params.polynomial.putValue(number) / derivativePutValue);
        } else {
          break;
        }
      }

      double distance = double.infinity;
      late Complex closestRoot;
      for (final Complex root in params.roots) {
        double curDistance =
            (((number.real - root.real) * (number.real - root.real)) +
                    ((number.imaginary - root.imaginary) *
                        (number.imaginary - root.imaginary)))
                .toDouble();
        if (curDistance < distance) {
          distance = curDistance;
          closestRoot = root;
        }
      }

      image.setPixelRgba(
          x + xMax,
          y + yMax,
          params.mapRootToColor[closestRoot]!.red,
          params.mapRootToColor[closestRoot]!.green,
          params.mapRootToColor[closestRoot]!.blue,
          197);
    }
  }

  params.sendPort.send(image);
}

Future<void> processButton(
    String polynomialString,
    String stepsString,
    String widthString,
    String heightString,
    List<int> bytesToWriteTo,
    BuildContext context) async {
  int width = int.tryParse(widthString) ?? 1200;
  int height = int.tryParse(heightString) ?? 900;
  int steps = int.tryParse(stepsString) ?? 40;

  try {
    Polynomial polynomial = Polynomial(polynomialString);
    Polynomial derivative = polynomial.getDerivative();
    List<Complex> roots = polynomial.getRoots();

    Random random = Random();
    HashMap<Complex, Color> mapRootToColor = HashMap();
    for (final Complex root in roots) {
      mapRootToColor[root] =
          Colors.primaries[random.nextInt(Colors.primaries.length)];
    }

    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(
        getFractalImage,
        Params(width, height, steps, polynomial, derivative, roots,
            mapRootToColor, receivePort.sendPort));

    ExternalImage.Image image = await receivePort.first as ExternalImage.Image;

    List<int> imageBytes = ExternalImage.encodePng(image);

    File file = File(
        "FractalImageGenerated-${DateTime.now().toUtc().millisecondsSinceEpoch}.png");
    file.writeAsBytesSync(imageBytes, flush: true);

    bytesToWriteTo.clear();
    bytesToWriteTo.addAll(imageBytes);
  } on Exception catch (e) {
    showDialogOnContext(context, "Error", e.toString());
  }
}
