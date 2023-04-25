package np.com.uashim.esewa_pnp;

import android.annotation.SuppressLint;
import android.app.Activity;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** EsewaPnpPlugin */
public class EsewaPnpPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {


  private static final String CHANNEL = "esewa_pnp";

  @SuppressLint("StaticFieldLeak")
  private static EsewaPnpPlugin instance;
  private MethodChannel channel;
  private EsewaPnpDelegate delegate;

  private Activity activity;
  private final Object initializationLock = new Object();

  // Plugin registration
  public static void registerWith(Registrar registrar) {
    if(instance == null) {
      instance = new EsewaPnpPlugin();
    }

    if(registrar.activity() != null) {
      instance.onAttachedToEngine(registrar.messenger());
      instance.onAttachedToActivity(registrar.activity());
      registrar.addActivityResultListener(instance.getActivityResultListener());
    }

  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if(activity == null || delegate == null) {
      result.error("no_activity", "esewa_pnp plugin requires a foreground activity.", null);
    }

    if(call.method.equals("initPayment")) {
      delegate.initPayment(call, result);
    }
  }

  private void onAttachedToEngine(BinaryMessenger messenger) {
    synchronized (initializationLock) {
      if(channel != null) {
        return;
      }
    }

    channel = new MethodChannel(messenger, CHANNEL);
    channel.setMethodCallHandler(this);
  }

  private void onAttachedToActivity(Activity activity) {
    this.activity = activity;
    delegate = new EsewaPnpDelegate(activity);
  }

  private PluginRegistry.ActivityResultListener getActivityResultListener() {
    return delegate;
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    channel.setMethodCallHandler(this);
    channel = null;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    if(getActivityResultListener() != null) {
      binding.removeActivityResultListener(getActivityResultListener());
    }
    onAttachedToActivity(binding.getActivity());
    binding.addActivityResultListener(getActivityResultListener());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
    delegate = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    if(getActivityResultListener() != null) {
      binding.removeActivityResultListener(getActivityResultListener());
    }
    onAttachedToActivity(binding.getActivity());
    binding.addActivityResultListener(getActivityResultListener());
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
    delegate = null;
  }
}
