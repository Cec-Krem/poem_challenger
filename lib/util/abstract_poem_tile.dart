import 'package:flutter/material.dart';

abstract class AbstractPoemTile extends StatefulWidget {
  final String id;
  final String poemName;
  final DateTime date;
  final int wordCount;
  final int challengeWords;
  final int? time;
  final Function()? deleteFunction;
  final Function()? selectFunction;

  const AbstractPoemTile({
    super.key,
    required this.id,
    required this.poemName,
    required this.date,
    required this.wordCount,
    required this.challengeWords,
    required this.time,
    this.deleteFunction,
    this.selectFunction,
  });

  @override
  State<AbstractPoemTile> createState() => _AbstractPoemTileState();
}

class _AbstractPoemTileState extends State<AbstractPoemTile> {

  String formattedDate() => "${widget.date.day}/${widget.date.month}/${widget.date.year} ${widget.date.hour}:${widget.date.minute}";

  String formattedTime() {
    // HH:MM:SS
    List<String> times = ["00","00","00"];
    // Hour, minute, second
    List<int> values = [(widget.time!/3600).toInt(), ((widget.time!%3600)/60).toInt(), ((widget.time!%(3600))%60).toInt()];

    for (int i = 0 ; i < values.length ; i++) {
      if (values[i] != 0) {
        if (values[i] < 10) {
          times[i] = "0${values[i]}";
        } else {
          times[i] = values[i].toString();
        }
      }
    }

    return "${times[0]}:${times[1]}:${times[2]}";
  }

  String formattedName() {
    // Untimed
    if (widget.time == null) {
      if (widget.wordCount.toString().length + widget.poemName.length > 25) {
        return widget.poemName.replaceRange(21-widget.wordCount.toString().length, null, "…");
      }
    }
    // Timed
    else if (widget.wordCount.toString().length + widget.poemName.length > 25) {
      return widget.poemName.replaceRange(15-widget.wordCount.toString().length, null, "…");
    }
    return widget.poemName;
  }

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onLongPress: widget.deleteFunction,
      onTap: widget.selectFunction,
      child: Padding(
        padding: const EdgeInsets.only(top:15.0, left:15.0, right: 15.0),
        child:
        Container(
          decoration: BoxDecoration(
            color: Color(0x4A4A4A4A),
            borderRadius: BorderRadius.circular(15.0),
            border:BoxBorder.all(
              width: 10.0,
              color: Color(0x4A4A4A4A),
              style: BorderStyle.none
              ),
            ),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(formattedName(), textWidthBasis: TextWidthBasis.parent,),
                  Text(formattedDate(), textScaler: TextScaler.linear(0.5))
                ]
              ),
               Column(
                children: [
                  Text(widget.wordCount.toString()),
                  Text(widget.challengeWords.toString(), textScaler: TextScaler.linear(0.5))
                ]
              ),
              ?(widget.time != null) ? Text(
                formattedTime(),
                textScaler: TextScaler.linear(0.6),
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold
                ),
              ) : null,
            ]
          )
        )
      ),
    );
  }
}