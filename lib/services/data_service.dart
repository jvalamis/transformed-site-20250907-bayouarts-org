import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/website_data.dart';

class DataService {
  static WebsiteData? _websiteData;
  
  static Future<WebsiteData> loadWebsiteData() async {
    if (_websiteData != null) {
      return _websiteData!;
    }

    try {
      // For Flutter web, load from the web root (not assets)
      // The site-data.json file is available at the web root
      final String jsonString = await rootBundle.loadString('assets/site-data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _websiteData = WebsiteData.fromJson(jsonData);
      return _websiteData!;
    } catch (e) {
      // If assets loading fails, try loading from web root
      try {
        // Use Uri.base.resolve to respect the base href (GitHub Pages repo path)
        final url = Uri.base.resolve('site-data.json');
        
        // For Flutter web, we need to use a different approach
        // Since we can't use http package, we'll use the fallback data for now
        throw Exception('Web loading not implemented yet');
      } catch (webError) {
        // If loading fails, create a fallback data structure with Bayou Arts content
        _websiteData = WebsiteData(
        domain: 'bayouarts.org',
        originalUrl: 'https://bayouarts.org/',
        crawledAt: DateTime.now(),
        title: 'Home - Bayou Arts',
        description: 'Making Art Work The Bayou Regional Arts Council works to support arts access in the Assumption, Lafourche, St. Charles, St. James, St. John the Baptist, and Terrebonne parishes through grants, workshops, and networking opportunities for artists and organizations.',
        keywords: 'arts, bayou, regional, council, grants, workshops, networking',
        pages: [
          PageData(
            url: 'https://bayouarts.org/',
            path: '/',
            title: 'Home - Bayou Arts',
            description: 'Making Art Work The Bayou Regional Arts Council works to support arts access in the Assumption, Lafourche, St. Charles, St. James, St. John the Baptist, and Terrebonne parishes through grants, workshops, and networking opportunities for artists and organizations.',
            content: PageContentData(
              headings: [
                HeadingData(text: 'Making Art Work', level: 1),
                HeadingData(text: 'Bayou Regional Arts Council', level: 2),
              ],
              paragraphs: [
                ParagraphData(
                  text: 'The Bayou Regional Arts Council works to support arts access in the Assumption, Lafourche, St. Charles, St. James, St. John the Baptist, and Terrebonne parishes through grants, workshops, and networking opportunities for artists and organizations.',
                  classes: [],
                ),
                ParagraphData(
                  text: 'We believe that art is essential to the cultural and economic vitality of our region. Through our programs and partnerships, we work to ensure that everyone has access to quality arts experiences.',
                  classes: [],
                ),
              ],
              images: [],
              links: [],
              lists: [],
              tables: [],
              forms: [],
              contentBlocks: [],
            ),
          ),
        ],
        assets: [],
      );
      return _websiteData!;
      }
    }
  }

  static void clearCache() {
    _websiteData = null;
  }
}
