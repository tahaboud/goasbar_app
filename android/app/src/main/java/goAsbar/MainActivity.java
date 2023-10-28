package com.goasbar.goAsbar;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.content.Context;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.activity.ComponentActivity;

import com.oppwa.mobile.connect.checkout.dialog.CheckoutActivity;
import com.oppwa.mobile.connect.checkout.meta.CheckoutActivityResultContract;
import com.oppwa.mobile.connect.checkout.meta.CheckoutSettings;
import com.oppwa.mobile.connect.exception.PaymentError;
import com.oppwa.mobile.connect.exception.PaymentException;
import com.oppwa.mobile.connect.payment.BrandsValidation;
import com.oppwa.mobile.connect.payment.CheckoutInfo;
import com.oppwa.mobile.connect.payment.ImagesRequest;
import com.oppwa.mobile.connect.payment.PaymentParams;
import com.oppwa.mobile.connect.payment.card.CardPaymentParams;
import com.oppwa.mobile.connect.payment.token.TokenPaymentParams;
import com.oppwa.mobile.connect.provider.Connect;
import com.oppwa.mobile.connect.provider.ITransactionListener;
import com.oppwa.mobile.connect.provider.OppPaymentProvider;
import com.oppwa.mobile.connect.provider.ThreeDSWorkflowListener;
import com.oppwa.mobile.connect.provider.Transaction;
import com.oppwa.mobile.connect.provider.TransactionType;

import java.util.LinkedHashSet;
import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity implements ITransactionListener,MethodChannel.Result {

    private Activity activity;
    private String  CHANNEL = "Hyperpay.demo.fultter/channel";
    private MethodChannel.Result Result;
    private String type = "";
    private String number,tokenId,holder,cvv,year,month,brand, checkoutId, expiryMonth, expiryYear;
    private  String mode = "";
    private String Lang = "";
    private String EnabledTokenization = "";
    private String ShopperResultUrl = "";
    OppPaymentProvider paymentProvider = new OppPaymentProvider(MainActivity.this, Connect.ProviderMode.LIVE);

    private Handler handler = new Handler(Looper.getMainLooper());


    @Override
    public void error(
            final String errorCode, final String errorMessage, final Object errorDetails) {

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        Result.error(errorCode, errorMessage, errorDetails);
                    }
                });
    }

    @Override
    public void success(final Object result) {
        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        Result.success(result);
                    }
                });
    }


    Transaction transaction = null;

    String brands = "";


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                        String checkoutId = call.argument("checkoutid");
                        String type = call.argument("type");
                        mode = call.argument("mode");
                        Lang = call.argument("lang");
                        ShopperResultUrl = call.argument("ShopperResultUrl");

                        Result = result;
                        if (call.method.equals("gethyperpayresponse")) {

                            type = call.argument("type");
                            mode = call.argument("mode");
                            checkoutId = call.argument("checkoutId");


                            if (type.equals("CustomUI")) {
                                brands = call.argument("brand");
                                number = call.argument("card_number");
                                holder = call.argument("holder_name");
                                year = call.argument("year");
                                month = call.argument("month");
                                cvv = call.argument("cvv");
                                EnabledTokenization = call.argument("EnabledTokenization");
                                openCustomUI(checkoutId);
                            }
                        } else {

                            error("1","This method name is not found","");
                        }

                    }});



        // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(hand);
    }


    private void openCustomUI(String checkoutId) {

        Toast.makeText(getApplicationContext(), Lang.equals("en_US")
                ? "Please Wait.."
                : "الرجاء الانتظار..", Toast.LENGTH_SHORT).show();

        if (!CardPaymentParams.isNumberValid(number , true)) {
            Toast.makeText(getApplicationContext(), Lang.equals("en_US")
                            ? "Card number is not valid for brand"
                            : "رقم البطاقة غير صالح",
                    Toast.LENGTH_SHORT).show();
        } else if (!CardPaymentParams.isHolderValid(holder)) {
            Toast.makeText(getApplicationContext(),  Lang.equals("en_US")
                            ? "Holder name is not valid"
                            : "اسم المالك غير صالح"
                    , Toast.LENGTH_SHORT).show();
        } else if (!CardPaymentParams.isExpiryYearValid(year)) {
            Toast.makeText(getApplicationContext(),  Lang.equals("en_US")
                            ? "Expiry year is not valid"
                            : "سنة انتهاء الصلاحية غير صالحة" ,
                    Toast.LENGTH_SHORT).show();
        } else if (!CardPaymentParams.isExpiryMonthValid(month)) {
            Toast.makeText(getApplicationContext(),  Lang.equals("en_US")
                            ? "Expiry month is not valid"
                            : "شهر انتهاء الصلاحية غير صالح"
                    , Toast.LENGTH_SHORT).show();
        } else if (!CardPaymentParams.isCvvValid(cvv)) {
            Toast.makeText(getApplicationContext(),  Lang.equals("en_US")
                            ? "CVV is not valid"
                            : "CVV غير صالح"
                    , Toast.LENGTH_SHORT).show();
        } else {
            try {
                PaymentParams paymentParams = new CardPaymentParams(
                        checkoutId, brands, number, holder, month, year, cvv
                ).setTokenizationEnabled(false);

                paymentParams.setShopperResultUrl(ShopperResultUrl);

                Transaction transaction = new Transaction(paymentParams);

                Connect.ProviderMode providerMode = Connect.ProviderMode.LIVE;

                paymentProvider = new OppPaymentProvider(getBaseContext(), providerMode);

                // Set up a listener to handle the transaction result
                // Submit the transaction

                paymentProvider.submitTransaction(transaction, this);

            } catch (PaymentException e) {
                error("0.1", e.getLocalizedMessage(), "");
            }
        }
    }


    @Override
    public void transactionFailed(Transaction transaction, PaymentError paymentError) {
        error("124", "Transaction Failed", "Transaction has failed.");
    }

    @Override
    public void transactionCompleted(Transaction transaction) {

        if (transaction == null) {
            error("123", "Transaction failed", "Transaction returned null.");
        }

        if (transaction.getTransactionType() == TransactionType.SYNC) {
            success("SYNC");
        } else {
            /* wait for the callback in the s */

            Uri uri = Uri.parse(transaction.getRedirectUrl());

            Intent intent2 = new Intent(Intent.ACTION_VIEW,uri);
            startActivity(intent2);
        }

    }

    @Override
    public void notImplemented() {

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        Result.notImplemented();
                    }
                });
    }


}