import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart' show Provider;
import '../../generated/assets.dart';
import '../../lucky_card_12/widgets/lucky_12_btn.dart' show Lucky12Btn;
import '../../main.dart';
import '../view_model/lucky_16_check_view_model.dart';

class ClaimButton extends StatefulWidget {
  final FocusNode textFieldFocusNode;
  final TextEditingController ticketController;
  const ClaimButton({
    super.key,
    required this.textFieldFocusNode,
    required this.ticketController,
  });

  @override
  State<ClaimButton> createState() => _ClaimButtonState();
}

class _ClaimButtonState extends State<ClaimButton> {
  @override
  Widget build(BuildContext context) {
    final checkData = Provider.of<Lucky16CheckViewModel>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      height: screenHeight * 0.08,
      width: screenWidth * 0.3,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.lucky16LBgBlue),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              focusNode: widget.textFieldFocusNode,
              controller: widget.ticketController,
              autofocus: true,
              placeholder: "Enter your Ticket I'd",
              padding: EdgeInsets.all(10),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: 5),
          SizedBox(
            width: screenWidth * 0.07,
            child: Lucky12Btn(
              title: 'CHECK',
              onTap: () async {
                await checkData.lucky16CheckApi(context,"" );
              },
            ),
          ),
        ],
      ),
    );
  }
}
