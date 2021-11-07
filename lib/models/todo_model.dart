// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:async';
import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
  Todo(
      {this.title,
      this.description,
      this.durationSeconds,
      this.timerRunning,
      this.status,
      this.isPaused,this.isCompleted,
      this.displayString,this.durationValue,
      this.duration});

  String title;
  String description;
  int durationSeconds;
  Duration duration;bool isCompleted=false;
  bool isPaused=true;


  int durationValue;

  bool timerRunning;
  String status;
  String displayString;
  Timer timer;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        durationSeconds: json["duration"] == null ? null : json["duration"],
        timerRunning:
            json["timerRunning"] == null ? null : json["timerRunning"],
        status: json["status"] == null ? null : json["status"],
        duration: json["durationValue"]==null?null:Duration(seconds: json["durationValue"]),
        displayString:
            json["displayString"] == null ? null : json["displayString"],
            isCompleted: json["isCompleted"]==null?false:json["isCompleted"],
            isPaused: json["isPaused"]==null?false:json["isPaused"]
            
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "duration": durationSeconds == null ? null : durationSeconds,
        "timerRunning": timerRunning == null ? null : timerRunning,
        "status": status == null ? null : status,
        "displayString": displayString == null ? null : displayString,
        "durationValue":duration!=null?duration.inSeconds:0,
        "isPaused":isPaused,
        "isCompleted":isCompleted
      };
}
