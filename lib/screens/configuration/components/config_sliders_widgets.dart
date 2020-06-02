import 'package:flutter/material.dart';

class TemperatureNominaleSlider extends StatefulWidget {
  var sliderValue;

  TemperatureNominaleSlider(this.sliderValue);

  @override
  _TemperatureNominaleSlider createState() =>
      _TemperatureNominaleSlider(sliderValue);
}

class _TemperatureNominaleSlider extends State<TemperatureNominaleSlider> {
  var sliderValue;
  var minValue = 0.0;
  var maxValue = 50.0;

  _TemperatureNominaleSlider(this.sliderValue);
  @override
  Widget build(BuildContext context) {
    print(sliderValue);
    return new Slider(
      label: "${sliderValue.toStringAsFixed(1)}",
      min: minValue,
      max: maxValue,
      divisions: ((maxValue - minValue) * 2).round(),
      value: sliderValue,
      activeColor: Color(0xff512ea8),
      inactiveColor: Color(0xffac9bcc),
      onChanged: (newValue) {
        setState(() {
          sliderValue = newValue;
        });
      },
    );
  }
}

class TemperatureOKSlider extends StatefulWidget {
  double acceptableMin;
  double acceptableMax;
  TemperatureOKSlider(this.acceptableMin, this.acceptableMax);

  @override
  _TemperatureOKSlider createState() =>
      _TemperatureOKSlider(acceptableMin, acceptableMax);
}

class _TemperatureOKSlider extends State<TemperatureOKSlider> {
  RangeValues sliderValues; // = RangeValues(25.0, 35.0);
  double minValue = 0.0;
  double maxValue = 50.0;

  var acceptableMax;

  var acceptableMin;

  _TemperatureOKSlider(this.acceptableMin, this.acceptableMax) {
    sliderValues = RangeValues(acceptableMin, acceptableMax);
  }

  @override
  Widget build(BuildContext context) {
    return new RangeSlider(
      labels: RangeLabels('${sliderValues.start.toStringAsFixed(1)}',
          '${sliderValues.end.toStringAsFixed(1)}'),
      values: sliderValues,
      min: minValue,
      max: maxValue,
      divisions: ((maxValue - minValue) * 2).round(),
      activeColor: Color(0xff512ea8),
      inactiveColor: Color(0xffac9bcc),
      onChanged: (newValues) {
        setState(() {
          print(newValues);
          sliderValues = newValues;
        });
      },
    );
  }
}

class TemperatureMinSlider extends StatefulWidget {
  double criticalMin;
  TemperatureMinSlider(this.criticalMin);

  @override
  _TemperatureMinSlider createState() => _TemperatureMinSlider(criticalMin);
}

class _TemperatureMinSlider extends State<TemperatureMinSlider> {
  var minValue = 0.0;
  var maxValue = 50.0;
  var criticalMin;

  _TemperatureMinSlider(this.criticalMin);
  @override
  Widget build(BuildContext context) {
    return new Slider(
      label: "${criticalMin.toStringAsFixed(1)}",
      min: minValue,
      max: maxValue,
      divisions: ((maxValue - minValue) * 2).round(),
      value: criticalMin,
      activeColor: Color(0xff512ea8),
      inactiveColor: Color(0xffac9bcc),
      onChanged: (newValue) {
        setState(() {
          criticalMin = newValue;
        });
      },
    );
  }
}

class TemperatureMaxSlider extends StatefulWidget {
  double criticalMax;
  TemperatureMaxSlider(this.criticalMax);

  @override
  _TemperatureMaxSlider createState() => _TemperatureMaxSlider(criticalMax);
}

class _TemperatureMaxSlider extends State<TemperatureMaxSlider> {
  var minValue = 0.0;
  var maxValue = 50.0;
  var criticalMax;

  _TemperatureMaxSlider(this.criticalMax);
  @override
  Widget build(BuildContext context) {
    return new Slider(
      label: "${criticalMax.toStringAsFixed(1)}",
      min: minValue,
      max: maxValue,
      value: criticalMax,
      divisions: ((maxValue - minValue) * 2).round(),
      activeColor: Color(0xff512ea8),
      inactiveColor: Color(0xffac9bcc),
      onChanged: (newValue) {
        setState(() {
          criticalMax = newValue;
        });
      },
    );
  }
}
