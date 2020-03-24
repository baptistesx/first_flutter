import 'package:flutter/material.dart';

class TemperatureNominaleSlider extends StatefulWidget {
  @override
  _TemperatureNominaleSlider createState() => _TemperatureNominaleSlider();
}

class _TemperatureNominaleSlider extends State<TemperatureNominaleSlider> {
  var sliderValue = 0.0;
  var minValue = 0.0;
  var maxValue = 50.0;
  @override
  Widget build(BuildContext context) {
    return new Slider(
      label: "${sliderValue.toStringAsFixed(1)}",
      min: minValue,
      max: maxValue,
      divisions: ((maxValue-minValue)*2).round(),
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
  @override
  _TemperatureOKSlider createState() => _TemperatureOKSlider();
}

class _TemperatureOKSlider extends State<TemperatureOKSlider> {
  RangeValues sliderValues = RangeValues(0.0, 1.0);
  var minValue = 0.0;
  var maxValue = 10.0;

  @override
  Widget build(BuildContext context) {
    return new RangeSlider(
      labels: RangeLabels("ok", "ko"),//sliderValues.start.toStringAsFixed(1), sliderValues.end.toStringAsFixed(1)),
      min: minValue,
      max: maxValue,
      divisions: 2,//((maxValue-minValue)*2).round(),
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
  @override
  _TemperatureMinSlider createState() => _TemperatureMinSlider();
}

class _TemperatureMinSlider extends State<TemperatureMinSlider> {
  var sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return new Slider(
      min: 0.0,
      max: 100.0,
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

class TemperatureMaxSlider extends StatefulWidget {
  @override
  _TemperatureMaxSlider createState() => _TemperatureMaxSlider();
}

class _TemperatureMaxSlider extends State<TemperatureMaxSlider> {
  var sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return new Slider(
      min: 0.0,
      max: 100.0,
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
