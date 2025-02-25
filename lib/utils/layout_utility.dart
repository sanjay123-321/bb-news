import 'package:flutter/material.dart';

class LayoutUtils {
  static Widget cardText(Text title, Text description, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.grey.shade600,
                size: 14,
              ),
              const SizedBox(width: 4), // Add spacing between icon and text
              Expanded(
                child: Text(
                  '2 Minute Read',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.grey.shade600,
                size: 14,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  date,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          description,
        ],
      ),
    );
  }
}
