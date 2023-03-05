package com.goasbar.goasbar;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.oppwa.mobile.connect.checkout.dialog.CheckoutActivity;
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

    private String  CHANNEL = "Hyperpay.demo.fultter/channel";
    private String  CustomCHANNEL = "Hyperpay.demo.custom.fultter/channel";
    private String checkoutid = "";
    private MethodChannel.Result Result;
    private String type = "";
    private String number,holder,cvv,year,month,brand;
    private  String mode = "";
    private String STCPAY = "";
    OppPaymentProvider paymentProvider = new OppPaymentProvider(MainActivity.this, Connect.ProviderMode.TEST);

    private Handler handler = new Handler(Looper.getMainLooper());


    boolean check(String ccNumber) {
        int sum = 0;
        boolean alternate = false;
        for (int i = ccNumber.length() - 1; i >= 0; i--)
        {
            int n = Integer.parseInt(ccNumber.substring(i, i + 1));
            if (alternate)
            {
                n *= 2;
                if (n > 9)
                {
                    n = (n % 10) + 1;
                }
            }
            sum += n;
            alternate = !alternate;
        }
        return (sum % 10 == 0);

    }

    @Override
    public void error(
            final String errorCode, final String errorMessage, final Object errorDetails) {

        Log.d("ERRRRRRR", "ERRRRRRR ");

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
        Log.d("SUCCESS", "SUCCESS " + Result.success(result));

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        Result.success(result);
                    }
                });
    }

    Transaction transaction = null;

    String MadaRegex = "";

    String ptMadaVExp = "";
    String ptMadaMExp = "";
    String brands = "";

    String istoken = "";
    String token = "";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                        Result = result;
                        if (call.method.equals("gethyperpayresponse")) {

                            type = call.argument("type");
                            mode = call.argument("mode");
                            checkoutid = call.argument("checkoutid");


                            if (type.equals("CustomUI")){
                                brands = call.argument("brand");
                                STCPAY = call.argument("STCPAY");
                                number = call.argument("card_number");
                                holder = call.argument("holder_name");
                                year = call.argument("year");
                                month = call.argument("month");
                                cvv = call.argument("cvv");
                                ptMadaVExp = call.argument("MadaRegexV");
                                ptMadaMExp = call.argument("MadaRegexM");
                                istoken = call.argument("istoken");
                                token = call.argument("token");

                                openCustomUI(checkoutid);
                            }
                        } else {

                            error("1","Method name is not found","");
                        }
                    }});


        // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(hand);
    }


    private void openCustomUI(String checkoutid) {

        Toast.makeText(getBaseContext(),"Waiting..",Toast.LENGTH_LONG).show();

        if (mode.equals("LIVE")) {
            paymentProvider = new OppPaymentProvider(MainActivity.this, Connect.ProviderMode.LIVE);
        }


        if (STCPAY.equals("enabled")) {

            try {
                PaymentParams paymentParams = new PaymentParams(checkoutid,"STC_PAY");
                paymentParams.setShopperResultUrl("com.goasbar.goasbar://result");
                Transaction transaction = new Transaction(paymentParams);

                paymentProvider.setThreeDSWorkflowListener(new ThreeDSWorkflowListener() {
                    @Override
                    public Activity onThreeDSChallengeRequired() {
                        return MainActivity.this;
                    }
                });
                paymentProvider.submitTransaction(transaction, MainActivity.this);
            } catch (PaymentException e) {
                e.printStackTrace();
            }


        } else if (istoken.equals("true")) {

            if (!CardPaymentParams.isCvvValid(cvv)) {

                Toast.makeText(getBaseContext(),"CVV is Invalid",Toast.LENGTH_LONG).show();
            } else {

                try {
                    TokenPaymentParams paymentParams = new TokenPaymentParams(checkoutid, token, " ",cvv);

                    paymentParams.setShopperResultUrl("com.goasbar.goasbar://result");

                    Transaction transaction = new Transaction(paymentParams);

                    paymentProvider.setThreeDSWorkflowListener(new ThreeDSWorkflowListener() {
                        @Override
                        public Activity onThreeDSChallengeRequired() {
                            return MainActivity.this;
                        }
                    });


                    paymentProvider.submitTransaction(transaction, MainActivity.this);

                } catch (PaymentException e) {
                    e.printStackTrace();
                }

            }



        } else {

            boolean result = check(number);


            if (!result) {
                Toast.makeText(getBaseContext(),"Card Number is Invalid",Toast.LENGTH_LONG).show();
            } else if (!CardPaymentParams.isNumberValid(number)) {
                Toast.makeText(getBaseContext(),"Card Number is Invalid",Toast.LENGTH_LONG).show();
            } else if (!CardPaymentParams.isHolderValid(holder) ) {
                Toast.makeText(getBaseContext(),"Card Holder is Invalid",Toast.LENGTH_LONG).show();
            } else if (!CardPaymentParams.isExpiryYearValid(year)) {
                Toast.makeText(getBaseContext(),"Expiry Year is Invalid",Toast.LENGTH_LONG).show();
            } else if (!CardPaymentParams.isExpiryMonthValid(month)) {
                Toast.makeText(getBaseContext(),"Expiry Month is Invalid",Toast.LENGTH_LONG).show();
            } else if (!CardPaymentParams.isCvvValid(cvv)) {
                Toast.makeText(getBaseContext(),"CVV is Invalid",Toast.LENGTH_LONG).show();
            } else {
                String firstnumber = String.valueOf(number.charAt(0));

                // To add MADA

                if (brands.equals("mada")) {
                    String bin = number.substring(0,6);
                    if (bin.matches(ptMadaVExp) || bin.matches(ptMadaMExp)) {
                        brand = "MADA";
                    } else {
                        Toast.makeText(getBaseContext(),"This card is not Mada card",Toast.LENGTH_LONG).show();
                    }
                } else {
                    if (firstnumber.equals("4")) {
                        brand = "VISA";
                    } else if (firstnumber.equals("5")) {
                        brand = "MASTER";
                    }
                }

                try {
                    PaymentParams paymentParams = new CardPaymentParams(
                            checkoutid,
                            brand,
                            number,
                            holder,
                            month,
                            year,
                            cvv
                    );

                    paymentParams.setShopperResultUrl("com.goasbar.goasbar://result");

                    Transaction transaction = new Transaction(paymentParams);

                    paymentProvider.setThreeDSWorkflowListener(new ThreeDSWorkflowListener() {
                        @Override
                        public Activity onThreeDSChallengeRequired() {
                            return MainActivity.this;
                        }
                    });

                    paymentProvider.submitTransaction(transaction, MainActivity.this);

                } catch (PaymentException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    @Override
    public void transactionFailed(Transaction transaction, PaymentError paymentError) {

    }

    @Override
    public void transactionCompleted(Transaction transaction) {

        if (transaction == null) {
            return;
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d("ACTIVITY REUSLT", "ACTIVITY REUSLT");

        switch (resultCode) {
            case CheckoutActivity.RESULT_OK:
                /* transaction completed */


                Transaction transaction = data.getParcelableExtra(CheckoutActivity.CHECKOUT_RESULT_TRANSACTION);


                /* resource path if needed */
                String resourcePath = data.getStringExtra(CheckoutActivity.CHECKOUT_RESULT_RESOURCE_PATH);

                if (transaction.getTransactionType() == TransactionType.SYNC) {
                    /* check the result of synchronous transaction */

                    success("SYNC");


                } else {
                    /* wait for the asynchronous transaction callback in the onNewIntent() */
                }

                break;
            case CheckoutActivity.RESULT_CANCELED:
                /* shopper canceled the checkout process */

                Toast.makeText(getBaseContext(),"canceled",Toast.LENGTH_LONG).show();

                error("2","Canceled","");

                break;
            case CheckoutActivity.RESULT_ERROR:
                /* error occurred */

                PaymentError error = data.getParcelableExtra(CheckoutActivity.CHECKOUT_RESULT_ERROR);

                Toast.makeText(getBaseContext(),"error",Toast.LENGTH_LONG).show();

                Log.e("errorrr",String.valueOf(error.getErrorInfo()));

                Log.e("errorrr2",String.valueOf(error.getErrorCode()));

                Log.e("errorrr3",String.valueOf(error.getErrorMessage()));

                Log.e("errorrr4",String.valueOf(error.describeContents()));

                error("3","Checkout Result Error","");

        }
    }

    @Override
    protected void onNewIntent(Intent intent) {

        super.onNewIntent(intent);

        if (intent.getScheme().equals("com.goasbar.goasbar")) {

            success("success");

        }
    }
}