class AppConstants {
  static const String appName = 'Resume Radar';
  static bool isPushServiceInitialized = false;
  static const int APP_SESSION_TIMEOUT = 10 * 60;
  static bool IS_USER_LOGGED = false;
  static bool isBeta = true;
  static String SHARE_API_KEY = "JLKPXIcCY3elWdIMqYhQScXyfU8ldlBxu5Rpqrye";
  static String GEMINI_API_KEY = "AIzaSyA_eo3vsmHx9_0ekCfboYmqmhP4iqEchdI";
  static String FORCE_STOP = "a18698f1-4262-4d36-94d0-7fe06b7a1294";
  static String BASE_PROMPT =
      """I want to simulate a 10-minute job interview for a job seeker using the data provided. Company can be anything of your choice(real or not real).At the end of the interview, I need job seeker's performance. If at any point if I send the string "a18698f1-4262-4d36-94d0-7fe06b7a1294" as a response, the interview should immediately end, and you should return the performance. From this point onward, all the data should be returned on following JSON formatted object.

If the Interview has not ended, the response should be just like this,

{
  "question": "Tell me a little bit about yourself and your interest in this position.",
  "has_ended": false,
  "performance": null
}

If the Interview has ended, the response should be just like this,

{
  "question": "Thank you for participating for this interview",
  "has_ended": true,
  "performance": {
    "overall_score": 78,
    "strengths": [
      "Good communication skills",
      "Strong problem-solving ability",
      "Confident under pressure"
    ],
    "weaknesses": [
      "Needs improvement in technical skills",
      "Struggles with time management"
    ],
    "recommendations": [
      "Take advanced technical courses",
      "Improve time management techniques"
    ]
  }
}

Other than these json strings, There shouldn’t bet be any extra details. The interview should be designed to last approximately 10 minutes (though not literally 10 minutes in real-time). Again please don't send any extra details other than JSON object. Also, don’t add the role name to the questions. Again just questions. These are the Job Seekers resume data,""";
}
