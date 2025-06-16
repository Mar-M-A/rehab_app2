import 'package:flutter/material.dart';

class Metrics
{
    final String metricName; 
    final double value;

    Metrics({required this.metricName, required this.value});
    
    factory Metrics.fromJson(Map<String, dynamic> json)
    {
        return Metrics(
            metricName: json['metricName'],
            value: json['value'],
        );
    }
}