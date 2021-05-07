import 'dart:convert';
import 'dart:typed_data';

import 'package:ChaTho_Anatomy/models/TissueImage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel {
  static buildTissueImageCarousel(
      BuildContext context, List<TissueImage> images) {
    List<Uint8List> byteImages =
        images.map((i) => Base64Decoder().convert(i.image)).toList();

    return Expanded(
      child: ListView(
        children: [
          CarouselSlider(
            items: List.generate(byteImages.length, (index) {
              return SizedBox(
                child: Image.memory(
                  byteImages[index],
                ),
              );
            }),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.45,
              autoPlayInterval: Duration(seconds: 7),
              autoPlay: byteImages.length < 2 ? false : true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: byteImages.length < 2 ? false : true,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              viewportFraction: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
