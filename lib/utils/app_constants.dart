class AppConstants {
  static const String appName = 'Resume Radar';
  static bool isPushServiceInitialized = false;
  static const int APP_SESSION_TIMEOUT = 10 * 60;
  static bool IS_USER_LOGGED = false;
  static bool isBeta = true;
  static String SHARE_API_KEY = "YitpO4GQ3XPJGjaCfqMEfKSuL1nX0xUrU1rKRVyX";
  static String GEMINI_API_KEY = "AIzaSyA_eo3vsmHx9_0ekCfboYmqmhP4iqEchdI";
  static String FORCE_STOP = "a18698f1-4262-4d36-94d0-7fe06b7a1294";
  static String BASE_PROMPT =
      """I want to simulate a 10-minute job interview for a job seeker using the data provided. Ask technical questions and also questions about the job seeker's data provided in the first message. The company can be anything of your choice(real or not real). At the end of the interview, I need the job seeker's performance results. These results depend on job seekers' answers to their questions. You have to give these results by analyzing job seekers' answers. If at any point I send the string "a18698f1-4262-4d36-94d0-7fe06b7a1294" as a response, the interview should immediately end, and you should return the performance. From this point onward, all the data should be returned on the following JSON formatted object. Please make sure that the JSON is formatted correctly with correct commas in right places.

If the Interview has not ended, the response structure should be like this and questions can vary.

{
  "question": "Tell me a little bit about yourself and your interest in this position.",
  "has_ended": false,
  "performance": null
}

At the end of the interview, I need the job seeker's performance results. These results depend on job seekers' answers to their questions. You have to give these results by analyzing job seekers' answers. The results structure should be like this, and these data should be dynamic according to the users performance, and make sure there is no unwanted spaces for the keys in this json structure  

{
  "question": "Thank you for participating in this interview",
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

Please make sure JSON response is formatted correctly. Again please do not miss any commas on the JSON response you send.

Other than these JSON strings, There shouldn’t bet be any extra details. The interview should be designed to last approximately 10 minutes (though not literally 10 minutes in real-time, At least ask about 10 questions). Again please don't send any extra details other than JSON object. Also, don’t add the role name to the questions. Again just questions. These are the Job Seekers resume data and make sure to ask some questions from these data also,""";
}
