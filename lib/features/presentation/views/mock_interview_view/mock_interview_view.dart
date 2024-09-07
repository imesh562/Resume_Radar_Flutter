import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/common/appbar.dart';
import 'package:resume_radar/utils/app_images.dart';
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
  SpeechToText _speechToText = SpeechToText();
  OverlayEntry? _listeningOverlay;

  @override
  void initState() {
    super.initState();
    setState(() {
      promptData = createResumeString(widget.resumeData);
      currentUser = ChatUser(
        id: '1',
        firstName: appSharedData.getAppUser().firstName,
        lastName: appSharedData.getAppUser().lastName,
      );
      geminiUser = ChatUser(
        id: '2',
        firstName: 'Gemini',
        profileImage: AppImages.icAiLogo,
      );
    });
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    _showListeningOverlay(); // Show animation overlay
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    _removeListeningOverlay(); // Hide animation overlay
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      messageController.text = result.recognizedWords;
    });
  }

  void _showListeningOverlay() {
    if (_listeningOverlay != null) return; // Prevent duplicate overlays
    _listeningOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 50,
        left: MediaQuery.of(context).size.width / 2 - 50,
        child: _buildListeningAnimation(),
      ),
    );
    Overlay.of(context)?.insert(_listeningOverlay!);
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Listening...",
            style: TextStyle(color: AppColors.primaryGreen, fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: 'Mock Interview',
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
                        _startListening(); // Start listening and show animation
                      },
                      onTapUp: (_) {
                        _stopListening(); // Stop listening and hide animation
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
            onSend: sendMessage,
            messages: messages,
          ),
        ),
      ),
    );
  }

  void sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.isNotEmpty ? messages.first : null;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              '';
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              '';
          ChatMessage message = ChatMessage(
            user: geminiUser!,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
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
