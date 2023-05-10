import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final List<double?> detailFromRoad;

  const PlaceCard({Key? key, required this.detailFromRoad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Container();
        }));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: tag((detailFromRoad[1]?.round())!), width: 8),
              ),
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 15),
                            Text("total F CFA"),
                            Spacer()
                          ],
                        ),
                      ),
                      const VerticalDivider(color: Colors.grey, thickness: 2),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                CircleAvatar(
                                  radius: 5.0,
                                  backgroundColor: Colors.blue,
                                ),
                                SizedBox(width: 10.0),
                                Text("Position actuelle - Marchand"),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                CircleAvatar(
                                  radius: 5.0,
                                  backgroundColor: Colors.red,
                                ),
                                SizedBox(width: 10.0),
                                Text("Marchand - Client"),
                              ],
                            ),
                            const Divider(
                              thickness: 1.4,
                              indent: 20.0,
                              endIndent: 20.0,
                              height: 25.0,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Position actuelle - Marchand:'),
                                Expanded(
                                    child: Text(
                                        ' ${detailFromRoad[0]?.round()} km, ${formatDuration(detailFromRoad[1]!)}'))
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Durée:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(' ${formatDuration(detailFromRoad[1]!)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color tag(int duree) {
    if (duree < 10) {
      return Colors.grey;
    } else if (duree < 30) {
      return Colors.green;
    } else if (duree < 45) {
      return Colors.yellow;
    } else if (duree < 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String formatDuration(double seconds) {
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;

    if (hours == 0) {
      return '${minutes.toString()}mn';
    }

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    return '${hoursStr}h${minutesStr}mn';
  }

  String durationSince(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    return formatDuration(double.parse(diff.inSeconds.toString()));
  }
}
