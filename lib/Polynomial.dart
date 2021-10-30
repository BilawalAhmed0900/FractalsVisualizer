import 'package:equations/equations.dart';

class Polynomial {
  late DurandKerner _durandKerner;
  Polynomial._(List<Complex> coefficients) {
    _durandKerner = DurandKerner(coefficients: coefficients);
  }

  Polynomial(String polynomialString) {
    List<String> tokens = polynomialString.split(";");
    List<Complex> terms = List<Complex>.empty(growable: true);

    double previousPower = -1;
    for (String token in tokens) {
      RegExp regExp = RegExp(r"\(([0-9\.\-\+]+)\,([0-9\.\-\+]+)\)");
      RegExpMatch? match = regExp.firstMatch(token);
      if (match == null) {
        throw Exception("Invalid polynomial string");
      }

      double? power = double.tryParse(match.group(2)!);
      if (power == null) {
        throw Exception("Invalid polynomial string");
      }

      if (previousPower == -1) {
        previousPower = power;
      } else {
        if (power != previousPower - 1) {
          throw Exception("Invalid polynomial string");
        }

        previousPower--;
      }

      double? coefficient = double.tryParse(match.group(1)!);
      if (coefficient == null) {
        throw Exception("Invalid polynomial string");
      }

      Complex complex = Complex.fromReal(coefficient);
      terms.add(complex);
    }

    _durandKerner = DurandKerner(coefficients: terms);
  }

  @override
  String toString() {
    return _durandKerner.toString();
  }

  int get degree {
    return _durandKerner.degree;
  }

  Polynomial getDerivative() {
    return Polynomial._(_durandKerner.derivative().coefficients);
  }

  Complex putValue(Complex value) {
    return _durandKerner.evaluateOn(value);
  }

  List<Complex> getRoots() {
    return _durandKerner.solutions();
  }
}