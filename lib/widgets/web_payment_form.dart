import 'package:e_store/services/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js_util.dart' as js_util;
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';

class WebPaymentForm extends StatefulWidget {
  final String clientSecret;
  final Map<String, dynamic> billingDetails;
  final VoidCallback? onSuccess;
  final Function(String)? onError;
  final double amount;

  const WebPaymentForm({
    super.key,
    required this.clientSecret,
    required this.billingDetails,
    required this.amount,
    this.onSuccess,
    this.onError,
  });

  @override
  State<WebPaymentForm> createState() => _WebPaymentFormState();
}

class _WebPaymentFormState extends State<WebPaymentForm> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  final String _cardElementId = 'card-element';

  // Use dynamic here for JS objects
  dynamic _stripe;
  dynamic _elements;
  dynamic _cardElement;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      ui_web.platformViewRegistry.registerViewFactory(
        _cardElementId,
        (int viewId) =>
            html.DivElement()
              ..id = _cardElementId
              ..style.width = '100%'
              ..style.height = '25px',
      );
      _initializeStripe();
    }
  }

  void _initializeStripe() {
    try {
      final stripeConstructor = js_util.getProperty(
        js_util.globalThis,
        'Stripe',
      );
      if (stripeConstructor == null) {
        setState(() {
          _errorMessage = 'Stripe.js not loaded';
        });
        return;
      }
      _stripe = js_util.callConstructor(stripeConstructor, [
        StripeWebService.publishableKey,
      ]);
      _elements = js_util.callMethod(_stripe, 'elements', []);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_cardElement == null) {
            _createCardElement();
            setState(() {
              _isInitialized = true;
            });
          }
        });
      });
    } catch (e) {
      debugPrint('Error initializing Stripe: $e');
      setState(() {
        _errorMessage = 'Failed to initialize payment form';
      });
    }
  }

  void _createCardElement() {
    if (_cardElement != null) {
      debugPrint('Card element already created');
      return;
    }
    try {
      final cardContainer = html.document.getElementById(_cardElementId);
      if (cardContainer != null && _elements != null) {
        _cardElement = js_util.callMethod(_elements, 'create', [
          'card',
          js_util.jsify({
            'style': {
              'base': {
                'fontSize': '16px',
                'color': '#424770',
                'fontFamily': 'Inter, system-ui, sans-serif',
                '::placeholder': {'color': '#aab7c4'},
              },
              'invalid': {'color': '#9e2146'},
            },
            'hidePostalCode': true,
          }),
        ]);
        js_util.callMethod(_cardElement, 'mount', ['#$_cardElementId']);
        js_util.callMethod(_cardElement, 'on', [
          'change',
          js_util.allowInterop((event) {
            final rawResult = js_util.dartify(event);
            if (rawResult is Map) {
              final dartResult = rawResult.map(
                (key, value) => MapEntry(key.toString(), value),
              );

              if (dartResult['error'] != null && dartResult['error'] is Map) {
                final errorMap = (dartResult['error'] as Map).map(
                  (key, value) => MapEntry(key.toString(), value),
                );

                setState(() {
                  _errorMessage =
                      errorMap['message']?.toString() ?? 'Unknown error';
                });
              } else {
                setState(() {
                  _errorMessage = null;
                });
              }
            }
          }),
        ]);
      } else {
        debugPrint('Card container element not found yet');
      }
    } catch (e) {
      debugPrint('Error creating card element: $e');
      setState(() {
        _errorMessage = 'Failed to create payment form';
      });
    }
  }

  Future<void> _handlePayment() async {
    if (!_isInitialized || _stripe == null || _cardElement == null) {
      setState(() {
        _errorMessage = 'Payment form not ready. Please refresh and try again.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final paymentMethodData = js_util.jsify({
        'payment_method': {'billing_details': widget.billingDetails},
      });

      // Manually set the `card` field (unsafe to `jsify`)
      js_util.setProperty(
        js_util.getProperty(paymentMethodData, 'payment_method'),
        'card',
        _cardElement,
      );

      final jsPromise = js_util.callMethod(_stripe, 'confirmCardPayment', [
        widget.clientSecret,
        paymentMethodData,
      ]);

      final result = await js_util.promiseToFuture(jsPromise);
      final rawResult = js_util.dartify(result) as Map<Object?, Object?>;
      final dartResult = convertToStringKeyMap(rawResult);

      if (dartResult['error'] != null) {
        final error = dartResult['error'] as Map<Object?, Object?>;
        final errorMap = convertToStringKeyMap(error);
        final errorMessage = errorMap['message'] as String? ?? 'Payment failed';
        setState(() {
          _errorMessage = errorMessage;
        });
        widget.onError?.call(errorMessage);
      } else {
        widget.onSuccess?.call();
      }
    } catch (e) {
      debugPrint('Payment processing error: $e');
      final errorMessage = 'Payment processing failed. Please try again.';
      setState(() {
        _errorMessage = errorMessage;
      });
      widget.onError?.call(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> convertToStringKeyMap(Map<Object?, Object?> map) {
    return map.map((key, value) => MapEntry(key.toString(), value));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Card element container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: SizedBox(
                height: 25,
                child:
                    kIsWeb
                        ? HtmlElementView(viewType: _cardElementId)
                        : const Center(
                          child: Text(
                            'Payment form not available on this platform',
                          ),
                        ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Security info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment information is secure and encrypted',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    (_isLoading || !_isInitialized) ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          'Pay \$${widget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),

            if (!_isInitialized && kIsWeb) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Loading payment form...',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    try {
      if (_cardElement != null) {
        final hasDestroy = js_util.hasProperty(_cardElement, 'destroy');
        final destroyFunc =
            hasDestroy ? js_util.getProperty(_cardElement, 'destroy') : null;

        if (destroyFunc != null) {
          js_util.callMethod(_cardElement, 'destroy', []);
        }
      }
    } catch (e) {
      debugPrint('Error destroying card element: $e');
    }
    super.dispose();
  }
}
