import 'package:flutter/material.dart';

InputDecoration inputDecoration(
    {required hint}) {
  return InputDecoration(
    hintText: hint,

    hintStyle:
    const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    labelStyle: const TextStyle(color: Colors.black),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
  );
}