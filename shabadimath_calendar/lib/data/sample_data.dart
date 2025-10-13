import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../models/shabad.dart';

class SampleData {
  static final List<CalendarEvent> events = <CalendarEvent>[
    CalendarEvent(
      id: 'event-001',
      date: DateTime.now(),
      title: 'Today\'s Hukamnama',
      description: 'Reflect on the Hukamnama and its meaning in daily life.',
      type: EventType.hukamnama,
      icon: Icons.self_improvement,
      shabadId: 'shabad-001',
    ),
    CalendarEvent(
      id: 'event-002',
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2),
      title: 'Sukhmana Sahib Paath',
      description: 'Evening Paath followed by Guru ka Langar.',
      type: EventType.general,
      icon: Icons.wb_twilight,
      shabadId: 'shabad-002',
    ),
    CalendarEvent(
      id: 'event-003',
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 5),
      title: 'Guru Nanak Gurpurab',
      description: 'Celebration of Guru Nanak Dev Ji\'s birth anniversary with Kirtan.',
      type: EventType.gurpurab,
      icon: Icons.auto_awesome,
      shabadId: 'shabad-001',
    ),
    CalendarEvent(
      id: 'event-004',
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 8),
      title: 'Akhand Paath Arambh',
      description: 'Continuous recitation commencing at 5 AM.',
      type: EventType.general,
      icon: Icons.auto_stories,
      shabadId: 'shabad-002',
    ),
    CalendarEvent(
      id: 'event-005',
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 15),
      title: 'Guru Gobind Singh Gurpurab',
      description: 'Prabhat Pheri and evening Diwan with Panj Piare.',
      type: EventType.gurpurab,
      icon: Icons.star,
      shabadId: 'shabad-001',
    ),
  ];

  static final List<Shabad> shabads = <Shabad>[
    Shabad(
      id: 'shabad-001',
      title: 'So Dar',
      source: 'Sri Guru Granth Sahib Ji',
      raag: 'Asa',
      gurmukhi:
          'ਸੋ ਦਰੁ ਕੇਹਾ ਸੋ ਘਰੁ ਕੇਹਾ ਜਿਤੁ ਬਹਿ ਸਰਬ ਸਮਾਏ ॥\nਵਾਜੇ ਨਾਦ ਅਨੇਕ ਅਸੰਖਾ ਕੇਤੇ ਵਾਵਣਹਾਰੇ ॥',
      transliteration:
          "So dar kehaa so ghar kehaa jit beh sarab samaae. Vaje naad anek asankhaa kete vaavanhare.",
      translation:
          'What is that gate, and what is that home, where You sit and take care of all?\n So many musical instruments continually play there; countless are the musicians playing them.',
    ),
    Shabad(
      id: 'shabad-002',
      title: 'Japji Sahib Pauri 1',
      source: 'Sri Guru Granth Sahib Ji',
      raag: 'Japji',
      gurmukhi:
          'ੴ ਸਤਿ ਨਾਮੁ ਕਰਤਾ ਪੁਰਖੁ ਨਿਰਭਉ ਨਿਰਵੈਰੁ\nਅਕਾਲ ਮੂਰਤਿ ਅਜੂਨੀ ਸੈਭੰ ਗੁਰ ਪ੍ਰਸਾਦਿ ॥',
      transliteration:
          "Ik oa(n)kaar sat naam kartaa purakh nirbha-o nirvair akaal moorat ajoonee saibhaN gur prasaad.",
      translation:
          'One Universal Creator God. The Name is Truth. Creative Being Personified. No Fear. No Hatred. Timeless Image. Beyond Birth. Self-Existent. Realized by the Guru\'s Grace.',
    ),
  ];
}
