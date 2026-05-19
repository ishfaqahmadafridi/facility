import 'package:flutter/material.dart';

import '../job_chat_components/chat_component_01.dart';
import '../job_chat_components/chat_component_02.dart';
import '../job_chat_components/chat_component_03.dart';
import '../job_chat_components/chat_component_04.dart';
import '../job_chat_components/chat_component_05.dart';
import '../job_chat_components/chat_component_06.dart';
import '../job_chat_components/chat_component_07.dart';
import '../job_chat_components/chat_component_08.dart';
import '../job_chat_components/chat_component_09.dart';
import '../job_chat_components/chat_component_10.dart';
import '../job_chat_components/chat_component_11.dart';
import '../job_chat_components/chat_component_12.dart';
import '../job_chat_components/chat_component_13.dart';
import '../job_chat_components/chat_component_14.dart';
import '../job_chat_components/chat_component_15.dart';
import '../job_chat_components/chat_component_16.dart';
import '../job_chat_components/chat_component_17.dart';
import '../job_chat_components/chat_component_18.dart';
import '../job_chat_components/chat_component_19.dart';
import '../job_chat_components/chat_component_20.dart';
import '../job_chat_components/chat_component_21.dart';
import '../job_chat_components/chat_component_22.dart';
import '../job_chat_components/chat_component_23.dart';
import '../job_chat_components/chat_component_24.dart';
import '../job_chat_components/chat_component_25.dart';

/// A wrapper widget that displays the 25 placeholder UI components in the chat.
class DummyComponentsGrid extends StatelessWidget {
  const DummyComponentsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ChatComponent01(), ChatComponent02(), ChatComponent03(), ChatComponent04(), ChatComponent05(),
          ChatComponent06(), ChatComponent07(), ChatComponent08(), ChatComponent09(), ChatComponent10(),
          ChatComponent11(), ChatComponent12(), ChatComponent13(), ChatComponent14(), ChatComponent15(),
          ChatComponent16(), ChatComponent17(), ChatComponent18(), ChatComponent19(), ChatComponent20(),
          ChatComponent21(), ChatComponent22(), ChatComponent23(), ChatComponent24(), ChatComponent25(),
        ],
      ),
    );
  }
}
