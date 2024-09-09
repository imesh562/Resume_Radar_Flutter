import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:resume_radar/features/presentation/common/appbar.dart';
import 'package:resume_radar/utils/app_constants.dart';
import 'package:resume_radar/utils/app_dimensions.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../base_view.dart';

class MockInterviewView extends BaseView {
  final ParseResumeModel resumeData;
  MockInterviewView({
    super.key,
    required this.resumeData,
  });
  @override
  State<MockInterviewView> createState() => _MockInterviewViewState();
}

class _MockInterviewViewState extends BaseViewState<MockInterviewView> {
  var bloc = injection<UserBloc>();
  String promptData = '';
  ChatUser? currentUser;
  ChatUser? geminiUser;
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;
  final TextEditingController messageController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  OverlayEntry? _listeningOverlay;
  final FlutterTts _flutterTts = FlutterTts();
  bool isTtsEnabled = true;
  bool isPlaying = false;
  String lastResponse = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      promptData =
          '${AppConstants.BASE_PROMPT}\n\n${createResumeString(widget.resumeData)}';
      currentUser = ChatUser(
        id: '1',
        firstName: appSharedData.getAppUser().firstName,
        lastName: appSharedData.getAppUser().lastName,
      );
      geminiUser = ChatUser(
        id: '2',
        firstName: 'Gemini',
        profileImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThr7qrIazsvZwJuw-uZCtLzIjaAyVW_ZrlEQ&s',
      );
    });

    _configureTts();
    _initSpeech();

    sendMessage(
      ChatMessage(
        user: currentUser!,
        createdAt: DateTime.now(),
        text: promptData,
      ),
      displayInChat: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: '          Mock Interview',
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'Option 1') {
                setState(() {
                  isTtsEnabled = !isTtsEnabled;
                });
              } else {
                if (isPlaying) {
                  setState(() {
                    isPlaying = false;
                  });
                  _flutterTts.stop();
                } else {
                  setState(() {
                    isPlaying = true;
                  });
                  await _flutterTts.speak(lastResponse);
                }
              }
            },
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text(
                    isTtsEnabled ? 'Disable Voice' : 'Enable Voice',
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Text(
                    isPlaying ? 'Stop' : 'Play Last Response',
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: AppColors.colorWhite,
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
          listener: (_, state) {},
          child: DashChat(
            currentUser: currentUser!,
            messageOptions: const MessageOptions(
              currentUserContainerColor: AppColors.colorBlack,
              containerColor: AppColors.primaryGreen,
              textColor: AppColors.colorWhite,
            ),
            inputOptions: InputOptions(
              textController: messageController,
              trailing: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100.r),
                      onTapDown: (_) async {
                        _startListening();
                      },
                      onTapUp: (_) {
                        _stopListening();
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.colorTransparent,
                        child: Icon(
                          Icons.mic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onSend: (ChatMessage message) => sendMessage(message),
            messages: messages,
          ),
        ),
      ),
    );
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    _showListeningOverlay();
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    _removeListeningOverlay();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      messageController.text = result.recognizedWords;
    });
  }

  void _showListeningOverlay() {
    if (_listeningOverlay != null) return;
    _listeningOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 50,
        left: MediaQuery.of(context).size.width / 2 - 50,
        child: _buildListeningAnimation(),
      ),
    );
    Overlay.of(context).insert(_listeningOverlay!);
  }

  void _removeListeningOverlay() {
    _listeningOverlay?.remove();
    _listeningOverlay = null;
  }

  Widget _buildListeningAnimation() {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.h,
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.colorBlack.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: const Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.mic,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Listening...",
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontSize: AppDimensions.kFontSize18,
            ),
          ),
        ],
      ),
    );
  }

  void _configureTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void sendMessage(ChatMessage chatMessage, {bool displayInChat = true}) {
    if (displayInChat) {
      setState(() {
        messages = [chatMessage, ...messages];
      });
    }

    try {
      String question = chatMessage.text;
      String completeResponse = '';

      String context = [
        promptData,
        ...messages.map((msg) => msg.text),
      ].join('\n');

      gemini.streamGenerateContent('$context\n$question').listen(
        (event) {
          String response = event.content?.parts?.fold(
                "",
                (previous, current) => "$previous ${current.text}",
              ) ??
              '';

          completeResponse += ' ${response.trim()}';

          ChatMessage? lastMessage =
              messages.isNotEmpty ? messages.first : null;

          if (lastMessage != null && lastMessage.user == geminiUser) {
            lastMessage = messages.removeAt(0);
            lastMessage.text += ' ${response.trim()}';
            setState(() {
              messages = [lastMessage!, ...messages];
            });
          } else {
            ChatMessage message = ChatMessage(
              user: geminiUser!,
              createdAt: DateTime.now(),
              text: response.trim(),
            );
            setState(() {
              messages = [message, ...messages];
            });
          }
        },
        onDone: () async {
          setState(() {
            lastResponse = completeResponse.trim();
            isPlaying = true;
          });
          if (isTtsEnabled) {
            await _flutterTts.speak(lastResponse);
          }
        },
        onError: (e) {
          print(e);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  String createResumeString(ParseResumeModel resume) {
    StringBuffer buffer = StringBuffer();

    if (resume.candidateName != null) {
      buffer.writeln('Name: ${resume.candidateName}');
    }
    if (resume.candidateEmail != null) {
      buffer.writeln('Email: ${resume.candidateEmail}');
    }
    if (resume.candidatePhone != null) {
      buffer.writeln('Phone: ${resume.candidatePhone}');
    }
    if (resume.candidateAddress != null) {
      buffer.writeln('Address: ${resume.candidateAddress}');
    }
    if (resume.candidateLanguage != null) {
      buffer.writeln('Language: ${resume.candidateLanguage}');
    }

    if (resume.candidateSpokenLanguages != null &&
        resume.candidateSpokenLanguages!.isNotEmpty) {
      buffer.writeln(
          'Spoken Languages: ${resume.candidateSpokenLanguages!.join(", ")}');
    }

    if (resume.candidateHonorsAndAwards != null &&
        resume.candidateHonorsAndAwards!.isNotEmpty) {
      buffer.writeln(
          'Honors and Awards: ${resume.candidateHonorsAndAwards!.join(", ")}');
    }

    if (resume.candidateCoursesAndCertifications != null &&
        resume.candidateCoursesAndCertifications!.isNotEmpty) {
      buffer.writeln(
          'Courses and Certifications: ${resume.candidateCoursesAndCertifications!.join(", ")}');
    }

    if (resume.positions != null && resume.positions!.isNotEmpty) {
      buffer.writeln('Positions:');
      for (var position in resume.positions!) {
        buffer.writeln('  Company: ${position.companyName ?? ''}');
        buffer.writeln('  Position: ${position.positionName ?? ''}');
        buffer.writeln('  Start Date: ${position.startDate ?? ''}');
        buffer.writeln('  End Date: ${position.endDate ?? ''}');
        if (position.skills != null && position.skills!.isNotEmpty) {
          buffer.writeln('  Skills: ${position.skills!.join(", ")}');
        }
        buffer.writeln('');
      }
    }

    if (resume.educationQualifications != null &&
        resume.educationQualifications!.isNotEmpty) {
      buffer.writeln('Education Qualifications:');
      for (var education in resume.educationQualifications!) {
        buffer.writeln('  School: ${education.schoolName ?? ''}');
        buffer.writeln('  Degree: ${education.degreeType ?? ''}');
        buffer.writeln('  Start Date: ${education.startDate ?? ''}');
        buffer.writeln('  End Date: ${education.endDate ?? ''}');
        buffer.writeln(
            '  Specialization: ${education.specializationSubjects ?? ''}');
        buffer.writeln('');
      }
    }

    return buffer.toString();
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
