import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
import 'package:universal_html/js_util.dart' as js_util;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeWebService {
  static final String _publishableKey =
      kDebugMode
          ? dotenv.get('PUBLISHABLE_KEY')
          : String.fromEnvironment("PUBLISHABLE_KEY");
  static final String _secretKey =
      kDebugMode
          ? dotenv.get('SECRET_KEY')
          : String.fromEnvironment("SECRET_KEY");
  static const String _baseUrl = 'https://api.stripe.com/v1';

  static String get publishableKey => _publishableKey;

  static final Dio _dio = Dio();
  static js.JsObject? _stripe;

  static void init() {
    try {
      _stripe = js.JsObject(js.context['Stripe'], [_publishableKey]);
      debugPrint('Stripe initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Stripe: $e');
    }
  }

  // Create Payment Intent
  static Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    required String currency,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/payment_intents',
        data: {
          'amount': (amount * 100).toInt(),
          'currency': currency,
          'payment_method_types[]': 'card',
          if (customerId != null) 'customer': customerId,
          if (metadata != null)
            ...metadata.map((key, value) => MapEntry('metadata[$key]', value)),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data;
    } catch (e) {
      debugPrint('Error creating payment intent: $e');
      return null;
    }
  }

  // Create Customer
  static Future<Map<String, dynamic>?> createCustomer({
    required String email,
    String? name,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/customers',
        data: {'email': email, if (name != null) 'name': name},
        options: Options(
          headers: {
            'Authorization': 'Bearer $_secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data;
    } catch (e) {
      debugPrint('Error creating customer: $e');
      return null;
    }
  }

  // Process Payment with Stripe Elements
  static Future<PaymentResult> processPayment({
    required String clientSecret,
    required Map<String, dynamic> billingDetails,
  }) async {
    try {
      if (_stripe == null) {
        return PaymentResult(success: false, message: 'Stripe not initialized');
      }

      // Create payment method
      final result = await _confirmCardPayment(clientSecret, billingDetails);

      if (result['error'] != null) {
        final error = result['error'];
        return PaymentResult(
          success: false,
          message: error['message'] ?? 'Payment failed',
          isCancelled: error['type'] == 'validation_error',
        );
      } else {
        return PaymentResult(
          success: true,
          message: 'Payment completed successfully!',
          paymentIntent: result['paymentIntent'],
        );
      }
    } catch (e) {
      debugPrint('Payment processing error: $e');
      return PaymentResult(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  static Future<Map<String, dynamic>> _confirmCardPayment(
    String clientSecret,
    Map<String, dynamic> billingDetails,
  ) async {
    try {
      final elements = _stripe!.callMethod('elements');
      final cardElement = elements.callMethod('create', [
        'card',
        js.JsObject.jsify({
          'style': {
            'base': {
              'fontSize': '16px',
              'color': '#424770',
              '::placeholder': {'color': '#aab7c4'},
            },
          },
        }),
      ]);

      // Mount card element to a container
      final cardContainer = html.document.getElementById('card-element');
      if (cardContainer != null) {
        cardElement.callMethod('mount', ['#card-element']);
      }

      final result = await js_util.promiseToFuture(
        _stripe!.callMethod('confirmCardPayment', [
          clientSecret,
          js.JsObject.jsify({
            'payment_method': {
              'card': cardElement,
              'billing_details': billingDetails,
            },
          }),
        ]),
      );

      return js_util.dartify(result) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Card payment confirmation error: $e');
      return {
        'error': {'message': 'Payment confirmation failed'},
      };
    }
  }

  // Create Setup Intent for saving cards
  static Future<Map<String, dynamic>?> createSetupIntent({
    required String customerId,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/setup_intents',
        data: {'customer': customerId, 'payment_method_types[]': 'card'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $_secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data;
    } catch (e) {
      debugPrint('Error creating setup intent: $e');
      return null;
    }
  }
}

class PaymentResult {
  final bool success;
  final String message;
  final bool isCancelled;
  final Map<String, dynamic>? paymentIntent;

  PaymentResult({
    required this.success,
    required this.message,
    this.isCancelled = false,
    this.paymentIntent,
  });
}
