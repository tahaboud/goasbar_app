package goAsbar;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity implements MethodChannel.Result {

    private MethodChannel.Result Result;

    private final Handler handler = new Handler(Looper.getMainLooper());


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        String CHANNEL = "flutter/channel";
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {



                });



        // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(hand);
    }

    @Override
    public void error(
            @NonNull final String errorCode, final String errorMessage, final Object errorDetails) {

        handler.post(
                () -> Result.error(errorCode, errorMessage, errorDetails));
    }

    @Override
    public void success(final Object result) {
        handler.post(
                () -> Result.success(result));
    }


    @Override
    public void notImplemented() {

        handler.post(
                () -> Result.notImplemented());
    }


}