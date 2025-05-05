import 'package:flutter/material.dart';
import 'package:super_star/main.dart';

class WinnerDusClaimPopup extends StatelessWidget {
  final dynamic ticketData;
  const WinnerDusClaimPopup({super.key, this.ticketData});

  @override
  Widget build(BuildContext context) {
    final ticket = ticketData['data'];

    return Dialog(
      child: Container(
        height: screenWidth / 4,
        width: screenWidth / 3,
        color: Color(0xff3d3d3c),
        child:
            ticket['win_amount'] == 0
                ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'No winning found'.toUpperCase(),
                        style: TextStyle(
                          fontSize: screenWidth / 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "Better luck next time",
                        style: TextStyle(
                          fontSize: screenWidth / 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // ticketController.clear();
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          width: screenWidth / 15,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontSize: screenWidth / 80,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : ticketData['success'] == true
                ? Column(
                  children: [
                    Container(
                      height: screenWidth / 20,
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: Text(
                        'Congratulations!!!!'.toUpperCase(),
                        style: TextStyle(
                          fontSize: screenWidth / 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: screenWidth / 20,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            buildInfoRow(
                              "Ticket id:",
                              Text(
                                ticket['ticket_id'].toString(),
                                style: TextStyle(
                                  fontSize: screenWidth / 90,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            buildInfoRow(
                              "Dus Ka Dum:",
                              Text(
                                ticket['win_number'].toString(),
                                style: TextStyle(
                                  fontSize: screenWidth / 90,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              // textWidget(text: ticket['win_number'])
                              // Image.asset(
                              //   firstCard.image,
                              //   width: 40,
                              //   height: 40,
                              // ),
                            ),
                            buildInfoRow(
                              "draw time:",
                              Text(
                                ticket['draw_time'],
                                style: TextStyle(
                                  fontSize: screenWidth / 90,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            buildInfoRow(
                              "won points:",
                              Text(
                                ticket['win_amount'].toString(),
                                style: TextStyle(
                                  fontSize: screenWidth / 60,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    // l16cCheckCon.ticketController.clear();
                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  width: screenWidth / 15,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                      fontSize: screenWidth / 80,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ticket claimed error'.toUpperCase(),
                        style: TextStyle(
                          fontSize: screenWidth / 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        ticketData['message'],
                        style: TextStyle(
                          fontSize: screenWidth / 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // l16cCheckCon.ticketController.clear();/
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          width: screenWidth / 15,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontSize: screenWidth / 80,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget buildInfoRow(String label, Widget value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 7,
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: screenWidth / 90,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: screenWidth / 7,
            child: value,
          ),
        ],
      ),
    );
  }
}
