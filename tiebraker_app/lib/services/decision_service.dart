import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/decision_result.dart';
import 'package:flutter/foundation.dart';

class DecisionService extends ChangeNotifier{

  DecisionResult? currentResult;
  bool isLoading = false;
  String? errorMessage;

  final String _apiKey = '';

  Future<void> analyzeDecision(String decisionPrompt) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
     final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
     final prompt = '''
      You are an expert decision-making assistant. The user is trying to make decision:
      "$decisionPrompt". Please provide exactly 3 solutions of markdown:
      1. ### Pros and Cons
      Provide a detailed pros and const list
      2. ### Comparison Table
      If applicable, provide a comparison table comparing the main alternatives.
      3. ### SWOT analysis
      Provide a SWOT (Strength, Weaknesses, Opportunities, Threats) Analysis for the decision
      
      Ensure the markdown is well-formatted and easy to read. Do not Include extra text outside
      of these headers.
     
      ''';

     final response = await model.generateContent([Content.text(prompt)]);

     currentResult = _parseResponse(response.text ?? '', decisionPrompt);

    } catch (error) {
      errorMessage = 'Failed: &e';

    }finally {
      isLoading = false;
      notifyListeners();
    }
  }

  DecisionResult _parseResponse(String text, String decision) {
    final parts = text.split('###');
    return DecisionResult(
        decision: decision,
        prosAndCons: parts.length >1 ?parts[1]: text,
        comparisonTable: parts.length >2 ?parts[2]: 'No Table',
        swotAnalysis: parts.length >3 ?parts[3]: 'No Swot',
    );
  }

}
