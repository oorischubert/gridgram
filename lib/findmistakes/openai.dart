import 'dart:convert';
import 'package:http/http.dart' as http;

String apiKey = "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";
String url = "https://api.openai.com/v1/completions";

class Controller {
  //function to get api request
  static Future<String> getApiRequest(
      {required String answer, required String correct}) async {
    //api request
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey'
          },
          body: jsonEncode({
            "model": "text-davinci-003",
            "prompt":
                "Check if '$answer' is grammatically correct and equivalent to '$correct'. Respond in json format with two keys: mistakes which holds number of mistakes and equivalent which has true or false value.",
            "stream": false,
            "logprobs": null,
            //"stop": "\n"
          }));
      final decodedResponse = json.decode(response.body);
      print(decodedResponse["choices"][0]["text"]); //debugging
      return decodedResponse["choices"][0]["text"];
    } catch (e) {
      print("ERROR: $e");
      return "error"; //implememt further error handling
    }
  }
}
