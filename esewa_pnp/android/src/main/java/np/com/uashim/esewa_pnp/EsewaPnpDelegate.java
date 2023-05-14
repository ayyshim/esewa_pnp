package np.com.uashim.esewa_pnp;

import android.app.Activity;
import android.content.Intent;

import com.esewa.android.sdk.payment.ESewaConfiguration;
import com.esewa.android.sdk.payment.ESewaPayment;
import com.esewa.android.sdk.payment.ESewaPaymentActivity;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class EsewaPnpDelegate implements PluginRegistry.ActivityResultListener {

    private final Activity activity;
    private MethodChannel.Result pendingResult;

    private ESewaConfiguration eSewaConfiguration;
    private ESewaPayment eSewaPayment;
    private static int REQUEST_CODE_PAYMENT = 1;
    private static String TAG = EsewaPnpDelegate.class.getName();

    public EsewaPnpDelegate(Activity activity) {
        this.activity = activity;
    }

    private void successResult(boolean success, String message) {
        if (pendingResult != null) {
            HashMap<String, Serializable> result = new HashMap<String, Serializable>();
            result.put("isSuccess", success);
            result.put("message", message);
            pendingResult.success(result);
            clearMethodCallAndResult();
        }
    }

    private void clearMethodCallAndResult() {
        pendingResult = null;
    }

    private void initConfig(String x, String y, String z) {
        eSewaConfiguration = new ESewaConfiguration()
                .clientId(x)
                .secretKey(y)
                .environment(z);
    }

    private void initPayment(HashMap payment) {
        String amount = String.valueOf(payment.get("amount"));
        String productName = (String) payment.get("productName");
        String productID =(String) payment.get("productID");
        String callBackURL = (String) payment.get("callBackURL");

        eSewaPayment = new ESewaPayment(
                amount,
                productName,
                productID,
                callBackURL
        );
    }

    void initPayment(MethodCall call, MethodChannel.Result result) {
        HashMap configMap = call.argument("config");
        assert configMap != null;
        String clientID = (String) configMap.get("clientID");
        String secretKey = (String) configMap.get("secretKey");
        String environment = (String) configMap.get("env");

        HashMap paymentMap = call.argument("payment");

        initConfig(clientID, secretKey, environment);
        assert paymentMap != null;
        initPayment(paymentMap);

        pendingResult = result;

        Intent intent = new Intent(activity, ESewaPaymentActivity.class);
        intent.putExtra(ESewaConfiguration.ESEWA_CONFIGURATION, eSewaConfiguration);
        intent.putExtra(ESewaPayment.ESEWA_PAYMENT, eSewaPayment);
        activity.startActivityForResult(intent, REQUEST_CODE_PAYMENT);

    }


    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {

        if(requestCode == REQUEST_CODE_PAYMENT) {
           if(resultCode == Activity.RESULT_OK) {
               String message = data.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE);
               successResult(true, message);
               return true;
           } else if(resultCode == Activity.RESULT_CANCELED) {
               successResult(false, "Payment process canceled by user");
               return true;
           } else if(resultCode == ESewaPayment.RESULT_EXTRAS_INVALID) {
               String message = data.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE);
               successResult(false, message);
               return true;
           } else if (pendingResult != null) {
               pendingResult.success(null);
               clearMethodCallAndResult();
               return true;
           }
        }

        return false;
    }
}
