import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
import 'package:universal_html/js_util.dart' as js_util;
import 'package:e_store/services/services.dart';
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;

class StripePaymentWidget extends StatefulWidget {
  final String clientSecret;
  final Map<String, dynamic> billingDetails;
  final VoidCallback? onSuccess;
  final Function(String)? onError;
  final VoidCallback? onLoading;

  const StripePaymentWidget({
    super.key,
    required this.clientSecret,
    required this.billingDetails,
    this.onSuccess,
    this.onError,
    this.onLoading,
  });

  @override
  State<StripePaymentWidget> createState() => _StripePaymentWidgetState();
}

class _StripePaymentWidgetState extends State<StripePaymentWidget> {
  bool _isLoading = false;
  String? _errorMessage;
  late String _elementId;
  js.JsObject? _stripe;
  js.JsObject? _elements;
  js.JsObject? _cardElement;

  @override
  void initState() {
    super.initState();
    _elementId = 'card-element-${DateTime.now().millisecondsSinceEpoch}';
    // Register the view

    ui_web.platformViewRegistry.registerViewFactory(
      _elementId,
      (int viewId) =>
          html.DivElement()
            ..id = _elementId
            ..style.width = '100%'
            ..style.padding = '10px 0',
    );

    _initializeStripe();
  }

  void _initializeStripe() {
    try {
      _stripe = js.JsObject(js.context['Stripe'], [
        StripeWebService.publishableKey,
      ]);
      _elements = _stripe!.callMethod('elements');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _createCardElement();
      });
    } catch (e) {
      debugPrint('Error initializing Stripe: $e');
      setState(() {
        _errorMessage = 'Failed to initialize payment form';
      });
    }
  }

  void _createCardElement() {
    try {
      final cardContainer = html.document.getElementById(_elementId);
      if (cardContainer != null && _elements != null) {
        _cardElement = _elements!.callMethod('create', [
          'card',
          js.JsObject.jsify({
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

        _cardElement!.callMethod('mount', ['#$_elementId']);

        // Listen for changes
        _cardElement!.callMethod('on', [
          'change',
          js.allowInterop((event) {
            if (event['error'] != null) {
              setState(() {
                _errorMessage = event['error']['message'];
              });
            } else {
              setState(() {
                _errorMessage = null;
              });
            }
          }),
        ]);
      }
    } catch (e) {
      debugPrint('Error creating card element: $e');
      setState(() {
        _errorMessage = 'Failed to create payment form';
      });
    }
  }

  Future<void> _handlePayment() async {
    if (_stripe == null || _cardElement == null) {
      setState(() {
        _errorMessage = 'Payment form not ready';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    widget.onLoading?.call();

    try {
      final result = await js_util.promiseToFuture(
        _stripe!.callMethod('confirmCardPayment', [
          widget.clientSecret,
          js.JsObject.jsify({
            'payment_method': {
              'card': _cardElement,
              'billing_details': widget.billingDetails,
            },
          }),
        ]),
      );

      final dartResult = js_util.dartify(result) as Map<String, dynamic>;

      if (dartResult['error'] != null) {
        final error = dartResult['error'] as Map<String, dynamic>;
        setState(() {
          _errorMessage = error['message'] as String? ?? 'Payment failed';
        });
        widget.onError?.call(_errorMessage!);
      } else {
        widget.onSuccess?.call();
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      setState(() {
        _errorMessage = 'Payment processing failed';
      });
      widget.onError?.call(_errorMessage!);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Card element container
              SizedBox(
                height: 50,
                child: HtmlElementView(elementId: _elementId),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                    : const Text(
                      'Complete Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cardElement?.callMethod('destroy');
    super.dispose();
  }
}

// Web-compatible HTML element widget
class HtmlElementView extends StatefulWidget {
  final String elementId;
  final double? width;
  final double? height;

  const HtmlElementView({
    super.key,
    required this.elementId,
    this.width,
    this.height,
  });

  @override
  State<HtmlElementView> createState() => _HtmlElementViewState();
}

class _HtmlElementViewState extends State<HtmlElementView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(elementId: widget.elementId),
    );
  }
}
